# -*- coding: utf-8 -*-
import os, time, urllib.request, json

WORK_DIR = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main"
LEDGER = os.path.join(WORK_DIR, "docs", "workshop_study_ledger.json")
STATE_FILE = os.path.join(WORK_DIR, "watcher_state.json")
OWNER_QQ = "736957964"

def get_last_count():
    try:
        if os.path.isfile(STATE_FILE):
            with open(STATE_FILE, "r", encoding="utf-8") as f:
                return json.load(f).get("count", 0)
    except Exception:
        pass
    return 0

def save_count(c):
    try:
        with open(STATE_FILE, "w", encoding="utf-8") as f:
            json.dump({"count": c}, f)
    except Exception:
        pass

def main():
    last = get_last_count()
    while True:
        time.sleep(30)
        try:
            if not os.path.isfile(LEDGER):
                continue
            with open(LEDGER, "r", encoding="utf-8") as f:
                data = json.load(f)
            mods = data.get("completedMods", [])
            cur = len(mods)
            if cur > last and last > 0:
                latest = mods[-1]
                msg = "【饥荒研读进度播报】\n已完成新 MOD 研读！\n- 名称：%s\n- ID：%s\n- 当前总收录：%d 个" % (
                    latest.get("name"), latest.get("id"), cur)
                # 写入通知文件供桥接或外部读取
                with open(os.path.join(WORK_DIR, "pending_notify.txt"), "w", encoding="utf-8") as nf:
                    nf.write(msg)
            last = cur
            save_count(cur)
        except Exception as e:
            print("watcher error:", e)

if __name__ == "__main__":
    main()
