// CreativeStudio/Sources/Domain/Models/UserQuota.swift
import Foundation
import SwiftData

@Model
final class UserQuota: Codable {
    var dailyLimit: Int
    var usedToday: Int
    var resetTime: Date
    
    init(dailyLimit: Int = 50, usedToday: Int = 0, resetTime: Date) {
        self.dailyLimit = dailyLimit
        self.usedToday = usedToday
        self.resetTime = resetTime
    }
    
    func resetIfNeeded() {
        guard Date() >= resetTime else { return }
        
        usedToday = 0
        resetTime = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date().addingTimeInterval(86400)
    }
    
    func canGenerate() -> Bool {
        usedToday < dailyLimit
    }
    
    func incrementUsage() {
        guard canGenerate() else { return }
        usedToday += 1
    }
    
    // Codable implementation
    enum CodingKeys: CodingKey {
        case dailyLimit, usedToday, resetTime
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dailyLimit = try container.decode(Int.self, forKey: .dailyLimit)
        self.usedToday = try container.decode(Int.self, forKey: .usedToday)
        self.resetTime = try container.decode(Date.self, forKey: .resetTime)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dailyLimit, forKey: .dailyLimit)
        try container.encode(usedToday, forKey: .usedToday)
        try container.encode(resetTime, forKey: .resetTime)
    }
}