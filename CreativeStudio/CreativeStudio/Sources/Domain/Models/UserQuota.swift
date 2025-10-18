// CreativeStudio/Sources/Domain/Models/UserQuota.swift
import Foundation
import SwiftData

@Model
final class UserQuota {
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
}