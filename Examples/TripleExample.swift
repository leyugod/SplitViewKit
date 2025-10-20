//
//  TripleExample.swift
//  SplitViewKit Examples
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI
import SplitViewKit

/// 三栏布局示例
struct TripleExample: View {
    @StateObject private var tripleState = TripleSplitViewState()
    @State private var selectedCategory: String = "文档"
    @State private var selectedItem: Int? = nil
    
    let categories = ["文档", "图片", "音乐", "视频", "下载"]
    
    var body: some View {
        TripleSplitView(state: tripleState) {
            // 左侧边栏 - 导航
            leadingSidebar
        } content: {
            // 主内容区域
            mainContent
        } trailingSidebar: {
            // 右侧边栏 - 检查器
            trailingSidebar
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                TripleSplitView.toggleLeadingSidebarButton(state: tripleState)
            }
            
            ToolbarItemGroup(placement: .automatic) {
                TripleSplitView.toggleTrailingSidebarButton(state: tripleState)
            }
        }
    }
    
    // MARK: - Leading Sidebar
    
    private var leadingSidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("导航")
                .font(.headline)
                .padding()
            
            Divider()
            
            List(categories, id: \.self, selection: $selectedCategory) { category in
                NavigationLink(value: category) {
                    Label(category, systemImage: iconForCategory(category))
                }
            }
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            // 工具栏
            HStack {
                Text(selectedCategory)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                    .help("添加项目")
                    
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .help("分享")
                }
            }
            .padding()
            
            Divider()
            
            // 内容网格
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 120), spacing: 16)
                ], spacing: 16) {
                    ForEach(1..<25) { index in
                        ItemCard(
                            index: index,
                            isSelected: selectedItem == index
                        ) {
                            selectedItem = index
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Trailing Sidebar
    
    private var trailingSidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("检查器")
                .font(.headline)
                .padding()
            
            Divider()
            
            if let selectedItem = selectedItem {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // 预览
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentColor.opacity(0.3))
                            .frame(height: 150)
                            .overlay(
                                Image(systemName: iconForCategory(selectedCategory))
                                    .font(.system(size: 50))
                                    .foregroundColor(.accentColor)
                            )
                        
                        // 信息
                        VStack(alignment: .leading, spacing: 12) {
                            Text("项目 \(selectedItem)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Divider()
                            
                            InspectorRow(label: "类型", value: selectedCategory)
                            InspectorRow(label: "大小", value: "2.4 MB")
                            InspectorRow(label: "创建日期", value: "2025-10-20")
                            InspectorRow(label: "修改日期", value: "2025-10-20")
                            
                            Divider()
                            
                            Text("标签")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                TagView(text: "重要", color: .red)
                                TagView(text: "工作", color: .blue)
                            }
                            
                            Divider()
                            
                            Text("备注")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            TextEditor(text: .constant("这是一个示例备注..."))
                                .frame(height: 100)
                                .cornerRadius(4)
                        }
                    }
                    .padding()
                }
            } else {
                VStack {
                    Spacer()
                    Text("未选择项目")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "文档": return "doc.text"
        case "图片": return "photo"
        case "音乐": return "music.note"
        case "视频": return "video"
        case "下载": return "arrow.down.circle"
        default: return "folder"
        }
    }
}

// MARK: - Helper Views

struct ItemCard: View {
    let index: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.2))
                .frame(height: 100)
                .overlay(
                    Text("\(index)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                )
            
            Text("项目 \(index)")
                .font(.caption)
                .lineLimit(1)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}

struct InspectorRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
        }
    }
}

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}

// MARK: - Preview

#Preview("三栏示例") {
    TripleExample()
        .frame(width: 1200, height: 700)
}

#Preview("三栏示例 - 森林主题") {
    TripleExample()
        .splitViewTheme(.forest)
        .frame(width: 1200, height: 700)
}

