import Foundation
import SwiftData

@Model
final class Project {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var status: ProjectStatus
    var type: ProjectType
    var generationResults: [GenerationResult]
    
    init(id: UUID = UUID(), name: String, createdAt: Date = Date(), status: ProjectStatus = .inProgress, type: ProjectType = .text, generationResults: [GenerationResult] = []) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.status = status
        self.type = type
        self.generationResults = generationResults
    }
}

enum ProjectStatus: String, Codable {
    case inProgress
    case completed
    case failed
}

enum ProjectType: String, CaseIterable, Codable {
    case text = "文字"
    case image = "图像"
    case mixed = "混合"
}