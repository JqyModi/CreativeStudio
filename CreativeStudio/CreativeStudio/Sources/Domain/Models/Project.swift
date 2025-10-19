import Foundation
import SwiftData

@Model
final class Project {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var status: ProjectStatus
    var generationResults: [GenerationResult]
    
    init(id: UUID = UUID(), name: String, createdAt: Date = Date(), status: ProjectStatus = .inProgress, generationResults: [GenerationResult] = []) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.status = status
        self.generationResults = generationResults
    }
}

enum ProjectStatus: String, Codable {
    case inProgress
    case completed
    case failed
}