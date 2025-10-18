import XCTest

class DashboardUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        
        // Ensure we're on dashboard
        XCTAssertTrue(app.navigationBars["Dashboard"].exists)
    }

    func testStatsGridDisplay() {
        // Verify 3x2 stats grid
        let statsGrid = app.scrollViews.children(matching: .other).element(boundBy: 1)
        XCTAssertEqual(statsGrid.children(matching: .other).count, 6)
        
        // Check quota display
        let quotaLabel = app.staticTexts["quota-display"]
        XCTAssertTrue(quotaLabel.exists)
        XCTAssertEqual(quotaLabel.label, "25/50")
    }

    func testProjectSorting() {
        // Test sorting by time
        app.buttons["sort-toggle"].tap()
        app.menuItems["Sort by Time"].tap()
        
        let firstProject = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertEqual(firstProject.staticTexts["project-date"].label, "Today")
        
        // Test sorting by name
        app.buttons["sort-toggle"].tap()
        app.menuItems["Sort by Name"].tap()
        XCTAssertEqual(app.collectionViews.cells.element(boundBy: 0).staticTexts["project-name"].label, "A Creative Project")
    }

    func testQuotaWarningDisplay() {
        // Simulate near-limit quota
        app.buttons["debug-set-quota-45"].tap()
        
        let warningBanner = app.staticTexts["quota-warning"]
        XCTAssertTrue(warningBanner.waitForExistence(timeout: 2))
        XCTAssertEqual(warningBanner.label, "Only 5 generations left!")
    }
}