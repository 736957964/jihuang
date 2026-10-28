# 饥荒联机版 (DST) 开发工具链与外部资源索引

## 1. AssetArchive-Dev (饥荒游戏资产与动画工作台)
- **项目仓库**: [https://github.com/lw-0x4eb1a/AssetArchive-Dev](https://github.com/lw-0x4eb1a/AssetArchive-Dev)
- **技术栈**: Tauri 2 (Rust) + React 18 + TypeScript + Pixi.js + MeiliSearch
- **定位**: 跨平台离线游戏资产、Wiki 检索与动画状态机预览调试工具

### 核心功能与使用场景
1. **免进游戏动画预览 (Anim Renderer)**:
   - 支持直接拖入 `.zip` / `.bin` 查看动画帧与播放动画事件（PlayAnimation/PushAnimation）。
   - 可视化切换 Bank、Build 及面向（Facing），极大缩短角色与怪物美术调动周期的反馈时间。
2. **贴图与动画工具集 (Mod Tools)**:
   - `maketex`: 将单张或多张 PNG 批量打包转换为 DST 专用 `.tex` 与 `.xml` 图集。
   - `lockanim`: 对导出的动画资源进行封包加锁与防盗用保护。
3. **本地 Wiki & Prefab / Tag 搜索引擎**:
   - 内置基于 MeiliSearch 的全文检索，包含全量官方实体、配方原料、伤害参数与代码 Tag。
   - 快速横向比对官方预制体数值，辅助新物品与新机制的平衡性设计。

---

## 2. 推荐使用工作流
1. **美术资源制作**:
   - 绘制贴图 -> 通过 `maketex` 生成 `.tex` + `.xml`。
   - 制作/解包动画 -> 使用 `Anim Renderer` 本地实时预览并确认 Bank/Build 绑定无误。
2. **代码逻辑编写**:
   - 参考 `jihuang-main/01-core/architecture_philosophy.md` 约定的组件注入与 StateGraph 规范。
   - 使用 AssetArchive 本地检索官方类似实体的组件组合与 Tag 规范。
