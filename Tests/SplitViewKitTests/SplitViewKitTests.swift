//
//  SplitViewKitTests.swift
//  SplitViewKit
//
//  Created by 神伤 on 2025/10/20.
//

import XCTest
@testable import SplitViewKit

final class SplitViewKitTests: XCTestCase {
    
    func testConfiguration() {
        let config = SplitViewConfiguration.default
        
        XCTAssertEqual(config.minSidebarWidth, 150)
        XCTAssertEqual(config.maxSidebarWidth, 400)
        XCTAssertEqual(config.defaultSidebarWidth, 250)
        XCTAssertTrue(config.isDraggable)
        XCTAssertTrue(config.isCollapsible)
    }
    
    func testSplitViewState() {
        let state = SplitViewState()
        
        XCTAssertEqual(state.sidebarWidth, 250)
        XCTAssertFalse(state.isSidebarCollapsed)
        XCTAssertTrue(state.isSidebarVisible)
        
        // Test toggle
        state.toggleSidebar()
        XCTAssertTrue(state.isSidebarCollapsed)
        
        // Test show
        state.showSidebar()
        XCTAssertFalse(state.isSidebarCollapsed)
        XCTAssertTrue(state.isSidebarVisible)
        
        // Test hide
        state.hideSidebar()
        XCTAssertTrue(state.isSidebarCollapsed)
        XCTAssertFalse(state.isSidebarVisible)
    }
    
    func testSidebarWidthSetting() {
        let state = SplitViewState()
        
        // Test valid width
        state.setSidebarWidth(300)
        XCTAssertEqual(state.sidebarWidth, 300)
        
        // Test width below minimum
        state.setSidebarWidth(100)
        XCTAssertEqual(state.sidebarWidth, 150)
        
        // Test width above maximum
        state.setSidebarWidth(500)
        XCTAssertEqual(state.sidebarWidth, 400)
    }
    
    func testResetToDefaultWidth() {
        let state = SplitViewState()
        
        state.setSidebarWidth(300)
        XCTAssertEqual(state.sidebarWidth, 300)
        
        state.resetToDefaultWidth()
        XCTAssertEqual(state.sidebarWidth, 250)
    }
    
    func testCompactConfiguration() {
        let config = SplitViewConfiguration.compact
        
        XCTAssertEqual(config.minSidebarWidth, 100)
        XCTAssertEqual(config.maxSidebarWidth, 300)
        XCTAssertEqual(config.defaultSidebarWidth, 200)
    }
    
    func testSpaciousConfiguration() {
        let config = SplitViewConfiguration.spacious
        
        XCTAssertEqual(config.minSidebarWidth, 200)
        XCTAssertEqual(config.maxSidebarWidth, 500)
        XCTAssertEqual(config.defaultSidebarWidth, 300)
    }
}

