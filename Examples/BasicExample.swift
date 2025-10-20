//
//  BasicExample.swift
//  SplitViewKit Examples
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI
import SplitViewKit

/// 基础两栏布局示例
struct BasicExample: View {
    @StateObject private var splitState = SplitViewState()
    @State private var selectedItem: Int? = nil
    
    var body: some View {
        SplitView(state: splitState) {
            // 侧边栏
            sidebar
        } content: {
            // 主内容
            mainContent
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                SplitView.toggleSidebarButton(state: splitState)
            }
        }
    }
    
    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 侧边栏标题
            HStack {
                Text("项目列表")
                    .font(.headline)
                Spacer()
                Button(action: {
                    splitState.resetToDefaultWidth()
                }) {
                    Image(systemName: "arrow.left.arrow.right")
                        .imageScale(.small)
                }
                .buttonStyle(.plain)
                .help("重置宽度")
            }
            .padding()
            
            Divider()
            
            // 项目列表
            List(selection: $selectedItem) {
                Section("类别 A") {
                    ForEach(1..<11) { index in
                        NavigationLink(value: index) {
                            Label("项目 \(index)", systemImage: "doc.text")
                        }
                    }
                }
                
                Section("类别 B") {
                    ForEach(11..<21) { index in
                        NavigationLink(value: index) {
                            Label("项目 \(index)", systemImage: "folder")
                        }
                    }
                }
            }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 20) {
            if let selectedItem = selectedItem {
                // 显示选中的项目详情
                VStack(spacing: 12) {
                    Image(systemName: selectedItem < 11 ? "doc.text.fill" : "folder.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)
                    
                    Text("项目 \(selectedItem)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("这是项目 \(selectedItem) 的详细内容")
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .padding(.vertical)
                    
                    // 示例内容
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(label: "创建时间", value: "2025-10-20")
                        InfoRow(label: "修改时间", value: "2025-10-20")
                        InfoRow(label: "大小", value: "1.2 MB")
                        InfoRow(label: "类型", value: selectedItem < 11 ? "文档" : "文件夹")
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
            } else {
                // 空状态
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("未选择项目")
                        .font(.title)
                        .foregroundColor(.secondary)
                    
                    Text("请从左侧列表中选择一个项目")
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Helper Views

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview

#Preview("基础示例") {
    BasicExample()
        .frame(width: 900, height: 600)
}

#Preview("基础示例 - 深色主题") {
    BasicExample()
        .splitViewTheme(.dark)
        .frame(width: 900, height: 600)
        .preferredColorScheme(.dark)
}

#Preview("基础示例 - 海洋主题") {
    BasicExample()
        .splitViewTheme(.ocean)
        .frame(width: 900, height: 600)
}

