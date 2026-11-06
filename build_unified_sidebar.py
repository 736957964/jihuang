# -*- coding: utf-8 -*-
import os, re

ROOT = r"C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main"
sidebar_path = os.path.join(ROOT, "_sidebar.md")

def clean_title(raw_title, filename):
    t = raw_title.strip()
    t = re.sub(r"^饥荒(创意工坊深度|一线工坊深度|工坊权威模组|工业级最佳实践范式|一线工坊权威模组)(研读报告|研读 Skill|范式|案例速查)[：:]\s*", "", t)
    t = re.sub(r"^知识点专卷[：:]\s*", "", t)
    t = t.strip()
    if not t or t == "------":
        t = filename.replace(".md", "")
    return t

def extract_h1(fpath):
    try:
        with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
            for line in f:
                line = line.strip()
                if line.startswith("# "):
                    return line[2:].strip()
    except:
        pass
    return ""

# 获取现有 _sidebar.md 官方文档部分（即 从 "* [🌟 核心架构决策与源码哲学]" 开始的后半段）
with open(sidebar_path, "r", encoding="utf-8") as f:
    orig_content = f.read()

split_marker = "* [🌟 核心架构决策与源码哲学]"
if split_marker in orig_content:
    official_part = orig_content[orig_content.index(split_marker):]
else:
    official_part = ""

# 重新系统性构建第一大部分：创意工坊全量模组与母本研读库
# 按照 8 大技术分类，同时完整收录：
# 1. docs/workshop_studies 下的权威母本/研读报告
# 2. anli/skills 下的高阶母本范式
categories = [
    ("01_UI与HUD界面交互类", "01 UI 与 HUD 界面交互类"),
    ("02_动作控制与状态机StateGraph类", "02 动作控制与状态机 StateGraph 类"),
    ("03_网络通信RPC与数据同步类", "03 网络通信 RPC 与数据同步类"),
    ("04_物品容器与背包扩展类", "04 物品容器与背包扩展类"),
    ("05_战斗AI行为树与Boss机制类", "05 战斗 AI 行为树与 Boss 机制类"),
    ("06_世界生成与生态系统类", "06 世界生成与生态系统类"),
    ("07_实体机制与游戏平衡类", "07 实体机制与游戏平衡类"),
    ("08_语言本地化与字体渲染类", "08 语言本地化与字体渲染类")
]

new_sidebar_lines = [
    "* 🌟 创意工坊权威模组与母本研读库",
    "  * [📑 创意工坊全量架构总览与全景综述](docs/workshop_studies/README.md)"
]

added_links = set()

for cat_folder, cat_display in categories:
    new_sidebar_lines.append(f"  * {cat_display}")
    
    # 专题 README 概览
    cat_readme = os.path.join(ROOT, "docs", "workshop_studies", cat_folder, "README.md")
    if os.path.isfile(cat_readme):
        rel = f"docs/workshop_studies/{cat_folder}/README.md"
        new_sidebar_lines.append(f"    * [📌 {cat_display} 专题综述与架构速查]({rel})")
        added_links.add(rel)

    # 收集该分类下的所有母本/研读文件
    cat_entries = []
    
    # 来自 docs/workshop_studies/{cat_folder}/
    docs_cat_dir = os.path.join(ROOT, "docs", "workshop_studies", cat_folder)
    if os.path.isdir(docs_cat_dir):
        for root, dirs, files in os.walk(docs_cat_dir):
            for f in sorted(files):
                if f.endswith(".md") and f != "README.md":
                    fpath = os.path.join(root, f)
                    rel = os.path.relpath(fpath, ROOT).replace("\\", "/")
                    if rel not in added_links:
                        raw_h1 = extract_h1(fpath)
                        title = clean_title(raw_h1, f)
                        cat_entries.append((title, rel, "权威母本研读"))
                        added_links.add(rel)

    # 来自 anli/skills/{cat_folder}/
    anli_cat_dir = os.path.join(ROOT, "anli", "skills", cat_folder)
    if os.path.isdir(anli_cat_dir):
        for root, dirs, files in os.walk(anli_cat_dir):
            for f in sorted(files):
                if f.endswith(".md"):
                    fpath = os.path.join(root, f)
                    rel = os.path.relpath(fpath, ROOT).replace("\\", "/")
                    if rel not in added_links:
                        raw_h1 = extract_h1(fpath)
                        title = clean_title(raw_h1, f)
                        cat_entries.append((title, rel, "工业级母本范式"))
                        added_links.add(rel)

    # 排序输出条目
    for title, rel, badge in cat_entries:
        new_sidebar_lines.append(f"    * [{title}]({rel})")

full_new_sidebar = "\n".join(new_sidebar_lines) + "\n" + official_part

with open(sidebar_path, "w", encoding="utf-8") as f:
    f.write(full_new_sidebar)

print(f"成功重构 _sidebar.md！共收录工坊与母本文档 {len(added_links)} 篇！")