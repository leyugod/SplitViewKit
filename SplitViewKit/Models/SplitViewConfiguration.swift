//
//  SplitViewConfiguration.swift
//  SplitViewKit
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI

/// SplitView 的配置选项
public struct SplitViewConfiguration {
    /// 最小侧边栏宽度
    public var minSidebarWidth: CGFloat
    
    /// 最大侧边栏宽度
    public var maxSidebarWidth: CGFloat
    
    /// 默认侧边栏宽度
    public var defaultSidebarWidth: CGFloat
    
    /// 分割线宽度
    public var dividerWidth: CGFloat
    
    /// 是否启用拖拽调整
    public var isDraggable: Bool
    
    /// 是否显示分割线指示器
    public var showDividerIndicator: Bool
    
    /// 侧边栏是否可折叠
    public var isCollapsible: Bool
    
    /// 分割线颜色（nil 使用系统默认）
    public var dividerColor: Color?
    
    /// 分割线悬停颜色
    public var dividerHoverColor: Color?
    
    /// 侧边栏背景色（nil 使用系统默认）
    public var sidebarBackgroundColor: Color?
    
    /// 主内容区背景色（nil 使用系统默认）
    public var contentBackgroundColor: Color?
    
    /// 默认配置
    public static var `default`: SplitViewConfiguration {
        SplitViewConfiguration(
            minSidebarWidth: 150,
            maxSidebarWidth: 400,
            defaultSidebarWidth: 250,
            dividerWidth: 1,
            isDraggable: true,
            showDividerIndicator: true,
            isCollapsible: true,
            dividerColor: nil,
            dividerHoverColor: nil,
            sidebarBackgroundColor: nil,
            contentBackgroundColor: nil
        )
    }
    
    /// 紧凑配置（适用于较小屏幕）
    public static var compact: SplitViewConfiguration {
        var config = SplitViewConfiguration.default
        config.minSidebarWidth = 100
        config.maxSidebarWidth = 300
        config.defaultSidebarWidth = 200
        return config
    }
    
    /// 宽松配置（适用于大屏幕）
    public static var spacious: SplitViewConfiguration {
        var config = SplitViewConfiguration.default
        config.minSidebarWidth = 200
        config.maxSidebarWidth = 500
        config.defaultSidebarWidth = 300
        return config
    }
    
    public init(
        minSidebarWidth: CGFloat = 150,
        maxSidebarWidth: CGFloat = 400,
        defaultSidebarWidth: CGFloat = 250,
        dividerWidth: CGFloat = 1,
        isDraggable: Bool = true,
        showDividerIndicator: Bool = true,
        isCollapsible: Bool = true,
        dividerColor: Color? = nil,
        dividerHoverColor: Color? = nil,
        sidebarBackgroundColor: Color? = nil,
        contentBackgroundColor: Color? = nil
    ) {
        self.minSidebarWidth = minSidebarWidth
        self.maxSidebarWidth = maxSidebarWidth
        self.defaultSidebarWidth = defaultSidebarWidth
        self.dividerWidth = dividerWidth
        self.isDraggable = isDraggable
        self.showDividerIndicator = showDividerIndicator
        self.isCollapsible = isCollapsible
        self.dividerColor = dividerColor
        self.dividerHoverColor = dividerHoverColor
        self.sidebarBackgroundColor = sidebarBackgroundColor
        self.contentBackgroundColor = contentBackgroundColor
    }
}

