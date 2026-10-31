# -*- coding: utf-8 -*-
"""测试：常驻 SteamCMD 会话 + stdin 连续下发下载命令的耗时"""
import subprocess, time, sys, io

STEAMCMD = r"C:\Tools\steamcmd\steamcmd.exe"
root = r"C:\Tools\steamcmd\steamapps\workshop\content\322330"

proc = subprocess.Popen([STEAMCMD, "+@ShutdownOnFailedCommand", "0", "+@NoPromptForPassword", "1"],
                        stdin=subprocess.PIPE, stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL, text=True, bufsize=1)

t0 = time.time()
proc.stdin.write("login anonymous\n")
proc.stdin.flush()
# 等登录完成（轮询：Steam> 提示符不便于捕获，简单等 15 秒）
time.sleep(18)
print("login phase %.1fs" % (time.time() - t0))

for mod in ("3828908041", "3825229017", "3827608591"):
    t = time.time()
    proc.stdin.write("workshop_download_item 322330 %s\n" % mod)
    proc.stdin.flush()
    ok = False
    while time.time() - t < 240:
        time.sleep(3)
        import os
        p = os.path.join(root, mod)
        if os.path.isdir(p) and os.listdir(p):
            ok = True
            break
    print("%s -> %s %.1fs" % (mod, "OK" if ok else "TIMEOUT", time.time() - t))

proc.stdin.write("quit\n")
proc.stdin.flush()
time.sleep(3)
print("total %.1fs" % (time.time() - t0))
