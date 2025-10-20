//
//  TripleSplitView.swift
//  SplitViewKit
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI

/// 三栏分割视图（左侧边栏 + 中间内容 + 右侧边栏）
public struct TripleSplitView<LeadingSidebar: View, Content: View, TrailingSidebar: View>: View {
    @ObservedObject private var state: TripleSplitViewState
    
    private let leadingSidebar: LeadingSidebar
    private let content: Content
    private let trailingSidebar: TrailingSidebar
    
    @State private var leadingDragOffset: CGFloat = 0
    @State private var trailingDragOffset: CGFloat = 0
    
    /// 初始化 TripleSplitView
    /// - Parameters:
    ///   - state: 三栏视图状态管理对象
    ///   - leadingSidebar: 左侧边栏内容
    ///   - content: 中间主内容区域
    ///   - trailingSidebar: 右侧边栏内容
    public init(
        state: TripleSplitViewState,
        @ViewBuilder leadingSidebar: () -> LeadingSidebar,
        @ViewBuilder content: () -> Content,
        @ViewBuilder trailingSidebar: () -> TrailingSidebar
    ) {
        self.state = state
        self.leadingSidebar = leadingSidebar()
        self.content = content()
        self.trailingSidebar = trailingSidebar()
    }
    
    /// 便捷初始化（使用默认配置）
    public init(
        configuration: SplitViewConfiguration = .default,
        @ViewBuilder leadingSidebar: () -> LeadingSidebar,
        @ViewBuilder content: () -> Content,
        @ViewBuilder trailingSidebar: () -> TrailingSidebar
    ) {
        self.state = TripleSplitViewState(configuration: configuration)
        self.leadingSidebar = leadingSidebar()
        self.content = content()
        self.trailingSidebar = trailingSidebar()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // 左侧边栏
                if !state.isLeadingSidebarCollapsed {
                    leadingSidebarView
                        .frame(width: effectiveLeadingSidebarWidth(in: geometry))
                        .transition(.move(edge: .leading))
                }
                
                // 左分割线
                if !state.isLeadingSidebarCollapsed {
                    DividerView(configuration: state.configuration) { translation in
                        handleLeadingDrag(translation: translation, in: geometry)
                    }
                }
                
                // 中间主内容区
                contentView
                    .frame(maxWidth: .infinity)
                
                // 右分割线
                if !state.isTrailingSidebarCollapsed {
                    DividerView(configuration: state.configuration) { translation in
                        handleTrailingDrag(translation: translation, in: geometry)
                    }
                }
                
                // 右侧边栏
                if !state.isTrailingSidebarCollapsed {
                    trailingSidebarView
                        .frame(width: effectiveTrailingSidebarWidth(in: geometry))
                        .transition(.move(edge: .trailing))
                }
            }
        }
    }
    
    // MARK: - Private Views
    
    private var leadingSidebarView: some View {
        leadingSidebar
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
    
    private var trailingSidebarView: some View {
        trailingSidebar
            .background(
                (state.configuration.sidebarBackgroundColor ?? Color(nsColor: .controlBackgroundColor))
                    .ignoresSafeArea()
            )
    }
    
    // MARK: - Private Methods
    
    private func effectiveLeadingSidebarWidth(in geometry: GeometryProxy) -> CGFloat {
        let proposedWidth = state.leadingSidebarWidth + leadingDragOffset
        let minWidth = state.configuration.minSidebarWidth
        let maxWidth = min(state.configuration.maxSidebarWidth, geometry.size.width * 0.4)
        
        return min(max(proposedWidth, minWidth), maxWidth)
    }
    
    private func effectiveTrailingSidebarWidth(in geometry: GeometryProxy) -> CGFloat {
        let proposedWidth = state.trailingSidebarWidth - trailingDragOffset
        let minWidth = state.configuration.minSidebarWidth
        let maxWidth = min(state.configuration.maxSidebarWidth, geometry.size.width * 0.4)
        
        return min(max(proposedWidth, minWidth), maxWidth)
    }
    
    private func handleLeadingDrag(translation: CGFloat, in geometry: GeometryProxy) {
        leadingDragOffset = translation
        
        let newWidth = state.leadingSidebarWidth + translation
        let minWidth = state.configuration.minSidebarWidth
        let maxWidth = min(state.configuration.maxSidebarWidth, geometry.size.width * 0.4)
        
        if newWidth >= minWidth && newWidth <= maxWidth {
            state.setLeadingSidebarWidth(newWidth)
            leadingDragOffset = 0
        }
    }
    
    private func handleTrailingDrag(translation: CGFloat, in geometry: GeometryProxy) {
        trailingDragOffset = translation
        
        let newWidth = state.trailingSidebarWidth - translation
        let minWidth = state.configuration.minSidebarWidth
        let maxWidth = min(state.configuration.maxSidebarWidth, geometry.size.width * 0.4)
        
        if newWidth >= minWidth && newWidth <= maxWidth {
            state.setTrailingSidebarWidth(newWidth)
            trailingDragOffset = 0
        }
    }
}

// MARK: - Public Helper Methods

extension TripleSplitView {
    /// 提供切换左侧边栏的按钮
    public static func toggleLeadingSidebarButton(state: TripleSplitViewState) -> some View {
        Button(action: {
            state.toggleLeadingSidebar()
        }) {
            Image(systemName: "sidebar.leading")
                .imageScale(.large)
        }
        .help("切换左侧边栏")
    }
    
    /// 提供切换右侧边栏的按钮
    public static func toggleTrailingSidebarButton(state: TripleSplitViewState) -> some View {
        Button(action: {
            state.toggleTrailingSidebar()
        }) {
            Image(systemName: "sidebar.trailing")
                .imageScale(.large)
        }
        .help("切换右侧边栏")
    }
}

// MARK: - Preview

struct TripleSplitView_Previews: PreviewProvider {
    static var previews: some View {
        TripleSplitView(configuration: .default) {
            // 左侧边栏
            VStack(alignment: .leading) {
                Text("左侧边栏")
                    .font(.headline)
                    .padding()
                
                List(1..<20) { index in
                    Text("左侧项目 \(index)")
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
        } trailingSidebar: {
            // 右侧边栏
            VStack(alignment: .leading) {
                Text("右侧边栏")
                    .font(.headline)
                    .padding()
                
                List(1..<20) { index in
                    Text("右侧项目 \(index)")
                }
            }
        }
        .frame(width: 1200, height: 600)
    }
}

