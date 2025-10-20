# SplitViewKit

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS%20%7C%20iPadOS-lightgrey.svg" alt="Platform: macOS | iPadOS">
  <img src="https://img.shields.io/badge/Swift-5.7+-orange.svg" alt="Swift 5.7+">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
</p>

一个可复用的左右分栏框架，专为 macOS 和 iPadOS 的 SwiftUI 应用设计。类似 `NavigationSplitView`，但提供更高的定制灵活性。

## ✨ 特性

- ✅ **两栏和三栏布局** - 支持标准的两栏布局以及更复杂的三栏布局
- ✅ **可拖拽分割线** - 用户可以通过拖拽分割线来动态调整侧边栏宽度
- ✅ **侧边栏折叠** - 支持侧边栏的展开和折叠，优化屏幕空间利用
- ✅ **丰富的主题系统** - 内置多种预设主题（浅色、深色、海洋、森林、日落等）
- ✅ **灵活的样式定制** - 支持自定义样式，包括默认样式、卡片样式、边框样式等
- ✅ **深色模式支持** - 完美适配 macOS 和 iPadOS 的浅色/深色模式
- ✅ **完整的状态管理** - 便于控制和同步 UI 状态
- ✅ **跨平台兼容** - 同时支持 macOS 和 iPadOS

## 📦 安装

### Swift Package Manager

在 Xcode 中，通过以下方式添加 SplitViewKit：

1. 打开您的项目
2. 选择 `File` → `Add Package Dependencies...`
3. 输入仓库 URL：`https://github.com/yourusername/SplitViewKit.git`
4. 选择版本并添加到您的项目

或者在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SplitViewKit.git", from: "1.0.0")
]
```

## 🚀 快速开始

### 基础两栏布局

```swift
import SwiftUI
import SplitViewKit

struct ContentView: View {
    @StateObject private var splitState = SplitViewState()
    
    var body: some View {
        SplitView(state: splitState) {
            // 侧边栏内容
            VStack(alignment: .leading, spacing: 8) {
                Text("侧边栏")
                    .font(.headline)
                    .padding()
                
                List(1..<20) { index in
                    Text("项目 \(index)")
                }
            }
        } content: {
            // 主内容区域
            VStack {
                Text("主内容区域")
                    .font(.largeTitle)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
```

### 三栏布局

```swift
struct ContentView: View {
    @StateObject private var tripleState = TripleSplitViewState()
    
    var body: some View {
        TripleSplitView(state: tripleState) {
            // 左侧边栏
            NavigationView()
        } content: {
            // 主内容
            ContentView()
        } trailingSidebar: {
            // 右侧边栏
            InspectorView()
        }
    }
}
```

### 自定义配置

```swift
let configuration = SplitViewConfiguration(
    minSidebarWidth: 200,
    maxSidebarWidth: 500,
    defaultSidebarWidth: 300,
    dividerWidth: 1,
    isDraggable: true,
    showDividerIndicator: true,
    isCollapsible: true
)

let splitState = SplitViewState(configuration: configuration)

SplitView(state: splitState) {
    // ...
} content: {
    // ...
}
```

### 应用主题

```swift
SplitView(state: splitState) {
    // ...
} content: {
    // ...
}
.splitViewTheme(.ocean) // 应用海洋主题
```

## 🎨 预设主题

SplitViewKit 提供了多种精美的预设主题：

- **`.system`** - 系统默认（自适应浅色/深色模式）
- **`.light`** - 明亮主题
- **`.dark`** - 深色主题
- **`.ocean`** - 海洋主题（蓝色调）
- **`.forest`** - 森林主题（绿色调）
- **`.sunset`** - 日落主题（粉色调）

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

.splitViewTheme(customTheme)
```

## 🛠 状态管理

### 控制侧边栏

```swift
// 切换侧边栏
splitState.toggleSidebar()

// 显示侧边栏
splitState.showSidebar()

// 隐藏侧边栏
splitState.hideSidebar()

// 设置侧边栏宽度
splitState.setSidebarWidth(300)

// 重置为默认宽度
splitState.resetToDefaultWidth()
```

### 添加切换按钮

```swift
ToolbarItem(placement: .navigation) {
    SplitView.toggleSidebarButton(state: splitState)
}
```

## 📖 高级用法

### 预设配置

```swift
// 紧凑配置（适用于较小屏幕）
let splitState = SplitViewState(configuration: .compact)

// 宽松配置（适用于大屏幕）
let splitState = SplitViewState(configuration: .spacious)
```

### 响应式布局

```swift
@Environment(\.horizontalSizeClass) var sizeClass

var body: some View {
    let configuration: SplitViewConfiguration = sizeClass == .compact ? .compact : .spacious
    
    SplitView(configuration: configuration) {
        // ...
    } content: {
        // ...
    }
}
```

## 📋 系统要求

- **macOS**: 13.0+
- **iOS/iPadOS**: 16.0+
- **Xcode**: 14.0+
- **Swift**: 5.7+

## 🎯 设计理念

SplitViewKit 的设计遵循以下原则：

1. **易用性** - 简洁的 API，开箱即用
2. **灵活性** - 高度可定制，满足各种需求
3. **性能** - 优化的渲染和状态管理
4. **美观** - 精心设计的主题和样式
5. **跨平台** - 同时支持 macOS 和 iPadOS

## 🤝 贡献

欢迎贡献代码、报告问题或提出新功能建议！

## 📄 许可证

SplitViewKit 采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 🌟 致谢

感谢所有为 SplitViewKit 做出贡献的开发者！

---

Made with ❤️ by 神伤

