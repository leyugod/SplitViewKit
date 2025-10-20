# SplitViewKit 快速入门

5 分钟快速上手 SplitViewKit！

## 🚀 安装

### 通过 Swift Package Manager

在 Xcode 中：

1. 选择 `File` → `Add Package Dependencies...`
2. 粘贴仓库 URL
3. 点击 `Add Package`

## 💡 第一个 SplitView

### 步骤 1: 导入框架

```swift
import SwiftUI
import SplitViewKit
```

### 步骤 2: 创建状态管理对象

```swift
struct ContentView: View {
    @StateObject private var splitState = SplitViewState()
    
    var body: some View {
        // 下一步...
    }
}
```

### 步骤 3: 使用 SplitView

```swift
var body: some View {
    SplitView(state: splitState) {
        // 侧边栏内容
        List(1..<20) { item in
            Text("Item \(item)")
        }
    } content: {
        // 主内容区域
        Text("欢迎使用 SplitViewKit!")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

### 完整代码

```swift
import SwiftUI
import SplitViewKit

struct ContentView: View {
    @StateObject private var splitState = SplitViewState()
    
    var body: some View {
        SplitView(state: splitState) {
            // 侧边栏
            VStack(alignment: .leading) {
                Text("菜单")
                    .font(.headline)
                    .padding()
                
                List(1..<20) { item in
                    Text("Item \(item)")
                }
            }
        } content: {
            // 主内容
            VStack {
                Text("欢迎使用 SplitViewKit!")
                    .font(.largeTitle)
                Text("选择左侧项目")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 800, height: 600)
}
```

## 🎨 添加主题

只需一行代码：

```swift
SplitView(state: splitState) {
    // ...
} content: {
    // ...
}
.splitViewTheme(.ocean)  // 🌊 海洋主题
```

## 🔧 自定义配置

```swift
let configuration = SplitViewConfiguration(
    minSidebarWidth: 200,
    maxSidebarWidth: 400,
    defaultSidebarWidth: 250
)

@StateObject private var splitState = SplitViewState(
    configuration: configuration
)
```

## 🎯 添加工具栏按钮

```swift
.toolbar {
    ToolbarItem(placement: .navigation) {
        SplitView.toggleSidebarButton(state: splitState)
    }
}
```

## 📱 三栏布局

```swift
@StateObject private var tripleState = TripleSplitViewState()

TripleSplitView(state: tripleState) {
    // 左侧边栏
    Text("Navigation")
} content: {
    // 主内容
    Text("Main Content")
} trailingSidebar: {
    // 右侧边栏
    Text("Inspector")
}
```

## 🎭 所有可用主题

```swift
.splitViewTheme(.system)   // 系统默认
.splitViewTheme(.light)    // 明亮
.splitViewTheme(.dark)     // 深色
.splitViewTheme(.ocean)    // 🌊 海洋
.splitViewTheme(.forest)   // 🌲 森林
.splitViewTheme(.sunset)   // 🌅 日落
```

## 🎮 状态控制

```swift
// 切换侧边栏
splitState.toggleSidebar()

// 显示/隐藏
splitState.showSidebar()
splitState.hideSidebar()

// 设置宽度
splitState.setSidebarWidth(300)

// 重置
splitState.resetToDefaultWidth()
```

## 📦 预设配置

```swift
// 默认配置
let state1 = SplitViewState(configuration: .default)

// 紧凑配置（小屏幕）
let state2 = SplitViewState(configuration: .compact)

// 宽松配置（大屏幕）
let state3 = SplitViewState(configuration: .spacious)
```

## 🎪 完整示例

### 带导航和选择的完整应用

```swift
import SwiftUI
import SplitViewKit

struct MyApp: View {
    @StateObject private var splitState = SplitViewState()
    @State private var selectedItem: Int? = 1
    
    var body: some View {
        SplitView(state: splitState) {
            sidebar
        } content: {
            mainContent
        }
        .splitViewTheme(.ocean)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                SplitView.toggleSidebarButton(state: splitState)
            }
        }
    }
    
    private var sidebar: some View {
        List(1..<20, selection: $selectedItem) { item in
            NavigationLink(value: item) {
                Label("Item \(item)", systemImage: "doc.text")
            }
        }
        .navigationTitle("Sidebar")
    }
    
    private var mainContent: some View {
        VStack {
            if let item = selectedItem {
                Text("You selected Item \(item)")
                    .font(.largeTitle)
            } else {
                Text("Select an item")
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MyApp()
        .frame(width: 900, height: 600)
}
```

## 🚦 下一步

1. **探索示例**  
   查看 `Examples/` 目录中的完整示例

2. **阅读文档**  
   - [README.md](README.md) - 项目介绍
   - [USAGE_GUIDE.md](USAGE_GUIDE.md) - 详细使用指南
   - [ARCHITECTURE.md](ARCHITECTURE.md) - 架构文档

3. **尝试不同主题**  
   实验不同的主题和配置

4. **构建你的应用**  
   开始创建你的分栏应用！

## 💡 小贴士

### ✅ 推荐做法

- 使用 `@StateObject` 管理状态
- 在根视图应用主题
- 使用预设配置快速开始

### ⚠️ 常见错误

- ❌ 不要在 body 中创建新的 state
- ❌ 不要忘记 `@StateObject` 修饰符
- ❌ 不要在 iPhone 上使用（设计为大屏设备）

## 🆘 需要帮助？

- 📖 查看 [使用指南](USAGE_GUIDE.md)
- 🏗 查看 [架构文档](ARCHITECTURE.md)
- 💬 提交 Issue
- 📧 联系维护者

## 🎉 完成！

恭喜！你已经学会了 SplitViewKit 的基础用法。

现在开始构建你的应用吧！ 🚀

---

**Happy Coding!** 💻✨

