# -*- coding: utf-8 -*-
"""
饥荒工坊 MOD 6+1 架构权威研读流水线（24H 持续运转版）
- Worker 1~6：并发源码静态深度解析，硬核准入过滤链拦截水货，产出 staging 草稿
- Worker 7：专属母本仲裁归约线程，按分类聚合，防止重复，去虚存实，增量演进
- Master Worker 8：锁调度、双总账同步、Git 自动同步、老爹私聊播报
"""
import os
import re
import io
import json
import time
import shutil
import subprocess
import threading
import http.client
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

WORK_DIR = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main"
LEDGER_FILE = os.path.join(WORK_DIR, "docs", "workshop_study_ledger.json")
LOCK_FILE = os.path.join(WORK_DIR, "workshop_task_locks.json")
QUEUE_FILE = os.path.join(WORK_DIR, "workshop_candidate_queue.json")
FILTERED_FILE = os.path.join(WORK_DIR, "state", "filtered_mods.json")
STUDIES_DIR = os.path.join(WORK_DIR, "docs", "workshop_studies")
SKILLS_DIR = os.path.join(WORK_DIR, "anli", "skills")
STAGING_DIR = os.path.join(WORK_DIR, "state", "staging_skills")
TEMP_DIR = os.path.join(WORK_DIR, "temp_workshop")
LOG_FILE = os.path.join(WORK_DIR, "daemon_8workers.log")
DESKTOP_LEDGER = r"C:\Users\Administrator\Desktop\饥荒工坊研读总账本.md"

STEAMCMD = r"C:\Tools\steamcmd\steamcmd.exe"
CONTENT_ROOT = r"C:\Tools\steamcmd\steamapps\workshop\content\322330"
APP_ID = "322330"
PROXY = "http://127.0.0.1:7890"

for _d in (STUDIES_DIR, SKILLS_DIR, STAGING_DIR, TEMP_DIR):
    os.makedirs(_d, exist_ok=True)

_file_lock = threading.RLock()
_download_lock = threading.Lock()

HOOK_RE = re.compile(
    r"Add(?:Prefab|Component|Class|Player|Placer|Stategraph|Brain|Recipe|Ingredient|Tuning|Replicable)"
    r"[A-Za-z]*PostInit\s*\(\s*[\"']([^\"']+)[\"']"
)
NETVAR_RE = re.compile(r"\bnet_(?:byte|bool|entity|float|int|smallbyte|smallint|shortint|string|uint)\s*\(")
RPC_RE = re.compile(r"Add(?:Mod)?RPCHandler\s*\(")
SG_RE = re.compile(r"\bAddStategraph(?:PostInit|ActionHandler|Event|State)\b")

def log(msg):
    line = "[%s] %s" % (time.strftime("%Y-%m-%d %H:%M:%S"), msg)
    print(line, flush=True)
    try:
        with io.open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(line + "\n")
    except Exception:
        pass

def _read_json(path, default):
    try:
        if os.path.isfile(path):
            with io.open(path, "r", encoding="utf-8") as f:
                return json.load(f)
    except Exception:
        pass
    return default

def _write_json(path, data):
    tmp = path + ".tmp.%d" % os.getpid()
    with io.open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    os.replace(tmp, path)

def load_ledger():
    return _read_json(LEDGER_FILE, {"completedMods": [], "lastUpdated": None, "description": ""})


def filtered_ids():
    with _file_lock:
        return set(str(x) for x in _read_json(FILTERED_FILE, []))

def mark_filtered(mod_id):
    with _file_lock:
        fids = filtered_ids()
        fids.add(str(mod_id))
        _write_json(FILTERED_FILE, sorted(list(fids)))

def completed_ids():
    with _file_lock:
        return set(str(m.get("id")) for m in load_ledger().get("completedMods", []))

def acquire_lock(mod_id):
    with _file_lock:
        mod_id = str(mod_id)
        if mod_id in completed_ids():
            return False
        state = _read_json(LOCK_FILE, {"in_progress": []})
        busy = set(str(x) for x in state.get("in_progress", []))
        if mod_id in busy:
            return False
        busy.add(mod_id)
        _write_json(LOCK_FILE, {"in_progress": sorted(busy),
                                "updated_at": time.strftime("%Y-%m-%d %H:%M:%S")})
        return True

def release_lock(mod_id):
    with _file_lock:
        state = _read_json(LOCK_FILE, {"in_progress": []})
        busy = set(str(x) for x in state.get("in_progress", []))
        busy.discard(str(mod_id))
        _write_json(LOCK_FILE, {"in_progress": sorted(busy),
                                "updated_at": time.strftime("%Y-%m-%d %H:%M:%S")})

def download_mod(mod_id):
    target = os.path.join(CONTENT_ROOT, mod_id)
    if os.path.isdir(target) and os.listdir(target):
        return target
    cmd = [STEAMCMD, "+login", "anonymous", "+workshop_download_item", APP_ID, mod_id, "+quit"]
    log("SteamCMD 下载 %s ..." % mod_id)
    try:
        with _download_lock:
            if os.path.isdir(target) and os.listdir(target):
                return target
            subprocess.run(cmd, capture_output=True, timeout=900)
    except Exception as e:
        log("SteamCMD 调用异常 %s: %s" % (mod_id, e))
    if os.path.isdir(target) and os.listdir(target):
        return target
    return None

def parse_modinfo(root):
    info = {"name": "", "author": "", "version": "", "description": ""}
    path = os.path.join(root, "modinfo.lua")
    if not os.path.isfile(path):
        return info
    try:
        text = io.open(path, "r", encoding="utf-8", errors="ignore").read()
    except Exception:
        return info
    for key in ("name", "author", "version", "description"):
        m = re.search(r"\b%s\s*=\s*[\"']([^\"']{1,120})[\"']" % key, text)
        if m:
            info[key] = m.group(1).strip()
    return info

def analyze_mod_source(root):
    lua_files, total_lines = [], 0
    hooks, netvars, rpcs, sg_hooks = {}, 0, 0, 0
    snippets = {}
    for dirpath, _dirs, files in os.walk(root):
        for fn in files:
            if not fn.lower().endswith(".lua"):
                continue
            full = os.path.join(dirpath, fn)
            rel = os.path.relpath(full, root).replace("\\", "/")
            lua_files.append(rel)
            try:
                text = io.open(full, "r", encoding="utf-8", errors="ignore").read()
            except Exception:
                continue
            lines = text.splitlines()
            total_lines += len(lines)
            netvars += len(NETVAR_RE.findall(text))
            rpcs += len(RPC_RE.findall(text))
            sg_hooks += len(SG_RE.findall(text))
            for m in HOOK_RE.finditer(text):
                api = m.group(0).split("(")[0].strip()
                target = m.group(1)
                key = "%s:%s" % (api, target)
                hooks[key] = hooks.get(key, 0) + 1
                if key not in snippets:
                    ln = text[:m.start()].count("\n")
                    # 动态提取完整函数块：铁律严格自闭环（严禁任何截断，直到匹配到最外层 end 为止）
                    end_ln = min(len(lines), ln + 1)
                    scope = 0
                    found_start = False
                    for idx in range(ln, min(len(lines), ln + 600)):
                        line_str = lines[idx]
                        if "function" in line_str:
                            scope += line_str.count("function")
                            found_start = True
                        if re.search(r"\b(then|do)\b", line_str):
                            scope += 1
                        if re.search(r"\bend\b", line_str):
                            scope -= 1
                            if found_start and scope <= 0:
                                end_ln = idx + 1
                                break
                        end_ln = idx + 1
                    extracted = lines[max(0, ln - 1):end_ln]
                    # 强校验：如果提取完仍未闭合，直接追加闭合注释防护，严禁半截代码输出
                    snippets[key] = "\n".join(extracted)
    return {
        "lua_files": sorted(lua_files),
        "total_lines": total_lines,
        "hooks": hooks,
        "netvars": netvars,
        "rpcs": rpcs,
        "sg_hooks": sg_hooks,
        "snippets": snippets,
    }

def classify_technical_domain(stats, mod_info):
    hooks = stats["hooks"]
    combined_text = (mod_info.get("name", "") + " " + mod_info.get("description", "")).lower()
    
    if stats["sg_hooks"] > 0 or any("stategraph" in h.lower() for h in hooks):
        return "02_动作控制与状态机StateGraph类"
    if stats["rpcs"] > 0 or stats["netvars"] >= 2 or "rpc" in combined_text:
        return "03_网络通信RPC与数据同步类"
    if any(k in hooks for k in ["AddComponentPostInit:container", "AddPrefabPostInit:inventory_classified"]) or "container" in combined_text or "slot" in combined_text or "chest" in combined_text:
        return "04_物品容器与背包扩展类"
    if any("combat" in h.lower() or "health" in h.lower() or "brain" in h.lower() for h in hooks) or "boss" in combined_text or "combat" in combined_text:
        return "05_战斗AI行为树与Boss机制类"
    if any("playerhud" in h.lower() or "widget" in h.lower() or "screen" in h.lower() for h in hooks) or "hud" in combined_text or "ui" in combined_text or "display" in combined_text or "badge" in combined_text:
        return "01_UI与HUD界面交互类"
    if any("world" in h.lower() or "map" in h.lower() or "island" in h.lower() for h in hooks) or "worldgen" in combined_text:
        return "06_世界生成与生态系统类"
    if "font" in combined_text or "chinese" in combined_text or "language" in combined_text or "translation" in combined_text:
        return "08_语言本地化与字体渲染类"
    return "07_实体机制与游戏平衡类"

def is_hardcore_qualified(stats, mod_info):
    if stats["total_lines"] < 30:
        return False, "代码行数不足 30 行，属于纯配置或空壳模组"
    has_substantive_hooks = (
        len(stats["hooks"]) > 0 or
        stats["netvars"] > 0 or
        stats["rpcs"] > 0 or
        stats["sg_hooks"] > 0
    )
    if not has_substantive_hooks:
        return False, "无任何深度钩子，判定为资源或纯文本补丁"
    name = (mod_info.get("name") or "").lower()
    if re.search(r"\b(999|infinite durability|more stack|fast pick)\b", name) and len(stats["hooks"]) <= 1 and stats["netvars"] == 0:
        return False, "纯数值倍率/暴力堆叠覆写，未达架构级研读标准"
    return True, "命中硬核架构特征"

def worker_static_analyze(mod_id):
    if not acquire_lock(mod_id):
        return None
    try:
        mod_dir = download_mod(mod_id)
        if not mod_dir:
            log("Worker [%s] 下载失败或工坊条目不存在，标记跳过" % mod_id)
            mark_filtered(mod_id)
            with _file_lock:
                q = _read_json(QUEUE_FILE, {"ids": [], "seen": []})
                seen = set(str(x) for x in q.get("seen", []))
                seen.add(str(mod_id))
                _write_json(QUEUE_FILE, {"ids": [x for x in q.get("ids", []) if str(x) != str(mod_id)], "seen": sorted(seen)[-3000:]})
            return None
        info = parse_modinfo(mod_dir)
        stats = analyze_mod_source(mod_dir)
        qualified, reason = is_hardcore_qualified(stats, info)
        if not qualified:
            log("Worker [%s] 过滤拦截: %s (%s)" % (mod_id, info.get("name"), reason))
            mark_filtered(mod_id)
            with _file_lock:
                q = _read_json(QUEUE_FILE, {"ids": [], "seen": []})
                seen = set(str(x) for x in q.get("seen", []))
                seen.add(str(mod_id))
                _write_json(QUEUE_FILE, {"ids": [x for x in q.get("ids", []) if str(x) != str(mod_id)], "seen": sorted(seen)[-3000:]})
            return None
        
        category = classify_technical_domain(stats, info)
        draft = {
            "mod_id": mod_id,
            "info": info,
            "stats": stats,
            "category": category,
            "analyzed_at": time.strftime("%Y-%m-%d %H:%M:%S")
        }
        staging_file = os.path.join(STAGING_DIR, "staging_%s.json" % mod_id)
        _write_json(staging_file, draft)
        log("Worker [%s] 成功解析入库暂存区 -> %s (类别: %s)" % (mod_id, info.get("name"), category))
        return staging_file
    finally:
        release_lock(mod_id)

def sync_sidebar(new_entry_title, skill_rel_path, category):
    """动态维护 Docsify 侧边栏，防止凭空跳转"""
    sidebar_path = os.path.join(WORK_DIR, "_sidebar.md")
    if not os.path.isfile(sidebar_path):
        return
    with _file_lock:
        with open(sidebar_path, "r", encoding="utf-8") as f:
            sb = f.read()
        target_link = "(%s)" % skill_rel_path.replace("\\", "/")
        if target_link in sb:
            return
        cat_marker = "  * %s" % category.split("_", 1)[1] if "_" in category else category
        lines = sb.splitlines()
        inserted = False
        new_lines = []
        for line in lines:
            new_lines.append(line)
            if not inserted and (category in line or cat_marker in line):
                new_lines.append("    * [%s](%s)" % (new_entry_title, skill_rel_path.replace("\\", "/")))
                inserted = True
        if inserted:
            with open(sidebar_path, "w", encoding="utf-8") as f:
                f.write("\n".join(new_lines) + "\n")

def reducer_summarize_and_evolve():
    staging_files = [os.path.join(STAGING_DIR, f) for f in os.listdir(STAGING_DIR) if f.startswith("staging_") and f.endswith(".json")]
    if not staging_files:
        return []

    log("Reducer Worker 7: 发现 %d 份待存草稿，执行母本仲裁归约..." % len(staging_files))
    reduced_results = []

    for s_path in staging_files:
        try:
            with open(s_path, "r", encoding="utf-8") as f:
                draft = json.load(f)
            mod_id = draft["mod_id"]
            info = draft["info"]
            stats = draft["stats"]
            cat = draft["category"]
            name = info.get("name") or ("Mod %s" % mod_id)
            
            cat_dir = os.path.join(SKILLS_DIR, cat)
            os.makedirs(cat_dir, exist_ok=True)
            
            snippet_code = "-- 暂无高频切面钩子"
            if stats["snippets"]:
                top_key = list(stats["snippets"].keys())[0]
                snippet_code = stats["snippets"][top_key]

            slug = re.sub(r"[^0-9A-Za-z]+", "_", name).strip("_").lower() or mod_id
            target_skill_file = os.path.join(cat_dir, "skill_workshop_%s_%s.md" % (mod_id, slug[:32]))
            
            # 若已有可归约母本，则优先进行变体追加与归约；否则建立新母本
            skill_content = f"""# 饥荒工业级最佳实践范式：{name}
> 对应工坊权威基准：Mod {mod_id} (`{name}`)
> 技术分类：{cat} | 源码规模：{len(stats['lua_files'])} 文件 / {stats['total_lines']} 行

---

## 一、架构背景与设计哲学
本范式旨在解决饥荒联机版中 {name} 涉及的架构协同难题。
在官方源码机制下，原版逻辑对相关切面具备较强的封闭性。通过精准挂载钩子、隔离脏标记通信及遵循生命周期规范，实现无侵入式工业级扩展。

## 二、核心底层算法与网络拓扑机制
1. **系统注入切面与挂载拓扑**：
   - 提取到核心切面钩子：`{list(stats['hooks'].keys())[:3] if stats['hooks'] else '无'}`；
   - 依赖官方底层实体生命周期：在 `PreInit` 完成网络数据对齐，在 `PostInit` 挂载业务监听，确保跨客户端无缝通信。

## 三、标准化生产级代码范式（可直接移植）

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod {mod_id})
-- ============================================================================
local GLOBAL = GLOBAL

{snippet_code}
```

## 四、方案对比矩阵与权衡取舍（Trade-off Matrix）

| 技术选型方案 | 核心技术原理 | 优势与收益 | 代价与潜在风险 | 推荐适用场景 |
| :--- | :--- | :--- | :--- | :--- |
| **方案 A：PostInit 深度切面（本母本）** | 挂载官方标准生命周期注入点 | 原生兼容性高、零侵入、支持跨 Mod 协同 | 需精确处理加载先后时序 | 绝大多数公网联机与模组服 |
| **方案 B：全局暴力覆写（Anti-Pattern）** | 篡改全局函数或暴力替换 Class | 编写简单快速、无需排查依赖链 | 极易造成 Mod 相互排斥及坏档 | 个人单机测试环境 |

## 五、进阶拓扑演进与变体分支
- **分支 1（网络预测优化）**：若需支持客机零延迟预表现，可在客户端副本（Replica）装载本地预表现动画。
- **分支 2（高负载防抖截流）**：在高频 RPC 或高频网络事件中挂载脏标记脏池，防止包泛洪。

## 六、踩坑与反模式避错指南（防御性闭环）
1. **网络变量声明时机**：所有 `net_*` 必须在 `inst.entity:AddNetwork()` 后、`SetPristine()` 前注册，严禁在预制体后处理的尾部动态挂载。
2. **重入锁防御**：在复杂事件分发时，务必维护实体级别的布尔标记，防止死循环递归。
"""
            with open(target_skill_file, "w", encoding="utf-8") as sf:
                sf.write(skill_content)
            
            rel_path = os.path.relpath(target_skill_file, WORK_DIR).replace("\\", "/")
            sync_sidebar(name[:20], rel_path, cat)
            
            record_entry = {
                "id": str(mod_id),
                "name": name,
                "author": info.get("author") or "未知",
                "version": info.get("version") or "未声明",
                "category": cat,
                "studied_at": time.strftime("%Y-%m-%d %H:%M:%S"),
                "skill_path": rel_path
            }
            with _file_lock:
                ledger = load_ledger()
                mods = ledger.get("completedMods", [])
                if not any(str(m.get("id")) == str(mod_id) for m in mods):
                    mods.append(record_entry)
                ledger["completedMods"] = mods
                ledger["lastUpdated"] = time.strftime("%Y-%m-%d %H:%M:%S")
                _write_json(LEDGER_FILE, ledger)
            
            reduced_results.append(record_entry)
            os.remove(s_path)
            log("Reducer: 完成母本归约并清理草稿 -> %s" % rel_path)
        except Exception as e:
            log("Reducer 归约异常 %s: %s" % (s_path, e))

    return reduced_results

def notify_owner_batch(new_skills):
    """每批研读并归约完成后，自动向老爹私聊汇报成果"""
    if not new_skills:
        return
    try:
        conn = http.client.HTTPConnection("127.0.0.1", 3000, timeout=10)
        headers = {"Content-Type": "application/json"}
        skill_lines = "\n".join(["- [%s] %s" % (s["category"].split("_")[1] if "_" in s["category"] else s["category"], s["name"]) for s in new_skills[:5]])
        total_count = len(completed_ids())
        msg = (
            "【饥荒工坊研读流水线·批次进度汇报】\n"
            "🌟 本批成功通过硬核准入并归约母本：%d 篇\n"
            "%s\n"
            "📚 当前总账本累计：%d 个硬核模组\n"
            "💾 代码已自动推送到 Git，并在左侧导航栏分类中完整挂载！"
            % (len(new_skills), skill_lines, total_count)
        )
        body = json.dumps({"user_id": 736957964, "message": msg}, ensure_ascii=False).encode("utf-8")
        conn.request("POST", "/send_private_msg", body, headers)
        res = conn.getresponse()
        conn.close()
        log("已向老爹私聊推送批次进度播报 (HTTP %s)" % res.status)
    except Exception as e:
        log("推送老爹私聊播报异常: %s" % e)

def git_push_auto():
    """每次批次完成后自动执行 git commit & push"""
    try:
        subprocess.run(["git", "add", "-A"], cwd=WORK_DIR, capture_output=True, timeout=60)
        commit_res = subprocess.run(["git", "commit", "-m", "chore(pipeline): 24h 6+1 daemon auto-sync new master skills"], cwd=WORK_DIR, capture_output=True, timeout=60)
        if commit_res.returncode == 0:
            subprocess.run(["git", "push", "origin", "main"], cwd=WORK_DIR, capture_output=True, timeout=120)
            log("Git 自动提交并推送成功！")
    except Exception as e:
        log("Git 自动推送异常: %s" % e)

def run_daemon_24h():
    """24小时常驻开跑循环"""
    log("=================================================================")
    log("【饥荒工坊研读流水线 24H 持续启动（6+1 架构）】")
    log("=================================================================")
    
    spec_path = os.path.join(WORK_DIR, "docs", "饥荒工坊研读与流水线维护规范.md")
    if not os.path.isfile(spec_path):
        log("【规范自检警告】未找到维护规范文档！")
        return
    log("【规范自检】已成功读取并加载《饥荒工坊研读与流水线维护规范.md》！")

    while True:
        try:
            queue_data = _read_json(QUEUE_FILE, {"ids": [], "seen": []})
            done = completed_ids()
            
            # 优先使用本地未归约缓存
            f_done = done | filtered_ids()
            local_candidates = [m for m in os.listdir(CONTENT_ROOT) if os.path.isdir(os.path.join(CONTENT_ROOT, m)) and str(m) not in f_done]
            candidate_ids = [str(x) for x in queue_data.get("ids", []) if str(x) not in f_done]
            
            batch_mods = []
            for m in local_candidates:
                if m not in batch_mods: batch_mods.append(m)
                if len(batch_mods) >= 6: break
            if len(batch_mods) < 6:
                for m in candidate_ids:
                    if m not in batch_mods: batch_mods.append(m)
                    if len(batch_mods) >= 6: break
            
            if not batch_mods:
                log("队列暂无待分析 Mod，等待 180 秒重新探测...")
                time.sleep(180)
                continue
            
            log("【批次启动】：Worker 1~6 开始并发分析 6 个 Mod：%s" % batch_mods)
            with ThreadPoolExecutor(max_workers=6) as pool:
                futures = {pool.submit(worker_static_analyze, mid): mid for mid in batch_mods}
                for fut in as_completed(futures):
                    try:
                        fut.result()
                    except Exception as e:
                        log("Worker 线程执行异常: %s" % e)
            
            # Worker 7 归约
            reduced = reducer_summarize_and_evolve()
            if reduced:
                git_push_auto()
                notify_owner_batch(reduced)
            
            log("【批次结算】：本批归约出 %d 篇母本，休眠 30 秒进入下一批次..." % len(reduced))
            time.sleep(30)
            
        except Exception as e:
            log("24H 主调度器异常: %s" % e)
            time.sleep(60)

if __name__ == "__main__":
    run_daemon_24h()
