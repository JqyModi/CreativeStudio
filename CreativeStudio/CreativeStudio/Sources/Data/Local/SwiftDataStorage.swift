//
//  SwiftDataStorage.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/20.
//

import Foundation
import SwiftData

@Observable
class SwiftDataStorage {
    private let modelContainer: ModelContainer
    
    init() throws {
        modelContainer = try ModelContainer(for: UserQuotaModel.self, ProjectModel.self, GenerationResultModel.self)
    }
    
    func saveUserQuota(_ quota: UserQuota) throws {
        // Implementation for saving user quota to SwiftData
    }
    
    func fetchUserQuota() throws -> UserQuota? {
        // Implementation for fetching user quota from SwiftData
        return nil
    }
    
    func saveProject(_ project: Project) throws {
        // Implementation for saving project to SwiftData
    }
    
    func fetchProjects() throws -> [Project] {
        // Implementation for fetching projects from SwiftData
        return []
    }
    
    func deleteProject(_ project: Project) throws {
        // Implementation for deleting project from SwiftData
    }
    
    func saveGenerationResult(_ result: GenerationResult) throws {
        // Implementation for saving generation result to SwiftData
    }
    
    func fetchGenerationResults(for project: Project) throws -> [GenerationResult] {
        // Implementation for fetching generation results from SwiftData
        return []
    }
}

// SwiftData Models
@Model
class UserQuotaModel {
    var dailyLimit: Int
    var usedToday: Int
    var resetTime: Date
    
    init(dailyLimit: Int, usedToday: Int, resetTime: Date) {
        self.dailyLimit = dailyLimit
        self.usedToday = usedToday
        self.resetTime = resetTime
    }
}

@Model
class ProjectModel {
    var id: UUID
    var name: String
    var createdAt: Date
    var status: String // Using String instead of enum for SwiftData compatibility
    var generationResults: [GenerationResultModel]
    
    init(id: UUID = UUID(), name: String, createdAt: Date = Date(), status: String = "completed", generationResults: [GenerationResultModel] = []) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.status = status
        self.generationResults = generationResults
    }
}

@Model
class GenerationResultModel {
    var id: UUID
    var prompt: String
    var images: [Data]  // JPEG format image data
    var texts: [String]
    var styleParams: String // JSON string representation of style parameters
    var createdAt: Date
    
    init(id: UUID = UUID(), prompt: String, images: [Data] = [], texts: [String] = [], styleParams: String = "{}", createdAt: Date = Date()) {
        self.id = id
        self.prompt = prompt
        self.images = images
        self.texts = texts
        self.styleParams = styleParams
        self.createdAt = createdAt
    }
}