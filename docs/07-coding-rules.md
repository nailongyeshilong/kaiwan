# 07 - 编码规范（Coding Rules）

> 项目：开玩（KaiPlay）
> 文档版本：V1.0

---

# 1. 文档目的

本文档定义《开玩》项目的统一编码规范。

所有代码（包括 AI Agent、Codex 与人工开发）均必须遵循本文档。

本文档重点约束：

* 代码风格
* 命名规范
* 文件组织
* 代码质量
* 可维护性

---

# 2. 基本原则

所有代码必须遵循：

* 可读性优先
* 简洁优先
* 一致性优先
* 可维护优先
* 避免重复（DRY）
* 单一职责（SRP）
* 不进行过度设计（YAGNI）

不要为了未来可能存在的需求增加复杂度。

---

# 3. 空安全

整个项目必须启用 Dart Null Safety。

禁止：

* 使用 `dynamic` 作为默认类型。
* 使用 `!`（空断言）绕过空安全，除非经过充分判断且无法避免。

优先：

* 可空类型（`?`）
* 空值合并（`??`）
* 提前返回（Guard Clause）

---

# 4. 命名规范

## 文件

统一使用：

snake_case

例如：

```text
home_page.dart
game_repository.dart
history_provider.dart
```

---

## 类

统一使用：

PascalCase

例如：

```dart
HomePage
GameRepository
HistoryProvider
```

---

## 方法

统一使用：

camelCase

例如：

```dart
loadGames()
drawGame()
saveHistory()
```

---

## 变量

统一使用：

camelCase

名称必须表达真实含义。

禁止：

```dart
a
b
temp
obj
data2
```

推荐：

```dart
todayDrawCount
selectedGame
historyList
```

---

## 常量

统一使用：

lowerCamelCase + const

例如：

```dart
const maxDrawCount = 3;
```

---

# 5. 文件组织

一个 Dart 文件只负责一个主要职责。

建议：

* 一个 Widget 一个文件。
* 一个 Provider 一个文件。
* 一个 Repository 一个文件。
* 一个 Model 一个文件。

禁止：

* 一个文件包含多个页面。
* 一个文件承担多个业务模块。

---

# 6. Widget 规范

Widget 应尽可能保持简单。

建议：

* 页面负责布局。
* Widget 负责局部 UI。

当某一块 UI 可独立理解时，应拆分为独立 Widget。

禁止将整个页面写在一个 `build()` 方法中。

---

# 7. build() 方法规范

`build()` 方法只负责：

* 组合 Widget
* 渲染 UI

禁止：

* 查询数据库
* 修改状态
* 执行复杂计算
* 创建业务对象

复杂逻辑应放入 Provider 或 Repository。

---

# 8. Provider 规范

Provider 负责页面状态。

允许：

* 调用 Repository
* 更新状态
* 处理页面事件

禁止：

* 操作 Hive
* 操作文件
* 引用其他 Feature 的 Provider

---

# 9. Repository 规范

Repository 是唯一的数据访问入口。

允许：

* 查询
* 新增
* 更新
* 删除
* 数据转换

禁止：

* 引用 UI
* 控制页面状态
* 包含动画逻辑

---

# 10. Model 规范

Model 仅表示数据。

禁止：

* UI 方法
* Widget
* Provider
* Repository

Model 应保持轻量。

---

# 11. 方法规范

一个方法应只完成一件事情。

优先：

```dart
loadGameList()

saveHistory()

deleteGame()
```

避免：

```dart
loadAndSortAndSaveGames()
```

---

# 12. 参数规范

优先使用命名参数。

例如：

```dart
createGame({
  required String name,
  required String imagePath,
})
```

避免多个位置参数导致含义不明确。

---

# 13. 返回值规范

方法应返回明确类型。

禁止：

```dart
dynamic
Object
```

除非确有必要。

---

# 14. 异常处理

所有异常必须显式处理。

禁止：

```dart
catch (e) {}
```

至少应：

* 记录日志。
* 返回可处理结果。
* 保持应用稳定。

---

# 15. 日志规范

统一使用 Logger。

禁止：

```dart
print(...)
debugPrint(...)
```

开发日志应具有明确上下文。

例如：

```text
[HomeProvider] Draw game success.
```

---

# 16. Magic Number

禁止直接使用 Magic Number。

例如：

```dart
if (drawCount >= 3)
```

应改为：

```dart
const maxDrawCount = 3;

if (drawCount >= maxDrawCount)
```

---

# 17. 重复代码

相同逻辑不得复制。

重复达到两处以上，应考虑抽取公共方法或组件。

但不要为了减少几行代码而过度抽象。

---

# 18. 注释规范

代码应尽量通过命名表达含义。

仅在以下情况添加注释：

* 复杂业务规则。
* 非显而易见的实现原因。
* PRD 特殊约束。

避免解释代码本身。

---

# 19. 导入规范

优先导入：

1. Dart SDK
2. Flutter SDK
3. 第三方库
4. 项目内部

删除所有未使用的 import。

避免循环依赖。

---

# 20. 性能原则

优先保证代码正确。

在此前提下：

* 使用 `const` 构造函数（可用时）。
* 避免不必要的 Widget 重建。
* 避免重复计算。
* 避免在 `build()` 中创建重量级对象。

不要进行过早优化。

---

# 21. AI 修改代码规范

AI 在修改代码时必须遵循：

1. 优先修改已有实现，不重写整个文件。
2. 不修改当前任务无关代码。
3. 保持公共接口兼容。
4. 不随意调整目录结构。
5. 不改变架构设计。
6. 新增代码应保持与现有风格一致。

---

# 22. 提交前检查

每次完成开发后，应确保：

* `dart format` 已执行。
* `flutter analyze` 无错误。
* 无新增警告。
* 无未使用 import。
* 无明显重复代码。
* 新增代码符合本文档规范。

---

# 23. 文档关系

编码过程中应结合以下文档共同使用：

| 文档                      | 内容      |
| ----------------------- | ------- |
| 01-prd.md               | 产品需求    |
| 02-tech-stack.md        | 技术架构    |
| 03-project-structure.md | 项目目录规范  |
| 04-ia.md                | 信息架构    |
| 05-design-system.md     | UI 规范   |
| 06-development-guide.md | 开发规范    |
| AGENTS.md               | AI 工作规范 |

---

**文档版本：V1.0**
