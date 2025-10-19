// CreativeStudio/Sources/Domain/Models/UserQuota.swift
import Foundation
import SwiftData

@Model
final class UserQuota: Codable {
    var dailyLimit: Int
    var usedToday: Int
    var resetTime: Date
    var lastResetDate: Date // Track when quota was last reset
    
    init(dailyLimit: Int = 50, usedToday: Int = 0, resetTime: Date, lastResetDate: Date = Date()) {
        self.dailyLimit = dailyLimit
        self.usedToday = usedToday
        self.resetTime = resetTime
        self.lastResetDate = lastResetDate
    }
    
    func resetIfNeeded() {
        let now = Date()
        guard now >= resetTime else { return }
        
        usedToday = 0
        lastResetDate = now
        
        // Set next reset time to tomorrow
        let calendar = Calendar.current
        resetTime = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: now)!
        resetTime = calendar.date(byAdding: .day, value: 1, to: resetTime)!
    }
    
    func canGenerate() -> Bool {
        usedToday < dailyLimit
    }
    
    func incrementUsage() {
        guard canGenerate() else { return }
        usedToday += 1
    }
    
    func getRemainingQuota() -> Int {
        return max(0, dailyLimit - usedToday)
    }
    
    func getUsagePercentage() -> Double {
        return dailyLimit > 0 ? Double(usedToday) / Double(dailyLimit) : 0
    }
    
    func getTimeUntilReset() -> TimeInterval {
        let now = Date()
        return max(0, resetTime.timeIntervalSince(now))
    }
    
    func formatTimeUntilReset() -> String {
        let timeInterval = getTimeUntilReset()
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    // Codable implementation
    enum CodingKeys: CodingKey {
        case dailyLimit, usedToday, resetTime, lastResetDate
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dailyLimit = try container.decode(Int.self, forKey: .dailyLimit)
        self.usedToday = try container.decode(Int.self, forKey: .usedToday)
        self.resetTime = try container.decode(Date.self, forKey: .resetTime)
        self.lastResetDate = try container.decode(Date.self, forKey: .lastResetDate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dailyLimit, forKey: .dailyLimit)
        try container.encode(usedToday, forKey: .usedToday)
        try container.encode(resetTime, forKey: .resetTime)
        try container.encode(lastResetDate, forKey: .lastResetDate)
    }
}