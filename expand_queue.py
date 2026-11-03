# -*- coding: utf-8 -*-
"""
Steam 饥荒工坊 ID 自动探测抓取器（支持代理、多排序维度扩展候选池到 2000+）
"""
import os
import re
import time
import json
import urllib.request

WORK_DIR = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main"
QUEUE_FILE = os.path.join(WORK_DIR, "workshop_candidate_queue.json")
PROXY = "http://127.0.0.1:7890"

def fetch_page_ids(opener, sort_type, page):
    url = f"https://steamcommunity.com/workshop/browse/?appid=322330&browsesort={sort_type}&section=readytouseitems&p={page}"
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"})
    try:
        res = opener.open(req, timeout=12)
        html = res.read().decode("utf-8", errors="ignore")
        ids = re.findall(r"filedetails/\?id=(\d+)", html)
        return list(dict.fromkeys(ids))
    except Exception as e:
        print(f"Fetch failed for {sort_type} page {page}: {e}")
        return []

def expand_queue_to_target(target=2000):
    proxy = urllib.request.ProxyHandler({'http': PROXY, 'https': PROXY})
    opener = urllib.request.build_opener(proxy)
    
    with open(QUEUE_FILE, "r", encoding="utf-8") as f:
        data = json.load(f)
        
    ids = list(data.get("ids", []))
    seen = set(data.get("seen", []))
    all_known = set(ids) | seen
    
    print(f"[*] 当前待处理队列数: {len(ids)}, 历史已知总数: {len(all_known)}, 目标待处理: {target}")
    
    sort_modes = ["trend", "mostrecent", "totaluniquesubscribers", "toprated"]
    
    for sort_mode in sort_modes:
        print(f"\n[+] 切换抓取维度: {sort_mode} ...")
        page = 1
        empty_rounds = 0
        while len(ids) < target and empty_rounds < 3 and page <= 100:
            new_ids = fetch_page_ids(opener, sort_mode, page)
            if not new_ids:
                empty_rounds += 1
                page += 1
                time.sleep(1)
                continue
            
            empty_rounds = 0
            added = 0
            for nid in new_ids:
                if nid not in all_known:
                    ids.append(nid)
                    all_known.add(nid)
                    added += 1
                    if len(ids) >= target:
                        break
            
            print(f"Page {page} ({sort_mode}): 提取 {len(new_ids)} 个, 新增入队 {added} 个, 当前队列: {len(ids)}")
            page += 1
            time.sleep(1.2)
            
            # 定时存盘防断电
            if page % 5 == 0 or len(ids) >= target:
                data["ids"] = ids
                with open(QUEUE_FILE, "w", encoding="utf-8") as f:
                    json.dump(data, f, ensure_ascii=False, indent=2)
                    
        if len(ids) >= target:
            break
            
    data["ids"] = ids
    with open(QUEUE_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        
    print(f"\n[[OK]] 扩展完成！当前待处理队列总数: {len(ids)}")

if __name__ == "__main__":
    expand_queue_to_target(2000)
