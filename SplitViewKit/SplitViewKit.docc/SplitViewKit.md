# ``SplitViewKit``

一个可复用的左右分栏框架，用于 macOS 和 iPadOS 的 SwiftUI 应用。

## 概述

SplitViewKit 是一个功能强大且灵活的分栏布局框架，专为 macOS 和 iPadOS 设计。它提供了类似 `NavigationSplitView` 的功能，但具有更高的定制灵活性。

### 核心功能

- **两栏和三栏布局**：支持标准的两栏布局以及更复杂的三栏布局
- **可拖拽分割线**：用户可以通过拖拽分割线来动态调整侧边栏宽度
- **侧边栏折叠**：支持侧边栏的展开和折叠，优化屏幕空间利用
- **主题系统**：内置多种预设主题（浅色、深色、海洋、森林、日落等）
- **样式定制**：支持自定义样式，包括默认样式、卡片样式、边框样式等
- **深色模式支持**：完美适配 macOS 和 iPadOS 的浅色/深色模式
- **状态管理**：完整的状态管理系统，便于控制和同步 UI 状态

### 快速开始

#### 创建基础两栏布局

```swift
import SplitViewKit
import SwiftUI

struct MyApp: View {
    @StateObject private var splitState = SplitViewState()
    
    var body: some View {
        SplitView(state: splitState) {
            // 侧边栏内容
            NavigationStack {
                List(1..<50) { item in
                    NavigationLink("Item \(item)") {
                        Text("Detail for Item \(item)")
                    }
                }
                .navigationTitle("Sidebar")
            }
        } content: {
            // 主内容区域
            VStack {
                Text("欢迎使用 SplitViewKit")
                    .font(.largeTitle)
                Text("选择左侧项目查看详情")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
```

#### 应用自定义配置

```swift
let configuration = SplitViewConfiguration(
    minSidebarWidth: 200,
    maxSidebarWidth: 500,
    defaultSidebarWidth: 300,
    isDraggable: true,
    isCollapsible: true
)

let splitState = SplitViewState(configuration: configuration)
```

#### 使用预设主题

```swift
SplitView(state: splitState) {
    // ...
} content: {
    // ...
}
.splitViewTheme(.ocean) // 应用海洋主题
```

### 高级用法

#### 三栏布局

```swift
@StateObject private var tripleState = TripleSplitViewState()

TripleSplitView(state: tripleState) {
    // 左侧边栏
    VStack {
        Text("导航")
            .font(.headline)
        List(items) { item in
            Text(item.name)
        }
    }
} content: {
    // 主内容区
    ContentDetailView()
} trailingSidebar: {
    // 右侧边栏
    InspectorView()
}
```

#### 控制侧边栏状态

```swift
// 切换侧边栏
splitState.toggleSidebar()

// 显示/隐藏侧边栏
splitState.showSidebar()
splitState.hideSidebar()

// 设置侧边栏宽度
splitState.setSidebarWidth(300)

// 重置为默认宽度
splitState.resetToDefaultWidth()
```

## 主题

### 预设主题

SplitViewKit 提供了多种预设主题：

- **system**: 系统默认（自适应浅色/深色）
- **light**: 明亮主题
- **dark**: 深色主题
- **ocean**: 海洋主题（蓝色调）
- **forest**: 森林主题（绿色调）
- **sunset**: 日落主题（粉色调）

### 自定义主题

```swift
let customTheme = SplitViewTheme(
    sidebarBackground: Color.purple.opacity(0.1),
    contentBackground: Color.white,
    dividerColor: Color.purple,
    dividerHoverColor: Color.purple.opacity(0.7),
    sidebarTextColor: Color.primary,
    contentTextColor: Color.primary,
    accentColor: Color.purple
)

// 应用自定义主题
.splitViewTheme(customTheme)
```

## 系统要求

- **macOS**: 13.0+
- **iOS/iPadOS**: 16.0+
- **Xcode**: 14.0+
- **Swift**: 5.7+

## Topics

### 核心视图

- ``SplitView``
- ``TripleSplitView``

### 配置与状态

- ``SplitViewConfiguration``
- ``SplitViewState``
- ``TripleSplitViewState``

### 主题系统

- ``SplitViewTheme``
- ``SplitViewStyle``

### 组件

- ``DividerView``