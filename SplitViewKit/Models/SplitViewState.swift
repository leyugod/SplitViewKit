//
//  SplitViewState.swift
//  SplitViewKit
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI
import Combine

/// SplitView 的状态管理
public class SplitViewState: ObservableObject {
    /// 当前侧边栏宽度
    @Published public var sidebarWidth: CGFloat
    
    /// 侧边栏是否折叠
    @Published public var isSidebarCollapsed: Bool
    
    /// 侧边栏是否可见
    @Published public var isSidebarVisible: Bool
    
    /// 配置
    public let configuration: SplitViewConfiguration
    
    /// 初始化状态
    public init(configuration: SplitViewConfiguration = .default) {
        self.configuration = configuration
        self.sidebarWidth = configuration.defaultSidebarWidth
        self.isSidebarCollapsed = false
        self.isSidebarVisible = true
    }
    
    /// 切换侧边栏折叠状态
    public func toggleSidebar() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isSidebarCollapsed.toggle()
        }
    }
    
    /// 显示侧边栏
    public func showSidebar() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isSidebarCollapsed = false
            isSidebarVisible = true
        }
    }
    
    /// 隐藏侧边栏
    public func hideSidebar() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isSidebarCollapsed = true
            isSidebarVisible = false
        }
    }
    
    /// 设置侧边栏宽度
    public func setSidebarWidth(_ width: CGFloat) {
        let clampedWidth = min(max(width, configuration.minSidebarWidth), configuration.maxSidebarWidth)
        sidebarWidth = clampedWidth
    }
    
    /// 重置为默认宽度
    public func resetToDefaultWidth() {
        withAnimation(.easeInOut(duration: 0.25)) {
            sidebarWidth = configuration.defaultSidebarWidth
        }
    }
}

/// 三栏视图的状态管理
public class TripleSplitViewState: ObservableObject {
    /// 左侧边栏宽度
    @Published public var leadingSidebarWidth: CGFloat
    
    /// 右侧边栏宽度
    @Published public var trailingSidebarWidth: CGFloat
    
    /// 左侧边栏是否折叠
    @Published public var isLeadingSidebarCollapsed: Bool
    
    /// 右侧边栏是否折叠
    @Published public var isTrailingSidebarCollapsed: Bool
    
    /// 配置
    public let configuration: SplitViewConfiguration
    
    public init(configuration: SplitViewConfiguration = .default) {
        self.configuration = configuration
        self.leadingSidebarWidth = configuration.defaultSidebarWidth
        self.trailingSidebarWidth = configuration.defaultSidebarWidth
        self.isLeadingSidebarCollapsed = false
        self.isTrailingSidebarCollapsed = false
    }
    
    /// 切换左侧边栏
    public func toggleLeadingSidebar() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isLeadingSidebarCollapsed.toggle()
        }
    }
    
    /// 切换右侧边栏
    public func toggleTrailingSidebar() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isTrailingSidebarCollapsed.toggle()
        }
    }
    
    /// 设置左侧边栏宽度
    public func setLeadingSidebarWidth(_ width: CGFloat) {
        let clampedWidth = min(max(width, configuration.minSidebarWidth), configuration.maxSidebarWidth)
        leadingSidebarWidth = clampedWidth
    }
    
    /// 设置右侧边栏宽度
    public func setTrailingSidebarWidth(_ width: CGFloat) {
        let clampedWidth = min(max(width, configuration.minSidebarWidth), configuration.maxSidebarWidth)
        trailingSidebarWidth = clampedWidth
    }
}

