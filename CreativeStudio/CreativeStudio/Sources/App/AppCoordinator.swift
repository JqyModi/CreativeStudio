//
//  AppCoordinator.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/8.
//

import SwiftUI
import SwiftData

class AppCoordinator: ObservableObject {
    @Published var userQuota: UserQuota
    @Published var currentProject: Project?
    @Published var currentView: ContentViewType = .dashboard
    
    init() {
        // Initialize with default quota values
        self.userQuota = UserQuota(dailyLimit: 50, usedToday: 0, resetTime: Date().addingTimeInterval(24*60*60))
    }
    
    func navigateToTextGeneration() {
        currentView = .textGeneration
    }
    
    func navigateToImageUpload() {
        currentView = .imageUpload
    }
    
    func navigateToResults(for project: Project) {
        currentProject = project
        currentView = .results
    }
    
    func navigateToDashboard() {
        currentView = .dashboard
    }
    
    func navigateToProjectList() {
        currentView = .projectList
    }
    
    func resetQuotaIfNeeded() {
        if Calendar.current.compare(Date(), to: userQuota.resetTime, toGranularity: .day) == .orderedDescending {
            userQuota.usedToday = 0
            userQuota.resetTime = Calendar.current.startOfDay(for: Date().addingTimeInterval(24*60*60))
        }
    }
}

enum ContentViewType: Equatable {
    case dashboard
    case textGeneration
    case imageUpload
    case results
    case projectList
}

// Data models
class UserQuota: ObservableObject {
    var dailyLimit: Int
    var usedToday: Int
    var resetTime: Date
    
    init(dailyLimit: Int, usedToday: Int, resetTime: Date) {
        self.dailyLimit = dailyLimit
        self.usedToday = usedToday
        self.resetTime = resetTime
    }
    
    var remaining: Int {
        return dailyLimit - usedToday
    }
    
    var usagePercentage: Double {
        return Double(usedToday) / Double(dailyLimit)
    }
    
    func canGenerate() -> Bool {
        return remaining > 0
    }
    
    func useGeneration() {
        if canGenerate() {
            usedToday += 1
        }
    }
}

class Project {
    var id: UUID
    var name: String
    var createdAt: Date
    var status: ProjectStatus
    var generationResults: [GenerationResult]
    
    init(id: UUID = UUID(), name: String, createdAt: Date = Date(), status: ProjectStatus = .completed, generationResults: [GenerationResult] = []) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.status = status
        self.generationResults = generationResults
    }
}

class GenerationResult {
    var id: UUID
    var prompt: String
    var images: [Data]  // JPEG format image data
    var texts: [String]
    var styleParams: StyleParameters
    var createdAt: Date
    
    init(id: UUID = UUID(), prompt: String, images: [Data] = [], texts: [String] = [], styleParams: StyleParameters = StyleParameters(), createdAt: Date = Date()) {
        self.id = id
        self.prompt = prompt
        self.images = images
        self.texts = texts
        self.styleParams = styleParams
        self.createdAt = createdAt
    }
}

struct StyleParameters {
    var style: String = "default"
    var creativity: Double = 0.5
    var temperature: Double = 0.7
    var strength: Double = 0.8
}

enum ProjectStatus: String {
    case inProgress = "进行中"
    case completed = "已完成"
}
