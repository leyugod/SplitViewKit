//
//  SplitView.swift
//  SplitViewKit
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI

/// 通用的两栏分割视图
public struct SplitView<Sidebar: View, Content: View>: View {
    @ObservedObject private var state: SplitViewState
    
    private let sidebar: Sidebar
    private let content: Content
    
    @SwiftUI.State private var dragOffset: CGFloat = 0
    
    /// 初始化 SplitView
    /// - Parameters:
    ///   - state: 分割视图状态管理对象
    ///   - sidebar: 侧边栏内容
    ///   - content: 主内容区域
    public init(
        state: SplitViewState,
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder content: () -> Content
    ) {
        self.state = state
        self.sidebar = sidebar()
        self.content = content()
    }
    
    /// 便捷初始化（使用默认配置）
    public init(
        configuration: SplitViewConfiguration = .default,
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder content: () -> Content
    ) {
        self.state = SplitViewState(configuration: configuration)
        self.sidebar = sidebar()
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // 侧边栏
                if !state.isSidebarCollapsed {
                    sidebarView
                        .frame(width: effectiveSidebarWidth(in: geometry))
                        .transition(.move(edge: .leading))
                }
                
                // 分割线
                if !state.isSidebarCollapsed {
                    DividerView(configuration: state.configuration) { translation in
                        handleDrag(translation: translation, in: geometry)
                    }
                }
                
                // 主内容区
                contentView
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    // MARK: - Private Views
    
    private var sidebarView: some View {
        sidebar
            .background(
                (state.configuration.sidebarBackgroundColor ?? Color(nsColor: .controlBackgroundColor))
                    .ignoresSafeArea()
            )
    }
    
    private var contentView: some View {
        content
            .background(
                (state.configuration.contentBackgroundColor ?? Color(nsColor: .textBackgroundColor))
                    .ignoresSafeArea()
            )
    }
    
    // MARK: - Private Methods
    
    private func effectiveSidebarWidth(in geometry: GeometryProxy) -> CGFloat {
        let proposedWidth = state.sidebarWidth + dragOffset
        let minWidth = state.configuration.minSidebarWidth
        let maxWidth = min(state.configuration.maxSidebarWidth, geometry.size.width * 0.5)
        
        return min(max(proposedWidth, minWidth), maxWidth)
    }
    
    private func handleDrag(translation: CGFloat, in geometry: GeometryProxy) {
        dragOffset = translation
        
        // 实时更新宽度
        let newWidth = state.sidebarWidth + translation
        let minWidth = state.configuration.minSidebarWidth
        let maxWidth = min(state.configuration.maxSidebarWidth, geometry.size.width * 0.5)
        
        if newWidth >= minWidth && newWidth <= maxWidth {
            state.setSidebarWidth(newWidth)
            dragOffset = 0
        }
    }
}

// MARK: - View Modifiers

extension SplitView {
    /// 绑定状态管理对象
    public func splitViewState(_ state: SplitViewState) -> some View {
        var view = self
        view.state = state
        return view
    }
}

// MARK: - Public Helper Methods

extension SplitView {
    /// 提供切换侧边栏的按钮
    public static func toggleSidebarButton(state: SplitViewState) -> some View {
        Button(action: {
            state.toggleSidebar()
        }) {
            Image(systemName: "sidebar.leading")
                .imageScale(.large)
        }
        .help("切换侧边栏")
    }
}

// MARK: - Platform Color Support

#if os(macOS)
extension Color {
    init(nsColor: NSColor) {
        self.init(nsColor)
    }
}
#endif

// MARK: - Preview

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView(configuration: .default) {
            // 侧边栏
            VStack(alignment: .leading, spacing: 8) {
                Text("侧边栏")
                    .font(.headline)
                    .padding()
                
                List(1..<20) { index in
                    Text("项目 \(index)")
                }
            }
        } content: {
            // 主内容
            VStack {
                Text("主内容区域")
                    .font(.largeTitle)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 800, height: 600)
    }
}

