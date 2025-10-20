# SplitViewKit 使用指南

本指南将详细介绍如何在您的项目中使用 SplitViewKit 框架。

## 目录

- [安装](#安装)
- [基础使用](#基础使用)
- [配置选项](#配置选项)
- [状态管理](#状态管理)
- [主题系统](#主题系统)
- [高级功能](#高级功能)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

## 安装

### Swift Package Manager

1. 在 Xcode 中打开您的项目
2. 选择 `File` → `Add Package Dependencies...`
3. 输入仓库 URL
4. 选择版本并添加到您的项目

## 基础使用

### 创建基础两栏布局

```swift
import SwiftUI
import SplitViewKit

struct ContentView: View {
    @StateObject private var splitState = SplitViewState()
    
    var body: some View {
        SplitView(state: splitState) {
            // 侧边栏内容
            List {
                ForEach(1..<20) { item in
                    Text("Item \(item)")
                }
            }
        } content: {
            // 主内容区域
            Text("Main Content Area")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
```

### 添加工具栏按钮

```swift
.toolbar {
    ToolbarItem(placement: .navigation) {
        SplitView.toggleSidebarButton(state: splitState)
    }
}
```

## 配置选项

### 使用预设配置

SplitViewKit 提供了三种预设配置：

```swift
// 默认配置
let state1 = SplitViewState(configuration: .default)

// 紧凑配置（适合小屏幕）
let state2 = SplitViewState(configuration: .compact)

// 宽松配置（适合大屏幕）
let state3 = SplitViewState(configuration: .spacious)
```

### 自定义配置

```swift
let customConfig = SplitViewConfiguration(
    minSidebarWidth: 150,        // 最小侧边栏宽度
    maxSidebarWidth: 400,        // 最大侧边栏宽度
    defaultSidebarWidth: 250,    // 默认侧边栏宽度
    dividerWidth: 1,             // 分割线宽度
    isDraggable: true,           // 是否可拖拽
    showDividerIndicator: true,  // 是否显示拖拽指示器
    isCollapsible: true,         // 是否可折叠
    dividerColor: .gray,         // 分割线颜色
    dividerHoverColor: .blue,    // 悬停时分割线颜色
    sidebarBackgroundColor: nil, // 侧边栏背景色（nil = 系统默认）
    contentBackgroundColor: nil  // 主内容区背景色（nil = 系统默认）
)

let state = SplitViewState(configuration: customConfig)
```

## 状态管理

### 基本状态控制

```swift
@StateObject private var splitState = SplitViewState()

// 在代码中控制侧边栏
Button("切换侧边栏") {
    splitState.toggleSidebar()
}

Button("显示侧边栏") {
    splitState.showSidebar()
}

Button("隐藏侧边栏") {
    splitState.hideSidebar()
}

Button("重置宽度") {
    splitState.resetToDefaultWidth()
}
```

### 监听状态变化

```swift
struct ContentView: View {
    @StateObject private var splitState = SplitViewState()
    
    var body: some View {
        SplitView(state: splitState) {
            // ...
        } content: {
            // ...
        }
        .onChange(of: splitState.isSidebarCollapsed) { _, isCollapsed in
            print("侧边栏折叠状态: \(isCollapsed)")
        }
        .onChange(of: splitState.sidebarWidth) { _, width in
            print("侧边栏宽度: \(width)")
        }
    }
}
```

### 持久化状态

```swift
class SplitViewStateManager: ObservableObject {
    @Published var splitState: SplitViewState
    
    init() {
        // 从 UserDefaults 恢复状态
        let savedWidth = UserDefaults.standard.double(forKey: "sidebarWidth")
        let config = SplitViewConfiguration.default
        
        self.splitState = SplitViewState(configuration: config)
        
        if savedWidth > 0 {
            splitState.sidebarWidth = CGFloat(savedWidth)
        }
        
        // 监听宽度变化并保存
        splitState.$sidebarWidth
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { width in
                UserDefaults.standard.set(Double(width), forKey: "sidebarWidth")
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
}
```

## 主题系统

### 使用预设主题

```swift
SplitView(state: splitState) {
    // ...
} content: {
    // ...
}
.splitViewTheme(.ocean)  // 海洋主题
```

### 可用的预设主题

```swift
.splitViewTheme(.system)  // 系统默认（自适应）
.splitViewTheme(.light)   // 明亮主题
.splitViewTheme(.dark)    // 深色主题
.splitViewTheme(.ocean)   // 海洋主题
.splitViewTheme(.forest)  // 森林主题
.splitViewTheme(.sunset)  // 日落主题
```

### 创建自定义主题

```swift
let customTheme = SplitViewTheme(
    sidebarBackground: Color(red: 0.95, green: 0.95, blue: 0.97),
    contentBackground: Color.white,
    dividerColor: Color.gray.opacity(0.3),
    dividerHoverColor: Color.blue.opacity(0.5),
    sidebarTextColor: Color.primary,
    contentTextColor: Color.primary,
    accentColor: Color.blue
)

SplitView(state: splitState) {
    // ...
} content: {
    // ...
}
.splitViewTheme(customTheme)
```

### 动态切换主题

```swift
struct ContentView: View {
    @StateObject private var splitState = SplitViewState()
    @State private var selectedTheme: SplitViewTheme = .system
    
    var body: some View {
        VStack {
            Picker("主题", selection: $selectedTheme) {
                Text("系统").tag(SplitViewTheme.system)
                Text("海洋").tag(SplitViewTheme.ocean)
                Text("森林").tag(SplitViewTheme.forest)
            }
            .pickerStyle(.segmented)
            .padding()
            
            SplitView(state: splitState) {
                // ...
            } content: {
                // ...
            }
            .splitViewTheme(selectedTheme)
        }
    }
}
```

## 高级功能

### 三栏布局

```swift
struct TripleLayoutView: View {
    @StateObject private var tripleState = TripleSplitViewState()
    
    var body: some View {
        TripleSplitView(state: tripleState) {
            // 左侧边栏
            NavigationView()
        } content: {
            // 主内容
            MainContentView()
        } trailingSidebar: {
            // 右侧边栏
            InspectorView()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                TripleSplitView.toggleLeadingSidebarButton(state: tripleState)
            }
            ToolbarItem(placement: .automatic) {
                TripleSplitView.toggleTrailingSidebarButton(state: tripleState)
            }
        }
    }
}
```

### 响应式布局

根据屏幕尺寸动态调整配置：

```swift
struct ResponsiveView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject private var splitState: SplitViewState
    
    init() {
        let config: SplitViewConfiguration
        if UIDevice.current.userInterfaceIdiom == .pad {
            config = .spacious
        } else {
            config = .compact
        }
        _splitState = StateObject(wrappedValue: SplitViewState(configuration: config))
    }
    
    var body: some View {
        SplitView(state: splitState) {
            // ...
        } content: {
            // ...
        }
    }
}
```

### 嵌套布局

在主内容区域中嵌套另一个 SplitView：

```swift
struct NestedSplitView: View {
    @StateObject private var outerState = SplitViewState()
    @StateObject private var innerState = SplitViewState(
        configuration: SplitViewConfiguration(
            minSidebarWidth: 100,
            maxSidebarWidth: 250,
            defaultSidebarWidth: 150
        )
    )
    
    var body: some View {
        SplitView(state: outerState) {
            // 外层侧边栏
            OuterSidebar()
        } content: {
            // 内层嵌套的 SplitView
            SplitView(state: innerState) {
                InnerSidebar()
            } content: {
                MainContent()
            }
        }
    }
}
```

## 最佳实践

### 1. 状态管理

- 使用 `@StateObject` 来管理 SplitViewState
- 避免在 body 中创建新的 state 实例
- 考虑使用持久化保存用户的布局偏好

### 2. 性能优化

```swift
// 使用 LazyVStack/LazyHStack 来优化大列表
SplitView(state: splitState) {
    ScrollView {
        LazyVStack {
            ForEach(items) { item in
                ItemRow(item: item)
            }
        }
    }
} content: {
    // ...
}
```

### 3. 可访问性

```swift
SplitView.toggleSidebarButton(state: splitState)
    .accessibilityLabel("切换侧边栏")
    .accessibilityHint("显示或隐藏侧边栏")
```

### 4. 键盘快捷键

```swift
.keyboardShortcut("s", modifiers: [.command])
.onKeyPress(.return) {
    splitState.toggleSidebar()
    return .handled
}
```

## 常见问题

### Q: 如何禁用拖拽功能？

```swift
let config = SplitViewConfiguration(
    isDraggable: false
)
let state = SplitViewState(configuration: config)
```

### Q: 如何设置固定宽度的侧边栏？

```swift
let config = SplitViewConfiguration(
    minSidebarWidth: 250,
    maxSidebarWidth: 250,
    defaultSidebarWidth: 250,
    isDraggable: false
)
```

### Q: 如何在 iPad 上自动折叠侧边栏？

```swift
struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject private var splitState = SplitViewState()
    
    var body: some View {
        SplitView(state: splitState) {
            // ...
        } content: {
            // ...
        }
        .onChange(of: sizeClass) { _, newValue in
            if newValue == .compact {
                splitState.hideSidebar()
            } else {
                splitState.showSidebar()
            }
        }
    }
}
```

### Q: 如何自定义分割线外观？

```swift
let config = SplitViewConfiguration(
    dividerWidth: 2,
    showDividerIndicator: true,
    dividerColor: .blue,
    dividerHoverColor: .blue.opacity(0.7)
)
```

### Q: 支持哪些平台？

SplitViewKit 支持：
- macOS 13.0+
- iPadOS 16.0+

不支持 iPhone（建议在 iPhone 上使用原生 NavigationStack）

## 更多示例

查看 `Examples/` 目录中的完整示例：

- `BasicExample.swift` - 基础两栏布局示例
- `TripleExample.swift` - 三栏布局示例

## 获取帮助

如有问题或建议，请：

1. 查看文档：[README.md](README.md)
2. 查看示例代码
3. 提交 Issue

---

祝您使用愉快！🎉

