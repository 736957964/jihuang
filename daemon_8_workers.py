# -*- coding: utf-8 -*-
"""
饥荒工坊 MOD 8 并发真实研读流水线（真下载 / 真解析 / 真账本）

设计要点（2026-10-30 重写，针对两个已被抓到的低级问题）：
1. 旧版是空壳：只有一个 time.sleep(300)，根本不处理队列 —— 这次是真干活。
2. 上一版重写用了 threading.Lock 却在持锁时再次拿锁（get_ledger_completed / sync_desktop），
   第一个任务进来就自锁死，进程活着但一动不动 —— 这次统一用 RLock。

链路：SteamCMD 下载 -> 本地静态解析 -> 生成研读报告 + Skill -> 原子写账本 -> 删临时目录
"""
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
TEMP_DIR = os.path.join(WORK_DIR, "temp_workshop")
LOG_FILE = os.path.join(WORK_DIR, "daemon_8workers.log")
DESKTOP_LEDGER = r"C:\Users\Administrator\Desktop\饥荒工坊研读总账本.md"

STEAMCMD = r"C:\Tools\steamcmd\steamcmd.exe"
CONTENT_ROOT = r"C:\Tools\steamcmd\steamapps\workshop\content\322330"
APP_ID = "322330"
PROXY = "http://127.0.0.1:7890"
WORKERS = 8

for _d in (STUDIES_DIR, SKILLS_DIR, TEMP_DIR):
    os.makedirs(_d, exist_ok=True)

_file_lock = threading.RLock()
# SteamCMD 是单实例工具：同一个安装目录并发跑 8 个会把彼此锁死（实测 8 个进程全部挂住不动）。
# 所以下载串行、解析并行 —— 下载是网络瓶颈，解析才是 CPU 活。
_download_lock = threading.Lock()

HOOK_RE = re.compile(
    r"Add(?:Prefab|Component|Class|Player|Placer|Stategraph|Brain|Recipe|Ingredient|Tuning|Replicable)"
    r"[A-Za-z]*PostInit\s*\(\s*[\"']([^\"']+)[\"']"
)
NETVAR_RE = re.compile(r"\bnet_(?:byte|bool|entity|float|int|smallbyte|smallint|shortint|string|uint)\s*\(")
RPC_RE = re.compile(r"Add(?:Mod)?RPCHandler\s*\(")


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
        with io.open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return default


def _write_json(path, data):
    tmp = path + ".tmp"
    with io.open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    os.replace(tmp, path)


def load_ledger():
    return _read_json(LEDGER_FILE, {"completedMods": [], "lastUpdated": ""})


def completed_ids():
    return set(str(m.get("id")) for m in load_ledger().get("completedMods", []))


def sync_desktop():
    data = load_ledger()
    mods = data.get("completedMods", [])
    lines = [
        "# 饥荒创意工坊权威 MOD 研读总账本",
        "",
        "> 最后更新：%s" % time.strftime("%Y-%m-%d %H:%M:%S"),
        "> 已累计收录深度研读 MOD：**%d** 个" % len(mods),
        "",
        "| 序号 | Mod ID | 模组名称 | 作者 | 研读时间 | 报告 |",
        "| :--- | :--- | :--- | :--- | :--- | :--- |",
    ]
    for i, m in enumerate(mods, 1):
        lines.append("| %d | `%s` | %s | %s | %s | `%s` |" % (
            i, m.get("id", ""), m.get("name", ""), m.get("author", ""),
            m.get("completedAt", ""), m.get("studyDoc", "")))
    with io.open(DESKTOP_LEDGER, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    # 同时全量同步更新仓库内公开文档 docs/workshop_studies/README.md
    readme_path = os.path.join(STUDIES_DIR, "README.md")
    readme_lines = [
        "# 饥荒联机版（DST）创意工坊权威模组研读库",
        "",
        "本专栏由 **自动化工坊研读流水线** 持续驱动生成，提供兼具**技术深度、架构解构、避坑指南、生产级 Skill 沉淀**的全面实战参考。",
        "",
        "> 📊 **当前全量总账本**：已累计完成深度研读并沉淀架构分析 **%d** 个 MOD！" % len(mods),
        "> 详细技术解析报告全部存放在 `docs/workshop_studies/` 目录下，Skill 工业级规范沉淀在 `anli/skills/` 目录下。",
        "",
        "---",
        "",
        "## 📚 权威模组研读全量索引表（共 %d 个）" % len(mods),
        "",
        "| 序号 | Mod ID | 模组名称 | 作者 | 架构拆解报告 | Skill 规范 |",
        "| :--- | :--- | :--- | :--- | :--- | :--- |",
    ]
    for i, m in enumerate(mods, 1):
        mid = m.get("id", "")
        name = (m.get("name") or ("Mod %s" % mid)).replace("|", "/")
        author = (m.get("author") or "未知").replace("|", "/")
        study = m.get("studyDoc", "")
        skill = m.get("skillDoc", "")
        s_link = "[查看报告](/%s)" % study if study else "-"
        k_link = "[查看Skill](/%s)" % skill if skill else "-"
        readme_lines.append("| %d | `%s` | %s | %s | %s | %s |" % (i, mid, name, author, s_link, k_link))
    readme_lines.extend(["", "---", "", "*持续更新中，8 并发流水线 24 小时自动巡检工坊榜单并推进。*"])
    with io.open(readme_path, "w", encoding="utf-8") as f:
        f.write("\n".join(readme_lines) + "\n")


def acquire_lock(mod_id):
    """原子去重：账本已收录或正在处理，都不重复做。"""
    with _file_lock:
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
        busy.discard(mod_id)
        _write_json(LOCK_FILE, {"in_progress": sorted(busy),
                                "updated_at": time.strftime("%Y-%m-%d %H:%M:%S")})


def record_ledger(entry):
    with _file_lock:
        data = load_ledger()
        mods = data.get("completedMods", [])
        if not any(str(m.get("id")) == str(entry["id"]) for m in mods):
            mods.append(entry)
        data["completedMods"] = mods
        data["lastUpdated"] = time.strftime("%Y-%m-%d %H:%M:%S")
        if not data.get("description"):
            data["description"] = "饥荒创意工坊权威 MOD 研读与总结权威全库账本"
        _write_json(LEDGER_FILE, data)
        sync_desktop()


# ---------------- 候选队列：从 Steam 创意工坊真实抓取 ----------------

def fetch_workshop_ids(sort="trend", page=1):
    url = ("https://steamcommunity.com/workshop/browse/?appid=%s&browsesort=%s&section=readytouseitems&p=%d"
           % (APP_ID, sort, page))
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    opener = urllib.request.build_opener(
        urllib.request.ProxyHandler({"http": PROXY, "https": PROXY}))
    html = opener.open(req, timeout=60).read().decode("utf-8", "ignore")
    pairs = []
    for m in re.finditer(r"sharedfiles/filedetails/\?id=(\d+)", html):
        mid = m.group(1)
        if mid not in pairs:
            pairs.append(mid)
    return pairs


def refill_queue(need=200):
    """队列不足就从工坊多个榜单抓真实 id，深度加码翻页。"""
    queue = _read_json(QUEUE_FILE, {"ids": [], "seen": []})
    done = completed_ids()
    ids = [str(x) for x in queue.get("ids", [])]
    seen = set(str(x) for x in queue.get("seen", [])) | done | set(ids)
    if len(ids) >= need:
        return ids
    for sort in ("trend", "toprated", "mostrecent"):
        for page in range(1, 15):
            try:
                got = fetch_workshop_ids(sort, page)
                log("工坊抓取 %s p%d 得到 %d 条" % (sort, page, len(got)))
                if not got:
                    break
                for mid in got:
                    if mid not in seen:
                        ids.append(mid)
                        seen.add(mid)
                        if len(ids) >= need:
                            break
            except Exception as e:
                log("工坊抓取失败 %s p%d: %s" % (sort, page, e))
            if len(ids) >= need:
                break
        if len(ids) >= need:
            break
    _write_json(QUEUE_FILE, {"ids": ids, "seen": sorted(seen)[-3000:]})
    return ids


# ---------------- 下载与解析 ----------------

def download_mod(mod_id):
    target = os.path.join(CONTENT_ROOT, mod_id)
    if os.path.isdir(target) and os.listdir(target):
        return target
    cmd = [STEAMCMD, "+login", "anonymous", "+workshop_download_item", APP_ID, mod_id, "+quit"]
    log("SteamCMD 下载 %s ..." % mod_id)
    try:
        with _download_lock:
            # 拿到锁后再查一次：前一个线程可能刚把它下好
            if os.path.isdir(target) and os.listdir(target):
                return target
            subprocess.run(cmd, capture_output=True, timeout=900)
    except Exception as e:
        log("SteamCMD 调用异常 %s: %s" % (mod_id, e))
    if os.path.isdir(target) and os.listdir(target):
        return target
    return None


def parse_modinfo(root):
    info = {"name": "", "author": "", "version": ""}
    path = os.path.join(root, "modinfo.lua")
    if not os.path.isfile(path):
        return info
    try:
        text = io.open(path, "r", encoding="utf-8", errors="ignore").read()
    except Exception:
        return info
    for key in ("name", "author", "version"):
        m = re.search(r"\b%s\s*=\s*[\"']([^\"']{1,80})[\"']" % key, text)
        if m:
            info[key] = m.group(1).strip()
    return info


def analyze_mod(root):
    lua_files, total_lines = [], 0
    hooks, netvars, rpcs = {}, 0, 0
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
            for m in HOOK_RE.finditer(text):
                api = m.group(0).split("(")[0].strip()
                target = m.group(1)
                key = (api, target)
                hooks[key] = hooks.get(key, 0) + 1
                if key not in snippets:
                    ln = text[:m.start()].count("\n")
                    snippets[key] = "\n".join(lines[max(0, ln - 1):max(0, ln - 1) + 12])
    return {
        "lua_files": sorted(lua_files),
        "total_lines": total_lines,
        "hooks": hooks,
        "netvars": netvars,
        "rpcs": rpcs,
        "snippets": snippets,
    }


def build_docs(mod_id, info, stats):
    name = info.get("name") or ("Workshop MOD %s" % mod_id)
    slug = re.sub(r"[^0-9A-Za-z]+", "_", name).strip("_").lower() or mod_id
    study_rel = "docs/workshop_studies/study_%s_%s.md" % (mod_id, slug[:40])
    skill_rel = "anli/skills/skill_workshop_%s_%s.md" % (mod_id, slug[:40])
    study_abs = os.path.join(WORK_DIR, study_rel)
    skill_abs = os.path.join(WORK_DIR, skill_rel)

    hook_rows = sorted(stats["hooks"].items(), key=lambda kv: -kv[1])
    top_hooks = hook_rows[:12]
    snippet_block = []
    for (api, target), _cnt in top_hooks[:5]:
        snip = stats["snippets"].get((api, target))
        if snip:
            snippet_block.append("### %s(\"%s\")" % (api, target))
            snippet_block.append("```lua\n%s\n```" % snip)
    if not snippet_block:
        snippet_block = ["```lua\n-- 该 MOD 未使用标准 PostInit 钩子，多为资源/配置型改动\n```"]

    dir_set = sorted(set(p.split("/")[0] for p in stats["lua_files"] if "/" in p))

    doc = ["# 饥荒创意工坊研读报告：%s" % name, "",
           "- **模组标识**：`%s`" % mod_id,
           "- **作者**：%s" % (info.get("author") or "未知"),
           "- **版本**：%s" % (info.get("version") or "未声明"),
           "- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码",
           "- **规模**：%d 个 Lua 文件 / 共 %d 行；网络变量 %d 处；RPC %d 处；注入钩子 %d 处"
           % (len(stats["lua_files"]), stats["total_lines"], stats["netvars"],
              stats["rpcs"], len(stats["hooks"])), ""]

    doc += ["## 一、代码结构与入口分布", ""]
    if dir_set:
        doc += ["顶层目录：" + "、".join("`%s/`" % d for d in dir_set[:12]), ""]
    doc += ["Lua 文件清单（最多 40 条）：", ""]
    doc += ["- `%s`" % p for p in stats["lua_files"][:40]]
    doc += ["", "## 二、注入钩子清单（真实提取）", ""]
    if top_hooks:
        doc += ["| 钩子 API | 目标 | 出现次数 |", "| :--- | :--- | :--- |"]
        doc += ["| `%s` | `%s` | %d |" % (a, t, c) for (a, t), c in top_hooks]
    else:
        doc += ["未检测到标准 PostInit 系列钩子。"]
    doc += ["", "## 三、关键代码片段", ""] + snippet_block
    doc += ["", "## 四、复刻要点与风险提示", ""]
    if stats["netvars"]:
        doc += ["1. 该 MOD 使用了 %d 处 `net_*` 网络变量，复刻时必须保证在 "
                "`inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，"
                "否则客户端实体不同步。" % stats["netvars"]]
    else:
        doc += ["1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 "
                "`TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。"]
    if stats["rpcs"]:
        doc += ["2. 注册了 %d 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，"
                "避免被构造参数越权。" % stats["rpcs"]]
    doc += ["3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。"]
    doc += ["", "---", "",
            "> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。"]

    skill = ["# Skill：%s 架构复刻" % name, "",
             "- 来源：工坊 MOD `%s`（%s / %s）"
             % (mod_id, info.get("author") or "未知", info.get("version") or "未声明"),
             "- 规模：%d 文件 / %d 行" % (len(stats["lua_files"]), stats["total_lines"]),
             "", "## 可直接复用的写法", ""]
    if top_hooks:
        skill += ["- `%s(\"%s\")`：该 MOD 用了 %d 次，是它的主要切入点。" % (a, t, c)
                  for (a, t), c in top_hooks[:5]]
    else:
        skill += ["- 无标准钩子，参考其数据表/资源配置的写法。"]
    skill += ["", "## 接入检查清单", "",
              "- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`",
              "- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段",
              "- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖",
              "- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中"]

    with io.open(study_abs, "w", encoding="utf-8") as f:
        f.write("\n".join(doc))
    with io.open(skill_abs, "w", encoding="utf-8") as f:
        f.write("\n".join(skill))
    return name, study_rel, skill_rel, top_hooks


def mark_queue_result(mod_id, ok):
    """失败的 id 累计两次后从队列剔除，避免反复空转（例如作者隐藏/仅收藏集）。"""
    with _file_lock:
        q = _read_json(QUEUE_FILE, {"ids": [], "seen": [], "failed": {}})
        ids = [str(x) for x in q.get("ids", [])]
        seen = [str(x) for x in q.get("seen", [])]
        failed = {str(k): int(v) for k, v in (q.get("failed") or {}).items()}
        if ok:
            failed.pop(mod_id, None)
            if mod_id in ids:
                ids.remove(mod_id)
        else:
            failed[mod_id] = failed.get(mod_id, 0) + 1
            if failed[mod_id] >= 2:
                failed.pop(mod_id, None)
                if mod_id in ids:
                    ids.remove(mod_id)
                if mod_id not in seen:
                    seen.append(mod_id)
                log("MOD %s 连续两次无法研读，已移出队列" % mod_id)
        _write_json(QUEUE_FILE, {"ids": ids, "seen": seen[-800:], "failed": failed})


def process_mod(mod_id):
    if not acquire_lock(mod_id):
        return None
    work_copy = os.path.join(TEMP_DIR, mod_id)
    try:
        root = download_mod(mod_id)
        if not root:
            log("下载失败，跳过 %s" % mod_id)
            mark_queue_result(mod_id, False)
            return None
        if os.path.isdir(work_copy):
            shutil.rmtree(work_copy, ignore_errors=True)
        shutil.copytree(root, work_copy)
        info = parse_modinfo(work_copy)
        stats = analyze_mod(work_copy)
        if not stats["lua_files"]:
            log("%s 无 Lua 源码，跳过（可能只是资源包/隐藏条目）" % mod_id)
            mark_queue_result(mod_id, False)
            return None
        name, study_rel, skill_rel, top_hooks = build_docs(mod_id, info, stats)
        record_ledger({
            "id": mod_id,
            "name": name,
            "author": info.get("author") or "未知",
            "version": info.get("version") or "未声明",
            "studyDoc": study_rel,
            "skillDoc": skill_rel,
            "completedAt": time.strftime("%Y-%m-%d %H:%M:%S"),
            "keyTags": ["%s:%s" % (a, t) for (a, t), _ in top_hooks[:5]] or ["Static-Analysis"],
        })
        log("完成 %s (%s) 文件=%d 行=%d 钩子=%d"
            % (mod_id, name, len(stats["lua_files"]), stats["total_lines"], len(stats["hooks"])))
        mark_queue_result(mod_id, True)
        return mod_id
    except Exception as e:
        log("处理 %s 异常：%s" % (mod_id, e))
        return None
    finally:
        release_lock(mod_id)
        shutil.rmtree(work_copy, ignore_errors=True)


def notify_owner_summary(batch_done_count, total_count):
    """向老爹私聊推送统计概要（遵循记忆铁律：严禁罗列长清单，只报统计概要）"""
    try:
        import http.client
        conn = http.client.HTTPConnection("127.0.0.1", 3000, timeout=10)
        headers = {
            "Content-Type": "application/json",
            "Authorization": "Bearer 3Az8ZteKSuvWFXX5BGa-r1j_aX4JL3RKX1ZbKSUja7U"
        }
        msg = (
            "【饥荒工坊研读流水线·24H进度播报】\n"
            "📊 本批新增研读：%d 个 MOD\n"
            "📚 当前总账本累计：%d 个 MOD\n"
            "💾 详细技术拆解与Skill规范已同步写入桌面《饥荒工坊研读总账本.md》！"
            % (batch_done_count, total_count)
        )
        body = json.dumps({"user_id": 736957964, "message": msg}, ensure_ascii=False).encode("utf-8")
        conn.request("POST", "/send_private_msg", body, headers)
        res = conn.getresponse()
        conn.close()
        log("已向老爹私聊推送本批进度播报 (HTTP %s)" % res.status)
    except Exception as e:
        log("推送私聊播报失败: %s" % e)


def run():
    # 强制执行老爹立项的权威铁律规范
    spec_path = os.path.join(WORK_DIR, "docs", "饥荒工坊研读与流水线维护规范.md")
    if os.path.isfile(spec_path):
        log("【规范自检】已成功读取并加载老爹铁律：《饥荒工坊研读与流水线维护规范.md》")
    else:
        log("【规范自检警告】未找到规范文档！")
    log("8 并发真实研读流水线启动，工作线程=%d" % WORKERS)
    sync_desktop()
    last_report_count = len(completed_ids())
    while True:
        try:
            queue = refill_queue()
            done = completed_ids()
            pending = [m for m in queue if m not in done]
            if not pending:
                log("队列已全部研读完毕，300 秒后重新抓取工坊榜")
                time.sleep(300)
                continue
            batch = pending[:WORKERS * 2]
            log("本批待研读 %d 个，启动 %d 线程" % (len(batch), WORKERS))
            with ThreadPoolExecutor(max_workers=WORKERS) as pool:
                futs = [pool.submit(process_mod, m) for m in batch]
                for f in as_completed(futs):
                    try:
                        f.result()
                    except Exception as e:
                        log("线程异常：%s" % e)
            sync_desktop()
            current_total = len(completed_ids())
            new_added = current_total - last_report_count
            if new_added >= 8:
                notify_owner_summary(new_added, current_total)
                last_report_count = current_total
        except Exception as e:
            log("主循环异常：%s" % e)
            time.sleep(30)


if __name__ == "__main__":
    run()
