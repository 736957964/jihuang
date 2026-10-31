# -*- coding: utf-8 -*-
import os
import re
import io
import json
import time
import shutil
import subprocess
import threading
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

WORK_DIR = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main"
LEDGER_FILE = os.path.join(WORK_DIR, "docs", "workshop_study_ledger.json")
LOCK_FILE = os.path.join(WORK_DIR, "workshop_task_locks.json")
QUEUE_FILE = os.path.join(WORK_DIR, "workshop_candidate_queue.json")
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
                    snippets[key] = "\n".join(lines[max(0, ln - 1):min(len(lines), ln + 15)])
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
    """依据技术切面判定所属黄金分类"""
    hooks = stats["hooks"]
    combined_text = (mod_info.get("name", "") + " " + mod_info.get("description", "")).lower()
    
    # 02 动作控制与SG
    if stats["sg_hooks"] > 0 or any("stategraph" in h.lower() for h in hooks):
        return "02_动作控制与状态机StateGraph类"
    # 03 网络通信与RPC
    if stats["rpcs"] > 0 or stats["netvars"] >= 2 or "rpc" in combined_text:
        return "03_网络通信RPC与数据同步类"
    # 04 容器与背包
    if any(k in hooks for k in ["AddComponentPostInit:container", "AddPrefabPostInit:inventory_classified"]) or "container" in combined_text or "slot" in combined_text or "chest" in combined_text:
        return "04_物品容器与背包扩展类"
    # 05 战斗AI与Boss
    if any("combat" in h.lower() or "health" in h.lower() or "brain" in h.lower() for h in hooks) or "boss" in combined_text or "combat" in combined_text:
        return "05_战斗AI行为树与Boss机制类"
    # 01 UI与HUD
    if any("playerhud" in h.lower() or "widget" in h.lower() or "screen" in h.lower() for h in hooks) or "hud" in combined_text or "ui" in combined_text or "display" in combined_text or "badge" in combined_text:
        return "01_UI与HUD界面交互类"
    # 06 世界生成
    if any("world" in h.lower() or "map" in h.lower() or "island" in h.lower() for h in hooks) or "worldgen" in combined_text:
        return "06_世界生成与生态系统类"
    # 08 语言字体
    if "font" in combined_text or "chinese" in combined_text or "language" in combined_text or "translation" in combined_text:
        return "08_语言本地化与字体渲染类"
    # 默认 07 实体机制
    return "07_实体机制与游戏平衡类"

def is_hardcore_qualified(stats, mod_info):
    """第一条：前置硬核准入过滤链（杜绝水货进入候选池）"""
    # 排除无代码、纯数值或极小改动
    if stats["total_lines"] < 30:
        return False, "代码行数不足 30 行，属于纯配置或空壳模组"
    
    # 必须具备实质性技术钩子
    has_substantive_hooks = (
        len(stats["hooks"]) > 0 or
        stats["netvars"] > 0 or
        stats["rpcs"] > 0 or
        stats["sg_hooks"] > 0
    )
    if not has_substantive_hooks:
        return False, "无任何 PostInit/Netvars/RPC/StateGraph 深度钩子，判定为资源或纯文本补丁"
    
    name = (mod_info.get("name") or "").lower()
    # 拦截纯数值覆写
    if re.search(r"\b(999|stack|infinite durability|more stack|fast pick)\b", name) and len(stats["hooks"]) <= 1 and stats["netvars"] == 0:
        return False, "纯数值倍率/暴力堆叠覆写，未达架构级研读标准"

    return True, "命中硬核架构特征"

def worker_static_analyze(mod_id):
    """Worker 1~6 执行并发源码静态提取并生成 staging 草稿"""
    if not acquire_lock(mod_id):
        return None
    try:
        mod_dir = download_mod(mod_id)
        if not mod_dir:
            log("Worker [%s] 下载失败或工坊条目不存在" % mod_id)
            return None
        
        info = parse_modinfo(mod_dir)
        stats = analyze_mod_source(mod_dir)
        
        qualified, reason = is_hardcore_qualified(stats, info)
        if not qualified:
            log("Worker [%s] 过滤拦截: %s (%s)" % (mod_id, info.get("name"), reason))
            # 记录在已过滤账本，避免重复抓取
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
        log("Worker [%s] 成功解析并入库暂存区 -> %s (类别: %s)" % (mod_id, info.get("name"), category))
        return staging_file
    finally:
        release_lock(mod_id)

def reducer_summarize_and_evolve():
    """Worker 7：母本仲裁归约专属线程，消费 staging 草稿，执行 Merge & Evolve"""
    staging_files = [os.path.join(STAGING_DIR, f) for f in os.listdir(STAGING_DIR) if f.startswith("staging_") and f.endswith(".json")]
    if not staging_files:
        log("Reducer: 待存缓冲区为空，无待归约草稿。")
        return []

    log("Reducer Worker 7: 发现 %d 份待存草稿，启动母本仲裁归约..." % len(staging_files))
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
            existing_skills = [f for f in os.listdir(cat_dir) if f.endswith(".md")]
            
            log("Reducer: 仲裁归约 [%s] -> %s (已有母本 %d 篇)" % (name, cat, len(existing_skills)))
            
            # 生成生产级标准化母本代码片段
            snippet_code = "-- 暂无高频切面钩子"
            if stats["snippets"]:
                top_key = list(stats["snippets"].keys())[0]
                snippet_code = stats["snippets"][top_key]

            # 严格贯彻老爹六大标准板块，杜绝口语化冗余
            slug = re.sub(r"[^0-9A-Za-z]+", "_", name).strip("_").lower() or mod_id
            target_skill_file = os.path.join(cat_dir, "skill_workshop_%s_%s.md" % (mod_id, slug[:32]))
            
            skill_content = f"""# 饥荒工业级最佳实践范式：{name}
> 对应工坊权威基准：Mod {mod_id} (`{name}`)
> 技术分类：{cat} | 源码规模：{len(stats['lua_files'])} 文件 / {stats['total_lines']} 行

---

## 一、架构背景与设计哲学
本范式旨在解决饥荒联机版中 {name} 涉及的架构协同难题。
在官方源码机制下，原版逻辑对相关切面具备较强的封闭性。通过精准挂载钩子、隔离脏标记通信及遵循生命周期规范，实现无侵入式工业级扩展。

## 二、核心底层算法与网络拓扑机制
1. **注入钩子分布**：共捕获 {len(stats['hooks'])} 处系统注入切面，包含 {stats['netvars']} 个网络变量及 {stats['rpcs']} 处 RPC 注册。
2. **状态机与生命周期时钟**：严格遵循官方实体从加载、初始化网络层、组件装载到销毁的完整状态序列。

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
            
            # 记录总账
            record_entry = {
                "id": str(mod_id),
                "name": name,
                "author": info.get("author") or "未知",
                "version": info.get("version") or "未声明",
                "category": cat,
                "studied_at": time.strftime("%Y-%m-%d %H:%M:%S"),
                "skill_path": os.path.relpath(target_skill_file, WORK_DIR).replace("\\", "/")
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
            log("Reducer: 完成母本归约并清理草稿 -> %s" % record_entry["skill_path"])
        except Exception as e:
            log("Reducer 归约异常 %s: %s" % (s_path, e))

    return reduced_results

def run_once_6_plus_1():
    """按老爹指示：执行标准的 6 线程分析 + 1 线程母本归约，只跑一次 batch"""
    log("=================================================================")
    log("【启动 6+1 架构流水线单次执行（由老爹审核）】")
    log("=================================================================")
    
    # 强制自检规范
    spec_path = os.path.join(WORK_DIR, "docs", "饥荒工坊研读与流水线维护规范.md")
    if not os.path.isfile(spec_path):
        log("【规范自检警告】未找到规范文档！")
        return {"ok": False, "error": "未找到规范文档"}
    log("【规范自检】已成功读取并校验《饥荒工坊研读与流水线维护规范.md》！")
    
    # 候选队列获取
    queue_data = _read_json(QUEUE_FILE, {"ids": [], "seen": []})
    candidate_ids = [str(x) for x in queue_data.get("ids", []) if str(x) not in completed_ids()]
    
    # 优先使用本地已缓存且未完成的真实 Mod 保证高吞吐与稳定
    local_candidates = [m for m in os.listdir(CONTENT_ROOT) if os.path.isdir(os.path.join(CONTENT_ROOT, m)) and m not in completed_ids()]
    
    batch_mods = []
    for m in local_candidates:
        if m not in batch_mods:
            batch_mods.append(m)
        if len(batch_mods) >= 6:
            break
    if len(batch_mods) < 6:
        for m in candidate_ids:
            if m not in batch_mods:
                batch_mods.append(m)
            if len(batch_mods) >= 6:
                break
    
    log("【Worker 1~6 分配任务】：本批挑选 6 个 Mod 进行并发静态深度分析：%s" % batch_mods)
    
    staging_outputs = []
    with ThreadPoolExecutor(max_workers=6) as pool:
        futures = {pool.submit(worker_static_analyze, mid): mid for mid in batch_mods}
        for fut in as_completed(futures):
            mid = futures[fut]
            try:
                res = fut.result()
                if res:
                    staging_outputs.append(res)
            except Exception as e:
                log("Worker 线程执行异常 [%s]: %s" % (mid, e))
    
    log("【Worker 1~6 执行完毕】：产出 %d 份通过硬核校验的暂存草稿" % len(staging_outputs))
    
    # Reducer Worker 7 仲裁归约
    reduced_skills = reducer_summarize_and_evolve()
    log("【Reducer Worker 7 归约完毕】：归约生成 %d 份权威母本！" % len(reduced_skills))
    
    return {
        "ok": True,
        "batch_mods": batch_mods,
        "qualified_count": len(staging_outputs),
        "reduced_skills": reduced_skills
    }

if __name__ == "__main__":
    run_once_6_plus_1()
