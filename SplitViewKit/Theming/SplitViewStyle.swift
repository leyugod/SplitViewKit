//
//  SplitViewStyle.swift
//  SplitViewKit
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI

/// SplitView 样式协议
public protocol SplitViewStyle {
    associatedtype Body: View
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> Body
    
    typealias Configuration = SplitViewStyleConfiguration
}

/// SplitView 样式配置
public struct SplitViewStyleConfiguration {
    /// 侧边栏内容
    public let sidebar: AnyView
    
    /// 主内容
    public let content: AnyView
    
    /// 分割线
    public let divider: AnyView
    
    /// 状态
    public let state: SplitViewState
}

// MARK: - 默认样式

/// 默认样式
public struct DefaultSplitViewStyle: SplitViewStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.sidebar
            configuration.divider
            configuration.content
        }
    }
}

/// 圆角卡片样式
public struct CardSplitViewStyle: SplitViewStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            configuration.sidebar
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
            
            configuration.content
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
        .padding(12)
    }
}

/// 边框样式
public struct BorderedSplitViewStyle: SplitViewStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.sidebar
                .overlay(
                    Rectangle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
            
            configuration.divider
            
            configuration.content
                .overlay(
                    Rectangle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - Style Environment Key

struct SplitViewStyleKey: EnvironmentKey {
    static let defaultValue: AnySplitViewStyle = AnySplitViewStyle(DefaultSplitViewStyle())
}

extension EnvironmentValues {
    var splitViewStyle: AnySplitViewStyle {
        get { self[SplitViewStyleKey.self] }
        set { self[SplitViewStyleKey.self] = newValue }
    }
}

// MARK: - Type Erasure

public struct AnySplitViewStyle: SplitViewStyle {
    private let _makeBody: (Configuration) -> AnyView
    
    init<S: SplitViewStyle>(_ style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

// MARK: - View Extension

extension View {
    /// 应用 SplitView 样式
    public func splitViewStyle<S: SplitViewStyle>(_ style: S) -> some View {
        environment(\.splitViewStyle, AnySplitViewStyle(style))
    }
}

