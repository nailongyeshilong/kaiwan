# 06 - 开发规范（Development Guide）

> 项目：开玩（KaiPlay）
> 文档版本：V1.0

---

# 1. 文档目的

本文档定义《开玩》的开发规范。

所有开发工作（包括 AI Agent、Codex 与人工开发）均必须遵循本规范。

本规范主要约束：

* 模块职责
* 开发流程
* 架构边界
* 数据流
* Feature 开发方式

编码风格请参考：

《07-coding-rules.md》

---

# 2. 开发原则

整个项目遵循以下原则：

* Feature First
* MVVM
* Repository Pattern
* 单向数据流
* 高内聚
* 低耦合
* 单一职责
* 可维护
* 可扩展

开发过程中应优先保证代码清晰，而非追求过度抽象。

---

# 3. Feature 开发原则

每一个业务功能必须属于一个 Feature。

例如：

```text id="n2vgln"
Home

GameLibrary

History

Settings
```

禁止：

* 创建临时 Feature
* 多个业务混合到同一个 Feature
* Feature 之间直接调用内部实现

每个 Feature 应保持相对独立。

---

# 4. 分层职责

项目采用四层结构：

```text id="jqwwkd"
UI

↓

Provider

↓

Repository

↓

Storage
```

各层职责必须严格分离。

---

## UI 层

负责：

* 页面展示
* 用户交互
* Widget 组合
* 动画展示

禁止：

* 数据存储
* 数据查询
* 业务计算

---

## Provider 层

负责：

* 页面状态
* 调用 Repository
* 页面刷新
* 生命周期管理

禁止：

* 操作数据库
* 保存业务数据
* 引用其他 Feature Provider

---

## Repository 层

负责：

* 所有数据访问
* 数据转换
* 数据缓存（如未来需要）

Repository 是唯一的数据入口。

禁止：

* 引用 UI
* 引用 Widget
* 控制页面状态

---

## Storage 层

负责：

* Hive 数据读写
* 本地文件操作

Storage 不包含业务逻辑。

---

# 5. 数据流规范

所有业务数据必须遵循单向流动。

```text id="3ghw6u"
User

↓

UI

↓

Provider

↓

Repository

↓

Storage

↓

Repository

↓

Provider

↓

UI
```

禁止跳层访问。

例如：

UI 不允许直接访问 Hive。

---

# 6. 页面开发流程

开发新页面时，统一遵循以下流程：

1. 创建 Feature（如需要）。
2. 创建页面（Page）。
3. 创建页面专属 Widget。
4. 创建 Provider。
5. 创建 Repository（如新增业务）。
6. 完成业务逻辑。
7. 完成页面联调。
8. 自检并通过静态分析。

不得直接在 Page 中堆积所有代码。

---

# 7. Widget 开发原则

Widget 分为两类：

## 页面专属 Widget

仅服务于当前页面。

放置于当前 Feature。

例如：

```text id="stb8cq"
home/widgets/
```

---

## 通用 Widget

被多个 Feature 使用。

放置于：

```text id="zjbx5o"
shared/widgets/
```

不得为了“以后可能复用”提前放入 shared。

---

# 8. Provider 开发原则

每个页面对应一个主 Provider。

Provider 负责：

* 页面状态
* 页面事件
* 页面数据

Provider 不负责：

* 数据库存储
* 网络请求（未来）
* 文件操作

所有数据操作均通过 Repository。

---

# 9. Repository 开发原则

Repository 是唯一的数据访问层。

Repository 负责：

* 新增
* 修改
* 删除
* 查询
* 数据转换

未来如增加：

* 云同步
* 网络请求

仍由 Repository 对外提供统一接口。

---

# 10. Model 开发原则

Model 仅表示数据。

Model 不负责：

* 页面逻辑
* 动画
* Provider
* Storage

Model 应保持简单。

---

# 11. 状态管理原则

页面状态全部交由 Riverpod 管理。

包括：

* Loading
* Error
* Empty
* Success

UI 不维护业务状态。

---

# 12. 图片处理原则

所有用户图片：

选择后立即复制到应用沙盒。

数据库仅保存：

图片路径。

禁止保存：

* 相册 URI
* 临时缓存路径

---

# 13. 异常处理原则

所有业务异常均应在 Repository 或 Provider 层处理。

UI 仅负责展示：

* Toast
* Dialog
* Error Widget

不得在 UI 编写复杂异常逻辑。

---

# 14. Feature 通信原则

Feature 之间不得直接依赖。

例如：

禁止：

```text id="ow1uxv"
Home

↓

直接调用

HistoryProvider
```

如需共享数据：

统一通过 Repository。

---

# 15. 公共能力

所有公共能力统一放入：

core/

例如：

* Logger
* Storage
* Utils
* Animation
* Extension

Feature 不得自行实现重复能力。

---

# 16. Shared 使用原则

只有满足以下条件，才允许进入 shared：

* 至少两个 Feature 使用。
* 不依赖业务。
* 可独立复用。

否则应保留在所属 Feature 内。

---

# 17. 新功能开发流程

新增功能必须遵循以下步骤：

1. 更新对应 Sprint PRD。
2. 明确页面与业务边界。
3. 实现 Repository。
4. 实现 Provider。
5. 实现 UI。
6. 完成联调。
7. 更新相关文档（如有必要）。

不得直接跳过设计阶段。

---

# 18. 禁止事项

禁止：

* UI 操作数据库。
* Provider 调用 Provider。
* Feature 相互引用实现。
* 在多个地方保存同一份业务状态。
* 为未来需求进行过度设计。
* 未经确认修改公共架构。

---

# 19. 开发优先级

开发时遵循以下顺序：

1. 保证业务正确。
2. 保证架构一致。
3. 保证代码可维护。
4. 最后进行性能优化。

不要为了优化而牺牲可读性。

---

# 20. 文档关系

开发过程中应同时参考以下文档：

| 文档                      | 用途            |
| ----------------------- | ------------- |
| 01-prd.md               | 产品需求          |
| 02-tech-stack.md        | 技术架构          |
| 03-project-structure.md | 项目目录          |
| 04-ia.md                | 信息架构          |
| 05-design-system.md     | UI 规范（完成后）    |
| 07-coding-rules.md      | 编码规范          |
| AGENTS.md               | AI Agent 工作规范 |

---

**文档版本：V1.0**
