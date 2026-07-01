# 03 - 项目目录规范（Project Structure）

> 项目：开玩（KaiPlay）
> 文档版本：V1.0

---

# 1. 文档目的

本文档用于规范整个项目的目录结构。

所有新增代码必须遵循本文档。

开发过程中不得随意新增一级目录。

---

# 2. 整体目录

项目采用 **Feature First** 目录结构。

```text
lib/
│
├── app/
├── core/
├── features/
├── shared/
│
└── main.dart
```

所有业务代码均位于 `lib/` 下。

---

# 3. 一级目录职责

## app

负责整个应用的初始化。

包括：

* App
* Router
* Theme
* App Config
* Constants

禁止放业务代码。

---

## core

负责整个项目的基础能力。

包括：

* Storage
* Database
* Service
* Utils
* Extensions
* Animation
* Exception
* Logger

core 不允许依赖任何 Feature。

Feature 可以依赖 core。

---

## features

负责所有业务功能。

每一个业务模块都是一个 Feature。

例如：

```text
features/

home/

game_library/

history/

settings/
```

所有页面均应属于某个 Feature。

禁止直接放到 lib 根目录。

---

## shared

负责多个 Feature 共用的内容。

包括：

* 通用 Widget
* 通用 Dialog
* 通用 Model
* Enum
* Loading
* EmptyView
* ErrorView

只有两个及以上 Feature 使用时，才允许放入 shared。

否则应放回所属 Feature。

---

# 4. Feature 目录结构

每个 Feature 保持完全一致。

例如：

```text
home/

presentation/

domain/

data/
```

---

## presentation

负责 UI 层。

包括：

```text
presentation/

pages/

widgets/

providers/
```

说明：

pages

页面。

widgets

页面专属 Widget。

providers

Riverpod Provider。

---

## domain

负责业务抽象。

包括：

```text
domain/

entities/

repositories/
```

说明：

entities

业务实体。

repositories

Repository 接口。

---

## data

负责数据实现。

包括：

```text
data/

models/

repositories/
```

说明：

models

数据模型。

repositories

Repository 实现。

---

# 5. 页面组织

每个页面放入 pages。

例如：

```text
presentation/

pages/

home_page.dart

game_library_page.dart
```

一个页面一个文件。

禁止多个页面写入同一文件。

---

# 6. Widget 组织

页面专属 Widget 放入：

```text
presentation/widgets/
```

例如：

```text
draw_button.dart

game_card.dart

history_item.dart
```

如果 Widget 可复用，则移动到：

```text
shared/widgets/
```

---

# 7. Provider 组织

每个 Feature 自己维护 Provider。

例如：

```text
home_provider.dart

history_provider.dart
```

禁止跨 Feature 引用 Provider。

跨模块数据应通过 Repository 获取。

---

# 8. Repository 组织

Repository 分为：

接口：

```text
domain/repositories/
```

实现：

```text
data/repositories/
```

UI 不允许直接访问数据源。

所有数据必须经过 Repository。

---

# 9. Model 组织

业务数据模型放入：

```text
data/models/
```

例如：

```text
game_model.dart

history_model.dart

setting_model.dart
```

禁止在 UI 中定义数据类。

---

# 10. 图片资源

项目资源统一放入：

```text
assets/
```

建议目录：

```text
assets/

images/

icons/

animations/

fonts/
```

用户选择的图片不放入 assets。

统一复制到应用沙盒。

---

# 11. 新增 Feature 规范

新增业务功能时：

必须创建新的 Feature。

例如：

```text
features/

achievement/

member/

cloud_sync/
```

禁止把多个业务混合到已有 Feature。

---

# 12. 新增共享组件

只有满足以下条件时，才允许放入 shared：

* 至少两个 Feature 使用
* 不依赖具体业务
* 可独立复用

否则放回所属 Feature。

---

# 13. 一级目录新增规则

禁止新增一级目录。

例如：

以下目录禁止创建：

```text
manager/

helper/

common/

base/

util2/

temp/
```

如确需新增，应先更新本文档。

---

# 14. 依赖原则

依赖关系如下：

```text
app
 │
 ▼
features
 │
 ▼
shared
 │
 ▼
core
```

禁止反向依赖。

例如：

* core 不依赖 feature
* shared 不依赖具体 feature
* feature 不互相依赖

---

# 15. 命名规范

目录：

统一使用 snake_case。

例如：

```text
game_library

home

history
```

文件：

统一 snake_case。

例如：

```text
game_card.dart

home_provider.dart

history_repository.dart
```

禁止：

```text
GameCard.dart

HomeProvider.dart
```

---

# 16. 文档关系

本规范仅负责目录结构。

其它规范请参考：

* 02-tech-stack.md（技术架构）
* 04-design-system.md（UI 规范）
* 05-ia.md（信息架构）
* 06-development-guide.md（开发规范）
* 07-coding-rules.md（编码规范）
* AGENTS.md（AI 开发助手规范）

---

**文档版本：V1.0**
