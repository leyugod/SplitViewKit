# SplitViewKit 架构文档

本文档介绍 SplitViewKit 框架的整体架构设计和实现细节。

## 📁 项目结构

```
SplitViewKit/
├── SplitViewKit/
│   ├── Models/                      # 数据模型
│   │   ├── SplitViewConfiguration.swift  # 配置模型
│   │   └── SplitViewState.swift         # 状态管理
│   ├── Views/                       # 核心视图组件
│   │   ├── SplitView.swift             # 两栏布局
│   │   └── TripleSplitView.swift       # 三栏布局
│   ├── Components/                  # 可复用组件
│   │   └── DividerView.swift           # 分割线组件
│   ├── Theming/                     # 主题系统
│   │   ├── SplitViewTheme.swift        # 主题定义
│   │   └── SplitViewStyle.swift        # 样式系统
│   ├── SplitViewKit.swift           # 主入口文件
│   └── SplitViewKit.docc/           # DocC 文档
├── Examples/                        # 示例代码
│   ├── BasicExample.swift              # 基础两栏示例
│   └── TripleExample.swift             # 三栏布局示例
├── README.md                        # 项目说明
├── USAGE_GUIDE.md                   # 使用指南
├── ARCHITECTURE.md                  # 架构文档（本文件）
├── CHANGELOG.md                     # 变更日志
└── LICENSE                          # 许可证
```

## 🏗 架构设计

### 设计模式

SplitViewKit 采用以下设计模式：

#### 1. MVVM（Model-View-ViewModel）

```
┌─────────────────────────────────────────────────┐
│                    View Layer                    │
│  ┌──────────────┐  ┌──────────────────────────┐ │
│  │  SplitView   │  │  TripleSplitView        │ │
│  └──────────────┘  └──────────────────────────┘ │
└─────────────────────────────────────────────────┘
                        ↓ ↑
┌─────────────────────────────────────────────────┐
│                 ViewModel Layer                  │
│  ┌──────────────────┐  ┌────────────────────┐  │
│  │  SplitViewState  │  │ TripleSplitViewState│ │
│  └──────────────────┘  └────────────────────┘  │
└─────────────────────────────────────────────────┘
                        ↓ ↑
┌─────────────────────────────────────────────────┐
│                   Model Layer                    │
│           ┌────────────────────────┐             │
│           │ SplitViewConfiguration │             │
│           └────────────────────────┘             │
└─────────────────────────────────────────────────┘
```

#### 2. 组件化（Component-Based）

每个功能模块都是独立的、可复用的组件：

- **DividerView**: 可拖拽的分割线
- **SplitView**: 两栏布局容器
- **TripleSplitView**: 三栏布局容器

#### 3. 策略模式（Strategy Pattern）

主题系统使用策略模式，允许运行时切换不同的视觉风格。

## 🔧 核心组件详解

### 1. SplitViewConfiguration

**职责**：定义 SplitView 的配置选项

**关键属性**：
- `minSidebarWidth`: 最小侧边栏宽度
- `maxSidebarWidth`: 最大侧边栏宽度
- `defaultSidebarWidth`: 默认侧边栏宽度
- `dividerWidth`: 分割线宽度
- `isDraggable`: 是否可拖拽
- `showDividerIndicator`: 是否显示拖拽指示器
- `isCollapsible`: 是否可折叠

**预设配置**：
- `default`: 默认配置
- `compact`: 紧凑配置
- `spacious`: 宽松配置

### 2. SplitViewState

**职责**：管理 SplitView 的运行时状态

**关键属性**：
```swift
@Published var sidebarWidth: CGFloat
@Published var isSidebarCollapsed: Bool
@Published var isSidebarVisible: Bool
let configuration: SplitViewConfiguration
```

**关键方法**：
- `toggleSidebar()`: 切换侧边栏
- `showSidebar()`: 显示侧边栏
- `hideSidebar()`: 隐藏侧边栏
- `setSidebarWidth(_:)`: 设置宽度
- `resetToDefaultWidth()`: 重置宽度

**状态流转**：
```
                    ┌──────────────┐
      初始化 ──────>│   Visible    │<────── showSidebar()
                    │  Expanded    │
                    └──────────────┘
                           │
                  toggleSidebar()
                           │
                           ↓
                    ┌──────────────┐
                    │   Hidden     │
                    │  Collapsed   │
                    └──────────────┘
```

### 3. SplitView

**职责**：实现两栏布局的核心视图

**组成部分**：
```swift
HStack {
    if !collapsed {
        Sidebar
            .frame(width: calculatedWidth)
    }
    
    if !collapsed {
        DividerView
    }
    
    Content
        .frame(maxWidth: .infinity)
}
```

**宽度计算逻辑**：
```swift
effectiveWidth = clamp(
    proposedWidth,
    min: configuration.minSidebarWidth,
    max: min(configuration.maxSidebarWidth, totalWidth * 0.5)
)
```

### 4. DividerView

**职责**：提供可拖拽的分割线

**交互层次**：
```
┌─────────────────────────┐
│   Visual Layer (1px)    │  ← 视觉分割线
└─────────────────────────┘
┌─────────────────────────┐
│  Interaction Layer (8px)│  ← 拖拽热区
└─────────────────────────┘
┌─────────────────────────┐
│   Indicator Layer       │  ← 三个点的指示器
└─────────────────────────┘
```

**状态机**：
```
Idle ──hover──> Hovering ──drag──> Dragging ──release──> Idle
                   │                    │
                   └────────────────────┘
```

### 5. 主题系统

**层次结构**：
```
SplitViewTheme (主题定义)
    ├── Preset Themes (预设主题)
    │   ├── .system
    │   ├── .light
    │   ├── .dark
    │   ├── .ocean
    │   ├── .forest
    │   └── .sunset
    └── Custom Themes (自定义主题)

SplitViewStyle (样式系统)
    ├── DefaultSplitViewStyle
    ├── CardSplitViewStyle
    └── BorderedSplitViewStyle
```

**应用机制**：
```swift
// 使用环境值传递主题
extension EnvironmentValues {
    var splitViewTheme: SplitViewTheme
}

// 视图应用主题
.splitViewTheme(.ocean)
```

## 🔄 数据流

### 单向数据流

```
User Interaction
       ↓
   Event Handler
       ↓
   State Update (@Published)
       ↓
   SwiftUI Re-render
       ↓
   View Update
```

### 示例：拖拽分割线

```
1. User drags divider
   ↓
2. DragGesture detects translation
   ↓
3. onDrag callback invoked
   ↓
4. handleDrag() calculates new width
   ↓
5. state.setSidebarWidth(newWidth)
   ↓
6. @Published triggers view update
   ↓
7. SwiftUI re-renders with new width
```

## 🎨 渲染优化

### 1. 几何计算优化

```swift
GeometryReader { geometry in
    // 仅在必要时重新计算
    let width = effectiveWidth(in: geometry)
    
    HStack(spacing: 0) {
        Sidebar.frame(width: width)
        Divider
        Content
    }
}
```

### 2. 动画性能

```swift
withAnimation(.easeInOut(duration: 0.25)) {
    // 批量状态更新
    isSidebarCollapsed.toggle()
}
```

### 3. 避免不必要的重绘

- 使用 `@Published` 精确控制更新
- 组件化设计减少重绘范围
- 使用 `.equatable()` 优化复杂视图

## 🔐 类型安全

### 泛型视图

```swift
public struct SplitView<Sidebar: View, Content: View>: View {
    // 类型安全的内容构建
}
```

### ViewBuilder

```swift
public init(
    @ViewBuilder sidebar: () -> Sidebar,
    @ViewBuilder content: () -> Content
) {
    // 类型安全的 DSL
}
```

## 🧪 可测试性

### 状态隔离

```swift
// 状态与视图分离，便于单独测试
let state = SplitViewState(configuration: .default)
state.toggleSidebar()
XCTAssertTrue(state.isSidebarCollapsed)
```

### 配置注入

```swift
// 依赖注入使测试更容易
let mockConfig = SplitViewConfiguration(
    minSidebarWidth: 100,
    maxSidebarWidth: 200
)
let state = SplitViewState(configuration: mockConfig)
```

## 🌐 平台兼容性

### macOS vs iPadOS

```swift
#if os(macOS)
// macOS 特定代码
cursor.push()
#else
// iPadOS 特定代码
#endif
```

### 响应式设计

```swift
@Environment(\.horizontalSizeClass) var sizeClass

let config = sizeClass == .compact ? .compact : .spacious
```

## 📊 性能指标

### 目标性能

- **初始渲染**: < 16ms (60 FPS)
- **拖拽响应**: < 8ms (120 FPS on ProMotion)
- **动画流畅度**: 60 FPS
- **内存占用**: < 10MB (不含内容)

### 优化策略

1. **延迟加载**: 侧边栏内容按需渲染
2. **视图复用**: 使用 `List` 等高效容器
3. **状态防抖**: 避免频繁的小更新
4. **批量更新**: 合并多个状态变更

## 🔮 扩展性

### 添加新主题

```swift
extension SplitViewTheme {
    public static var myTheme: SplitViewTheme {
        SplitViewTheme(...)
    }
}
```

### 自定义分割线

```swift
// 将来可以支持
.splitViewDivider {
    MyCustomDivider()
}
```

### 插件系统

```swift
// 计划中的功能
.splitViewPlugin(MyPlugin())
```

## 📝 最佳实践

### 1. 状态管理

✅ **推荐**：
```swift
@StateObject private var splitState = SplitViewState()
```

❌ **避免**：
```swift
@State private var splitState = SplitViewState() // 每次重绘都会创建新实例
```

### 2. 配置复用

✅ **推荐**：
```swift
let sharedConfig = SplitViewConfiguration.spacious
let state1 = SplitViewState(configuration: sharedConfig)
let state2 = SplitViewState(configuration: sharedConfig)
```

### 3. 主题一致性

✅ **推荐**：
```swift
// 在根视图应用主题
WindowGroup {
    ContentView()
        .splitViewTheme(.ocean)
}
```

## 🚀 未来优化方向

1. **性能优化**
   - Metal 加速渲染
   - 虚拟化长列表
   - 更智能的缓存策略

2. **功能扩展**
   - 四栏布局支持
   - 自定义手势识别
   - 键盘导航增强
   - RTL 布局支持

3. **开发体验**
   - Swift Macros 简化 API
   - 实时预览增强
   - 调试工具

4. **文档完善**
   - 交互式教程
   - 视频演示
   - 最佳实践指南

---

## 📚 参考资料

- [SwiftUI 官方文档](https://developer.apple.com/documentation/swiftui)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

---

**版本**: 1.0.0  
**最后更新**: 2025-10-20  
**维护者**: 神伤

