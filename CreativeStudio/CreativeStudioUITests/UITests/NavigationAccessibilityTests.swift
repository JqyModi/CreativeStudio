import XCTest

class NavigationAccessibilityTests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testVoiceCommandNavigation() {
        // Verify voice command targets exist
        let backButton = app.buttons["back-button"]
        XCTAssertTrue(backButton.exists)
        XCTAssertEqual(backButton.accessibilityLabel, "返回首页")
        
        let homeTab = app.buttons["home-tab"]
        XCTAssertTrue(homeTab.exists)
        XCTAssertEqual(homeTab.accessibilityLabel, "仪表盘")
    }

    func testTabNavigationOrder() {
        // Check initial focus
        XCTAssertTrue(app.navigationBars["Dashboard"].exists)
        
        // Simulate tab key presses
        app.keys.tab.keys
        XCTAssertEqual(app.focusedElement?.identifier, "quota-display")
        
        app.keys.tab.keys
        XCTAssertEqual(app.focusedElement?.identifier, "create-button")
        
        app.keys.tab.keys
        XCTAssertEqual(app.focusedElement?.identifier, "recent-projects")
    }

    func testScreenReaderCompatibility() {
        // Verify critical elements have proper accessibility traits
        let statsCards = app.otherElements["stats-grid"].buttons
        for card in statsCards.allElementsBoundByIndex {
            XCTAssertTrue(card.accessibilityTraits.contains(.staticText))
            XCTAssertFalse(card.accessibilityTraits.contains(.button))
        }
        
        let projectCells = app.collectionViews.cells
        for cell in projectCells.allElementsBoundByIndex {
            XCTAssertTrue(cell.accessibilityTraits.contains(.button))
            XCTAssertNotNil(cell.accessibilityLabel)
        }
    }
}