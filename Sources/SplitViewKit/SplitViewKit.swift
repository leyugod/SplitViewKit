//
//  SplitViewKit.swift
//  SplitViewKit
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI

/// SplitViewKit - 通用的分栏布局框架
///
/// 一个可复用的左右分栏框架，用于 macOS 和 iPadOS 的 SwiftUI 应用。
/// 提供灵活的两栏和三栏布局，支持拖拽调整、主题定制和动态状态管理。
///
/// ## 功能特性
///
/// - ✅ 两栏和三栏布局支持
/// - ✅ 可拖拽调整分割线
/// - ✅ 动态折叠/展开侧边栏
/// - ✅ 深色/浅色模式自适应
/// - ✅ 丰富的主题系统
/// - ✅ 灵活的样式定制
/// - ✅ 完整的状态管理
///
/// ## 使用示例
///
/// ### 基础两栏布局
///
/// ```swift
/// import SplitViewKit
///
/// struct ContentView: View {
///     @StateObject private var splitState = SplitViewState()
///
///     var body: some View {
///         SplitView(state: splitState) {
///             // 侧边栏内容
///             List(1..<20) { index in
///                 Text("Item \(index)")
///             }
///         } content: {
///             // 主内容区域
///             Text("Main Content")
///                 .frame(maxWidth: .infinity, maxHeight: .infinity)
///         }
///     }
/// }
/// ```
///
/// ### 三栏布局
///
/// ```swift
/// struct ContentView: View {
///     @StateObject private var splitState = TripleSplitViewState()
///
///     var body: some View {
///         TripleSplitView(state: splitState) {
///             // 左侧边栏
///             Text("Leading Sidebar")
///         } content: {
///             // 中间内容
///             Text("Main Content")
///         } trailingSidebar: {
///             // 右侧边栏
///             Text("Trailing Sidebar")
///         }
///     }
/// }
/// ```
///
/// ### 应用主题
///
/// ```swift
/// SplitView(state: splitState) {
///     // ...
/// } content: {
///     // ...
/// }
/// .splitViewTheme(.ocean) // 应用海洋主题
/// ```
///
public struct SplitViewKit {
    /// 框架版本
    public static let version = "1.0.0"
    
    /// 框架名称
    public static let name = "SplitViewKit"
    
    private init() {}
}

// MARK: - 公共导出

// 核心模型
public typealias Configuration = SplitViewConfiguration
public typealias State = SplitViewState
public typealias TripleState = TripleSplitViewState

// 主题
public typealias Theme = SplitViewTheme

// 视图
// SplitView 和 TripleSplitView 已在各自文件中声明为 public

