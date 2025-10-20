//
//  SplitViewTheme.swift
//  SplitViewKit
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI

/// 主题定义
public struct SplitViewTheme {
    /// 侧边栏背景色
    public var sidebarBackground: Color
    
    /// 主内容区背景色
    public var contentBackground: Color
    
    /// 分割线颜色
    public var dividerColor: Color
    
    /// 分割线悬停颜色
    public var dividerHoverColor: Color
    
    /// 侧边栏文字颜色
    public var sidebarTextColor: Color
    
    /// 主内容文字颜色
    public var contentTextColor: Color
    
    /// 高亮颜色
    public var accentColor: Color
    
    public init(
        sidebarBackground: Color,
        contentBackground: Color,
        dividerColor: Color,
        dividerHoverColor: Color,
        sidebarTextColor: Color,
        contentTextColor: Color,
        accentColor: Color
    ) {
        self.sidebarBackground = sidebarBackground
        self.contentBackground = contentBackground
        self.dividerColor = dividerColor
        self.dividerHoverColor = dividerHoverColor
        self.sidebarTextColor = sidebarTextColor
        self.contentTextColor = contentTextColor
        self.accentColor = accentColor
    }
}

// MARK: - 预设主题

extension SplitViewTheme {
    /// 系统默认主题（自适应浅色/深色模式）
    public static var system: SplitViewTheme {
        SplitViewTheme(
            sidebarBackground: Color(nsColor: .controlBackgroundColor),
            contentBackground: Color(nsColor: .textBackgroundColor),
            dividerColor: Color(nsColor: .separatorColor),
            dividerHoverColor: Color.accentColor.opacity(0.5),
            sidebarTextColor: Color.primary,
            contentTextColor: Color.primary,
            accentColor: Color.accentColor
        )
    }
    
    /// 明亮主题
    public static var light: SplitViewTheme {
        SplitViewTheme(
            sidebarBackground: Color(red: 0.96, green: 0.96, blue: 0.96),
            contentBackground: Color.white,
            dividerColor: Color(red: 0.8, green: 0.8, blue: 0.8),
            dividerHoverColor: Color.blue.opacity(0.5),
            sidebarTextColor: Color.black.opacity(0.87),
            contentTextColor: Color.black.opacity(0.87),
            accentColor: Color.blue
        )
    }
    
    /// 深色主题
    public static var dark: SplitViewTheme {
        SplitViewTheme(
            sidebarBackground: Color(red: 0.15, green: 0.15, blue: 0.15),
            contentBackground: Color(red: 0.11, green: 0.11, blue: 0.11),
            dividerColor: Color(red: 0.25, green: 0.25, blue: 0.25),
            dividerHoverColor: Color.blue.opacity(0.7),
            sidebarTextColor: Color.white.opacity(0.87),
            contentTextColor: Color.white.opacity(0.87),
            accentColor: Color.blue
        )
    }
    
    /// 海洋主题
    public static var ocean: SplitViewTheme {
        SplitViewTheme(
            sidebarBackground: Color(red: 0.05, green: 0.2, blue: 0.3),
            contentBackground: Color(red: 0.08, green: 0.25, blue: 0.35),
            dividerColor: Color(red: 0.1, green: 0.3, blue: 0.4),
            dividerHoverColor: Color.cyan.opacity(0.7),
            sidebarTextColor: Color.white.opacity(0.9),
            contentTextColor: Color.white.opacity(0.9),
            accentColor: Color.cyan
        )
    }
    
    /// 森林主题
    public static var forest: SplitViewTheme {
        SplitViewTheme(
            sidebarBackground: Color(red: 0.13, green: 0.2, blue: 0.13),
            contentBackground: Color(red: 0.16, green: 0.24, blue: 0.16),
            dividerColor: Color(red: 0.2, green: 0.3, blue: 0.2),
            dividerHoverColor: Color.green.opacity(0.7),
            sidebarTextColor: Color.white.opacity(0.9),
            contentTextColor: Color.white.opacity(0.9),
            accentColor: Color.green
        )
    }
    
    /// 日落主题
    public static var sunset: SplitViewTheme {
        SplitViewTheme(
            sidebarBackground: Color(red: 0.3, green: 0.15, blue: 0.2),
            contentBackground: Color(red: 0.25, green: 0.12, blue: 0.17),
            dividerColor: Color(red: 0.4, green: 0.2, blue: 0.25),
            dividerHoverColor: Color.pink.opacity(0.7),
            sidebarTextColor: Color.white.opacity(0.9),
            contentTextColor: Color.white.opacity(0.9),
            accentColor: Color.pink
        )
    }
}

// MARK: - Theme Environment Key

struct SplitViewThemeKey: EnvironmentKey {
    static let defaultValue: SplitViewTheme = .system
}

extension EnvironmentValues {
    public var splitViewTheme: SplitViewTheme {
        get { self[SplitViewThemeKey.self] }
        set { self[SplitViewThemeKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    /// 设置 SplitView 主题
    public func splitViewTheme(_ theme: SplitViewTheme) -> some View {
        environment(\.splitViewTheme, theme)
    }
}

