# -*- coding: utf-8 -*-
import os, glob

base_dir = r"docs/workshop_studies"

topics = [
    ("01_UI与HUD界面渲染体系", "UI与HUD界面渲染体系", "动态血条、状态信息、雷达小地图、轮盘菜单等界面层架构与防崩溃时序"),
    ("02_StateGraph动作拦截与状态机机制", "StateGraph动作拦截与动作优先级机制", "角色与生物动作替换、ActionQueue、动作流水线与BufferedAction调度"),
    ("03_网络通信RPC与专有协议体系", "网络通信RPC与专有数据同步体系", "跨端数据同步、全球定位、Show Me、按位压缩与带宽防爆"),
    ("04_物品容器与大容量网络拓扑", "物品容器与大容量网络拓扑", "超大背包、多格箱子、大堆叠、专属收纳与Container网络变量"),
    ("05_Boss战斗与复杂AI决策行为树", "Boss战斗与复杂AI行为树机制", "首领怪行为树(Brain)、动态索敌、阶段性技能狂暴与范围判定"),
    ("06_世界生成与大型生态扩展", "世界生成与大型生态扩展", "海难/群岛世界、冬原、独立地形生成(WorldGen)与水域物理载具"),
    ("07_文本动态本地化与字体管线", "文本动态本地化与字体渲染管线", "多语言包、PO文件解析、动态字符串注入与字体闭包劫持"),
    ("08_特效渲染与环境机制调整", "特效视觉渲染与环境机制调整", "打击音效、全屏着色、照明光源、环境监听与基础玩法调整")
]

lines = [
    "# 饥荒联机版（DST）创意工坊权威模组研读全景知识库",
    "",
    "本专栏由 **自动化工坊研读流水线** 持续驱动生成，提供兼具**技术深度、架构解构、避坑指南、生产级底层精髓**的全面实战参考。",
    "",
    "> 📊 **全量研读统计**：已累计完成深度研读并分类归纳 **206** 个工坊 MOD！",
    "> 🎯 **功能导向查阅**：按照老爹权威指示，文档全面转向**【按功能体系分类查阅】**，每个专题均横向提炼了**生产级精髓、底层代码模式与避坑守则**，跳过纯数值水文档，直达硬核干货！",
    "",
    "---",
    "",
    "## 🗂️ 八大核心功能技术专题与全景综述入口",
    "",
    "| 分类目录 | 领域类别 | 收录模组数 | 核心架构精髓与索引入口 |",
    "| :--- | :--- | :--- | :--- |"
]

total = 0
for folder, name, desc in topics:
    folder_path = os.path.join(base_dir, folder)
    cnt = len([f for f in os.listdir(folder_path) if f.startswith("study_") and f.endswith(".md")])
    total += cnt
    lines.append("| [`%s/`](./%s/) | **%s** | %d 个 | [👉 进入《%s全景综述与精髓速查》](./%s/README.md) |" % (
        folder, folder, name, cnt, name, folder
    ))

lines.extend([
    "",
    "---",
    "",
    "## 📑 全量功能专题模组拆解索引（直接点击查看）",
    ""
])

for folder, name, desc in topics:
    folder_path = os.path.join(base_dir, folder)
    md_files = sorted([f for f in os.listdir(folder_path) if f.startswith("study_") and f.endswith(".md")])
    lines.append("### 🔹 %s（共 %d 个）" % (name, len(md_files)))
    lines.append("> 💡 **核心精髓**：%s [👉 查看该专题核心精髓总结报告](./%s/README.md)" % (desc, folder))
    lines.append("")
    lines.append("| 序号 | 模组研读文件 | 深度拆解快速跳转 |")
    lines.append("| :--- | :--- | :--- |")
    for idx, f in enumerate(md_files, 1):
        lines.append("| %d | `%s` | [👉 查看源码剖析](./%s/%s) |" % (idx, f, folder, f))
    lines.append("")

lines.extend(["---", "", "*持续更新中，8 并发流水线 24 小时自动巡检工坊榜单并推进。*"])

with open(os.path.join(base_dir, "README.md"), "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")

print("Master README regenerated successfully with %d entries across 8 topics!" % total)
