import XCTest
@testable import CreativeStudio

class UserQuotaTests: XCTestCase {
    var userQuota: UserQuota!
    
    override func setUp() {
        super.setUp()
        userQuota = UserQuota(
            dailyLimit: 50,
            usedToday: 0,
            resetTime: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        )
    }

    func testCanGenerate_whenUnderLimit() {
        userQuota.usedToday = 25
        XCTAssertTrue(userQuota.canGenerate())
    }

    func testCanGenerate_whenAtLimit() {
        userQuota.usedToday = 50
        XCTAssertFalse(userQuota.canGenerate())
    }

    func testResetIfNeeded_whenNewDay() {
        userQuota.usedToday = 45
        userQuota.resetTime = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        userQuota.resetIfNeeded()
        
        XCTAssertEqual(userQuota.usedToday, 0)
        XCTAssertGreaterThan(userQuota.resetTime, Date())
    }

    func testResetIfNeeded_whenSameDay() {
        let originalUsed = userQuota.usedToday
        userQuota.usedToday = 30
        
        userQuota.resetIfNeeded()
        
        XCTAssertEqual(userQuota.usedToday, 30)
        XCTAssertEqual(userQuota.usedToday, originalUsed + 30)
    }
}
