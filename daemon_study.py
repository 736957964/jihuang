# -*- coding: utf-8 -*-
import os, sys, time, json

WORK_DIR = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main"
REPORT_LOG = os.path.join(WORK_DIR, "study_report.log")
STATUS_FILE = os.path.join(WORK_DIR, "study_status.json")

def log(msg):
    t = time.strftime('%Y-%m-%d %H:%M:%S')
    line = f'[{t}] {msg}\n'
    print(line, end='', flush=True)
    with open(REPORT_LOG, 'a', encoding='utf-8') as f:
        f.write(line)

def run():
    log("饥荒 MOD 24小时独立学习 Worker 已启动。计划每4小时产出一期深度学习提炼。")
    cycle = 0
    while True:
        cycle += 1
        log(f"开始执行第 {cycle} 轮 MOD 源码结构解析与案例提取...")
        try:
            worker_script = os.path.join(WORK_DIR, "run_worker.py")
            if os.path.exists(worker_script):
                os.system(f'python "{worker_script}"')
            case_script = os.path.join(WORK_DIR, "generate_cases.py")
            if os.path.exists(case_script):
                os.system(f'python "{case_script}"')
        except Exception as e:
            log(f"学习循环异常: {e}")
        
        status = {
            "cycle": cycle,
            "last_time": time.strftime('%Y-%m-%d %H:%M:%S'),
            "next_report_sec": 4 * 3600
        }
        with open(STATUS_FILE, 'w', encoding='utf-8') as f:
            json.dump(status, f, ensure_ascii=False, indent=2)
            
        log("本轮解析完成，进入休眠（4小时后启动下一轮汇报与深度分析）")
        time.sleep(4 * 3600)

if __name__ == "__main__":
    run()
