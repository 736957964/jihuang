# -*- coding: utf-8 -*-
import json, os, time

ledger_path = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main\docs\workshop_study_ledger.json"
desktop_path = r"C:\Users\Administrator\Desktop\饥荒工坊研读总账本.md"

if os.path.exists(ledger_path):
    with open(ledger_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    mods = data.get('completedMods', [])
    lines = []
    lines.append('# 🌟 饥荒创意工坊权威 MOD 研读总账本')
    lines.append(f'> 最后更新时间：{time.strftime("%Y-%m-%d %H:%M:%S")}')
    lines.append(f'> 当前已累计收录深度研读权威 MOD：**{len(mods)}** 个')
    lines.append('')
    lines.append('| 序号 | Mod ID | 模组名称 | 归属分类 | 研读时间 | 文档路径 |')
    lines.append('| :--- | :--- | :--- | :--- | :--- | :--- |')

    for idx, m in enumerate(mods, 1):
        mid = m.get('id', '')
        name = m.get('name', '')
        cat = m.get('category', '综合机制')
        t = m.get('completedAt', '')
        doc = m.get('studyDoc', '')
        lines.append(f'| {idx} | `{mid}` | **{name}** | {cat} | {t} | `{doc}` |')

    with open(desktop_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print(f"DESKTOP_LEDGER_SYNC_SUCCESS:{len(mods)}")
