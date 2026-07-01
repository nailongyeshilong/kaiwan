# 05-design-system.md

# UI 设计规范（Design System）

> Version: 1.0
>
> Project: AI Gacha
>
> Platform: Flutter (Android / iOS)
>
> Theme: Steam Inspired + Cyber Game Style
>
> Last Update: 2026-07-01

---

# 1. 设计理念（Design Principles）

## 1.1 产品定位

AI Gacha 是一款面向男性用户的 AI 抽卡应用。

整体视觉参考 Steam 官方客户端，强调：

- 游戏感（Gaming）
- 科技感（Technology）
- 沉稳（Professional）
- 信息密度适中（Information Rich）
- 操作直接（Efficient）
- 沉浸感（Immersive）

避免：

- 花哨
- 少女风
- 高饱和渐变
- 玻璃拟态
- 复杂阴影

---

## 1.2 品牌关键词

```
未来感
轻科技
赛博朋克
游戏平台
沉稳
高级
克制
探索
收藏
抽卡
```

---

## 1.3 品牌 Slogan

> 即刻开玩！

---

# 2. Design Token

所有颜色、尺寸、字体、圆角必须统一管理。

禁止页面内直接写 Magic Number。

例如：

❌

```dart
Color(0xff66C0F4)
```

✅

```dart
AppColors.primary
```

---

# 3. Color System

## Dark Theme（默认）

### Background

| Token | Value |
|--------|--------|
| background | #171A21 |
| surface | #1B2838 |
| card | #2A475E |
| divider | #3B4A5A |

---

### Primary

| Token | Value |
|--------|--------|
| primary | #66C0F4 |
| primaryContainer | #4A89B8 |
| secondary | #3D6F8E |

---

### Text

| Token | Value |
|--------|--------|
| textPrimary | #C7D5E0 |
| textSecondary | #8F98A0 |
| textHint | #6E7681 |

---

### Status

| Token | Value |
|--------|--------|
| success | #4CAF50 |
| warning | #FFC107 |
| error | #F44336 |
| info | #42A5F5 |

---

## Light Theme

Dark Theme 自动映射 Material3 ColorScheme。

整体保持 Steam 风格，不采用纯白背景。

推荐：

Background：

```
#F5F7FA
```

Surface：

```
#FFFFFF
```

Primary：

```
#1976D2
```

---

# 4. Typography

字体：

Android：

```
Roboto
```

iOS：

```
SF Pro
```

Flutter：

默认系统字体。

---

字号

| Token | Size |
|--------|------|
| display | 32 |
| headline | 28 |
| titleLarge | 22 |
| title | 20 |
| bodyLarge | 18 |
| body | 16 |
| bodySmall | 14 |
| caption | 12 |

---

字体粗细

Title：

```
600
```

Body：

```
400
```

Button：

```
600
```

数字：

```
500
```

---

# 5. Spacing

采用 4pt Grid。

所有间距必须来自统一 Token。

| Token | Value |
|--------|------|
| xs | 4 |
| sm | 8 |
| md | 12 |
| lg | 16 |
| xl | 24 |
| xxl | 32 |

禁止：

```
17

23

31
```

---

# 6. Radius

整体采用 Steam 风格。

禁止大圆角。

| Token | Value |
|--------|------|
| xs | 4 |
| sm | 6 |
| md | 8 |
| lg | 12 |

Card：

```
8
```

Button：

```
8
```

Dialog：

```
8
```

BottomSheet：

```
12
```

---

# 7. Shadow

整体采用低阴影设计。

Elevation：

```
0

1

2
```

禁止：

- 大面积阴影
- 漂浮卡片
- Material 默认重阴影

---

# 8. Border

Border Color：

```
Divider
```

Border Width：

```
1
```

输入框 Focus：

```
Primary
```

---

# 9. Icon

统一使用：

Material Symbols Outlined

禁止：

- 彩色 Icon
- 3D Icon
- Emoji

Icon Size：

| Token | Value |
|--------|------|
| sm | 18 |
| md | 24 |
| lg | 32 |

---

# 10. Button

Primary

背景：

Primary

文字：

White

高度：

48

Radius：

8

---

Secondary

背景：

Surface

Border：

Divider

---

Danger

背景：

Error

---

Loading

按钮不可点击。

显示 CircularProgressIndicator。

---

点击反馈

Scale：

```
1 → 0.96
```

Duration：

```
120ms
```

Curve：

```
easeOut
```

支持：

```
HapticFeedback.selectionClick()
```

---

# 11. Card

整体参考 Steam。

背景：

Card

Radius：

8

Padding：

16

禁止：

玻璃拟态。

---

# 12. Input

样式参考 Steam。

Background：

Surface

Radius：

8

Focus：

Primary

Label：

Secondary Text

Error：

Error

---

# 13. List

统一高度：

```
56
```

支持：

Leading

Title

Subtitle

Trailing

Divider

---

# 14. Navigation

BottomNavigation：

高度：

```
64
```

Icon：

24

Label：

12

当前页面：

Primary

其他：

Secondary Text

---

# 15. Dialog

宽度：

```
90%
```

Radius：

8

Padding：

24

按钮：

Primary + Secondary

---

# 16. Motion

整体动画：

自然。

禁止：

炫技。

---

页面切换

Duration：

```
250ms
```

Curve：

```
easeOutCubic
```

---

Button

Duration：

```
120ms
```

---

Dialog

Duration：

```
200ms
```

Scale：

```
0.95 → 1
```

Fade：

```
0 → 1
```

---

# 17. 抽卡动画规范（Gacha Motion）

抽卡是整个产品唯一允许拥有复杂动画的页面。

流程：

```
点击

↓

按钮缩放

↓

轻震动

↓

音效

↓

Loading

↓

卡片出现

↓

光效

↓

翻转

↓

结果

↓

震动

↓

收藏
```

SSR：

金色粒子。

UR：

金色 + 蓝色粒子。

动画时间：

```
1500~2500ms
```

支持：

```
HapticFeedback.mediumImpact()
```

获得 UR：

```
HapticFeedback.heavyImpact()
```

支持：

音效。

---

# 18. 卡片规范

比例：

```
2:3
```

内容：

```
角色图

名称

品质

标签
```

圆角：

```
8
```

封面必须铺满。

---

# 19. 品质颜色

| 品质 | Color |
|------|--------|
| N | #8F98A0 |
| R | #4CAF50 |
| SR | #42A5F5 |
| SSR | #AB47BC |
| UR | #FFC107 |

---

# 20. 页面布局规范

页面统一：

```
SafeArea

↓

AppBar

↓

Body

↓

BottomNavigation
```

页面左右 Padding：

```
16
```

Section 间距：

```
24
```

Card 间距：

```
12
```

---

# 21. Flutter Theme

统一封装：

```
AppTheme
```

包含：

```
ColorScheme

TextTheme

InputDecorationTheme

CardTheme

FilledButtonTheme

OutlinedButtonTheme

BottomNavigationBarTheme

DialogTheme
```

禁止页面覆盖 Theme。

---

# 22. Design Token

统一定义：

```
AppColors

AppTextStyle

AppSpacing

AppRadius

AppDuration

AppElevation

AppIcons
```

禁止：

```
Color()

EdgeInsets.only()

BorderRadius.circular()

TextStyle()

Duration()

```

直接写在页面。

---

# 23. AI 页面生成规范

所有 AI（Codex / ChatGPT / Claude 等）生成 Flutter 页面时必须遵循：

## 必须

✅ Material3

✅ ThemeData

✅ ColorScheme

✅ Design Token

✅ Dark/Light 自动切换

✅ const 优先

✅ StatelessWidget 优先

✅ 响应式布局

---

禁止：

❌ Magic Number

❌ 写死颜色

❌ 页面直接写 TextStyle

❌ 页面直接写 Padding 数值

❌ 自定义随机动画

❌ 不遵循 Theme

---

所有页面必须保持统一视觉语言。

当设计规范与页面需求冲突时，以本规范为最高优先级。

---

# 24. 总结

AI Gacha 的 UI 风格定位：

- Steam 风格
- 游戏平台
- 深色科技感
- 男性用户
- 信息密度适中
- Material3
- Flutter 原生体验
- 抽卡页面拥有最强沉浸动画
- 其它页面保持克制、简洁、高效

最终目标：

让用户感觉这不是一个普通工具 App，而是一款专业游戏平台。