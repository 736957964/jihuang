# -*- coding: utf-8 -*-
import os, glob, shutil

base_dir = r"docs/workshop_studies"

topics = {
    "01_UI与HUD界面渲染体系": {
        "title": "UI与HUD界面渲染体系架构研读与功能速查",
        "desc": "涵盖动态血条、状态信息、雷达小地图、轮盘菜单等界面层架构。重点提炼 Client/PlayerHud 挂载、Widget 层级管理、屏幕适配与防崩溃时序。",
        "keywords": ["hud", "status", "bar", "indicator", "wheel", "minimap", "display", "view", "info", "placement", "gesture", "health", "alignment"],
        "core_skills": [
            "【UI挂载安全时序】：严禁在全局脚本直接创建UI，必须通过 AddPlayerPostInit 监听 inst.HUD ~= nil 或 Hook controls.lua",
            "【Widget屏幕自适应】：使用 inst.widget:SetHAnchor(ANCHOR_MIDDLE) 与 SetScaleMode(SCALEMODE_PROPORTIONAL)",
            "【性能防卡顿】：大量HUD信息严禁每帧计算，必须绑定事件驱动回调（inst:ListenForEvent）"
        ]
    },
    "02_StateGraph动作拦截与状态机机制": {
        "title": "StateGraph动作拦截与动作优先级机制研读与功能速查",
        "desc": "涵盖角色与生物动作替换、行为队列(ActionQueue)、强制中断与动作优先级。重点提炼 SG 状态注入、ActionHandler、BufferedAction 调度精髓。",
        "keywords": ["queue", "action", "stategraph", "sg", "snapping", "pick", "proper_switching", "switch"],
        "core_skills": [
            "【双端SG一致性】：双端联机模式下必须同时修改 wilson.lua（服务端）与 wilson_client.lua（客户端预表现）",
            "【无缝动作替换】：通过 AddStategraphActionHandler 动态注入或覆盖原有动作的 SG 状态跳转",
            "【动作流水线调度】：采用 BufferedAction 队列化处理连续交互，在 action:DoAction 完成后自动拉取下个任务"
        ]
    },
    "03_网络通信RPC与专有协议体系": {
        "title": "网络通信RPC与专有数据同步体系研读与功能速查",
        "desc": "涵盖跨端数据同步、全球定位、Show Me、实时高亮。重点提炼 SendModRPCToServer / AddClientRPC、按位压缩与带宽防爆。",
        "keywords": ["position", "show_me", "insight", "finder", "rpc", "lag", "global_positions"],
        "core_skills": [
            "【RPC带宽与按位压缩】：频繁传输的浮点坐标建议乘以倍率转为整型，或利用 bit32 进行多状态位拼接",
            "【客户端本地预测】：避免等待服务端 RPC 回包才渲染 UI，采用乐观预测先渲染、回包校验校准",
            "【防刷机制】：服务端 RPC 接收端必须施加冷却时间（cooldown）校验，严禁信任客户端发送的高频指令"
        ]
    },
    "04_物品容器与大容量网络拓扑": {
        "title": "物品容器与大容量网络拓扑架构研读与功能速查",
        "desc": "涵盖超大背包、多格箱子、大堆叠、专属收纳。重点提炼 Container 组件网络变量 net_entity/net_smallbyte、防掉落、防炸档与UI网格重构。",
        "keywords": ["inventory", "slot", "bag", "pack", "stack", "storage", "cellar", "bell", "backpack", "container", "box", "maxstack"],
        "core_skills": [
            "【容器网格重绘】：通过修改 params.inv_widget 与 widget.slotpos 数组重构网格布局，适配不同分辨率",
            "【网络变量拓扑】：超过官方默认槽位必须动态拓展 net_entity 数组，保证客户端可见物品实体同步",
            "【防爆防炸档保障】：容器关闭或掉落时，重载 DropEverything()，严禁物品因越界丢失"
        ]
    },
    "05_Boss战斗与复杂AI决策行为树": {
        "title": "Boss战斗与复杂AI行为树机制研读与功能速查",
        "desc": "涵盖首领级怪物行为树(Brain)、仇恨动态索敌、阶段性技能狂暴与范围伤害判定。重点提炼 Brain 优先级节点、Combat:SetRetargetFunction。",
        "keywords": ["boss", "brain", "pugalisk", "combat", "monster", "slime", "abigail", "mudrock"],
        "core_skills": [
            "【行为树优先级选择】：利用 PriorityNode 组合 ChaseAndAttack、Wander、Panic 等经典节点",
            "【动态仇恨索敌机制】：通过 Combat:SetRetargetFunction(period, fn) 动态计算范围目标威胁度",
            "【AOE与物理碰撞盒】：利用 FindEntities + 扇形夹角公式实现高精度打击判定"
        ]
    },
    "06_世界生成与大型生态扩展": {
        "title": "世界生成与大型生态机制扩展研读与功能速查",
        "desc": "涵盖海难/群岛世界、冬原、独立地形生成(WorldGen)、独立物理系统与水域载具。重点提炼 地形规则、TaskSet、独立物理碰撞层。",
        "keywords": ["island", "wuthering", "winterlands", "limbus", "plants", "deltarune", "above_the_clouds", "storm"],
        "core_skills": [
            "【WorldGen规则注入】：利用 AddRoom / AddLevel 挂载自定义生物群系与地形房间预制件",
            "【物理碰撞掩码】：自定义载具需通过 inst.Physics:SetCollisionMask 实现陆水边界穿越",
            "【大型模组解耦】：采用模块化 feature 目录加载，严格遵循组件动态装配机制"
        ]
    },
    "07_文本动态本地化与字体管线": {
        "title": "文本动态本地化与字体渲染管线研读与功能速查",
        "desc": "涵盖多语言包、PO 文件解析、动态字符串注入与字体闭包劫持。重点提炼 Language:LoadPO、Strings 表动态重映射与缺失字符 Fallback。",
        "keywords": ["chinese", "language", "tradu", "lang", "words", "russification"],
        "core_skills": [
            "【多语言PO加载】：调用 Language:LoadPOFile 实现官方词条的安全替换",
            "【未注册字符串防御】：使用 STRINGS.NAMES[string.upper(prefab)] 动态兜底，防止出现 MISSING NAME",
            "【字体闭包注入】：利用 debug.getupvalue 劫持字体注册函数，实现非侵入式自定义字体载入"
        ]
    },
    "08_特效渲染与环境机制调整": {
        "title": "特效视觉渲染与环境机制深度调整研读与功能速查",
        "desc": "涵盖打击音效、全屏彩虹着色、照明光源、自动陷阱与基础玩法数值调整。重点提炼 FX 预制件生成、AnimState 渲染层级与光源组件挂载。",
        "keywords": ["sound", "fx", "rainbow", "lantern", "light", "trap", "explore", "timer", "respawn", "gem", "restart"],
        "core_skills": [
            "【瞬态特效预制件】：特效生成后设置 inst:ListenForEvent('animover', inst.Remove)，防内存泄漏",
            "【动态光源与着色】：通过 inst.entity:AddLight() 并动态调控 Light:SetColour、SetRadius",
            "【环境监听】：通过 inst:ListenForEvent('seasonTick', ...) 实现环境状态与实体的交互响应"
        ]
    }
}

studies = glob.glob(os.path.join(base_dir, "study_*.md"))
for folder in topics.keys():
    os.makedirs(os.path.join(base_dir, folder), exist_ok=True)

classified = {k: [] for k in topics.keys()}

for s in studies:
    fname = os.path.basename(s)
    low = fname.lower()
    matched = False
    for folder, data in topics.items():
        if folder == "08_特效渲染与环境机制调整":
            continue
        if any(kw in low for kw in data["keywords"]):
            classified[folder].append(fname)
            shutil.copy2(s, os.path.join(base_dir, folder, fname))
            matched = True
            break
    if not matched:
        classified["08_特效渲染与环境机制调整"].append(fname)
        shutil.copy2(s, os.path.join(base_dir, "08_特效渲染与环境机制调整", fname))

for folder, data in topics.items():
    items = classified[folder]
    doc = [
        "# " + data["title"],
        "",
        "> 📊 **本领域收录标杆模组**：共 **%d** 个模组深度解析" % len(items),
        "> 💡 **领域架构定义**：" + data["desc"],
        "",
        "---",
        "",
        "## 一、核心提炼：生产级底层精髓与可复用代码规范",
        ""
    ]
    for sk in data["core_skills"]:
        doc.append("- " + sk)
    doc.extend([
        "",
        "---",
        "",
        "## 二、功能导向：模组深度拆解与实现快速跳转",
        "",
        "| 序号 | 研读报告文件 | 核心技术亮点与查看入口 |",
        "| :--- | :--- | :--- |"
    ])
    for idx, f in enumerate(sorted(items), 1):
        doc.append("| %d | `%s` | [👉 进入该模组技术拆解](./%s) |" % (idx, f, f))
    doc.extend(["", "---", "", "*持续更新中，由 8 并发工坊研读流水线动态归纳注入。*"])
    with open(os.path.join(base_dir, folder, "README.md"), "w", encoding="utf-8") as out:
        out.write("\n".join(doc) + "\n")

print("All 8 topic READMEs generated successfully!")
