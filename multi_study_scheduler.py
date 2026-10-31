# -*- coding: utf-8 -*-
"""
饥荒工坊 MOD 5并发自动化研读流水线调度器（含原子排他去重锁）
"""
import os, sys, time, json, shutil, threading
from concurrent.futures import ThreadPoolExecutor

WORK_DIR = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main"
LEDGER_FILE = os.path.join(WORK_DIR, "docs", "workshop_study_ledger.json")
LOCK_FILE = os.path.join(WORK_DIR, "workshop_task_locks.json")
STUDIES_DIR = os.path.join(WORK_DIR, "docs", "workshop_studies")
SKILLS_DIR = os.path.join(WORK_DIR, "anli", "skills")
TEMP_DIR = os.path.join(WORK_DIR, "temp_workshop")

file_lock = threading.Lock()

def get_ledger_completed():
    with file_lock:
        if os.path.exists(LEDGER_FILE):
            try:
                with open(LEDGER_FILE, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    return set(m["id"] for m in data.get("completedMods", []))
            except Exception:
                pass
    return set()

def acquire_mod_lock(mod_id):
    """原子化抢占任务锁，防止子任务重复阅读同一 MOD"""
    with file_lock:
        locks = set()
        if os.path.exists(LOCK_FILE):
            try:
                with open(LOCK_FILE, "r", encoding="utf-8") as f:
                    locks = set(json.load(f).get("in_progress", []))
            except Exception:
                locks = set()
        completed = get_ledger_completed()
        if mod_id in completed or mod_id in locks:
            return False
        locks.add(mod_id)
        with open(LOCK_FILE, "w", encoding="utf-8") as f:
            json.dump({"in_progress": list(locks), "updated_at": time.strftime('%Y-%m-%d %H:%M:%S')}, f, ensure_ascii=False, indent=2)
        return True

def release_mod_lock(mod_id):
    with file_lock:
        if os.path.exists(LOCK_FILE):
            try:
                with open(LOCK_FILE, "r", encoding="utf-8") as f:
                    locks = set(json.load(f).get("in_progress", []))
                if mod_id in locks:
                    locks.remove(mod_id)
                with open(LOCK_FILE, "w", encoding="utf-8") as f:
                    json.dump({"in_progress": list(locks), "updated_at": time.strftime('%Y-%m-%d %H:%M:%S')}, f, ensure_ascii=False, indent=2)
            except Exception:
                pass

print("5并发原子锁调度模块构建完成！")
