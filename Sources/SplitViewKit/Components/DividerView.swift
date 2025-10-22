//
//  DividerView.swift
//  SplitViewKit
//
//  Created by 神伤 on 2025/10/20.
//

import SwiftUI

/// 可拖拽的分割线视图
public struct DividerView: View {
    let configuration: SplitViewConfiguration
    let onDrag: (CGFloat) -> Void
    
    @SwiftUI.State private var isHovering = false
    @SwiftUI.State private var isDragging = false
    
    public var body: some View {
        ZStack {
            // 分割线本体
            Rectangle()
                .fill(dividerColor)
                .frame(width: configuration.dividerWidth)
            
            // 拖拽热区（比分割线宽，便于操作）
            if configuration.isDraggable {
                Color.clear
                    .frame(width: 8)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                isDragging = true
                                onDrag(value.translation.width)
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
                    .onHover { hovering in
                        isHovering = hovering
                    }
                    #if os(macOS)
                    .cursor(isHovering || isDragging ? NSCursor.resizeLeftRight : NSCursor.arrow)
                    #endif
            }
            
            // 分割线指示器（三个小圆点）
            if configuration.showDividerIndicator {
                VStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { _ in
                        Circle()
                            .fill(indicatorColor)
                            .frame(width: 3, height: 3)
                    }
                }
                .opacity(isHovering || isDragging ? 1 : 0.3)
            }
        }
    }
    
    private var dividerColor: Color {
        if isDragging, let hoverColor = configuration.dividerHoverColor {
            return hoverColor
        } else if isHovering, let hoverColor = configuration.dividerHoverColor {
            return hoverColor
        } else if let color = configuration.dividerColor {
            return color
        } else {
            return Color(nsColor: .separatorColor)
        }
    }
    
    private var indicatorColor: Color {
        if isHovering || isDragging {
            return Color.primary.opacity(0.6)
        } else {
            return Color.secondary.opacity(0.4)
        }
    }
}

// MARK: - Cursor Modifier
extension View {
    /// 设置鼠标光标样式（macOS）
    @ViewBuilder
    func cursor(_ cursor: NSCursor) -> some View {
        #if os(macOS)
        self.onContinuousHover { phase in
            switch phase {
            case .active:
                cursor.push()
            case .ended:
                NSCursor.pop()
            }
        }
        #else
        self
        #endif
    }
}


