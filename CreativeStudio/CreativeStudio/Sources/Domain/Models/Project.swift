import Foundation

struct Project: Identifiable, Codable {
    let id: UUID
    let name: String
    let createdAt: Date
    let status: ProjectStatus
}

enum ProjectStatus: String, Codable {
    case inProgress
    case completed
    case failed
}