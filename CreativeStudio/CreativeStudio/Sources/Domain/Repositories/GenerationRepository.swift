import Foundation
import SwiftData

protocol GenerationRepository {
    func fetchProjects() async throws -> [Project]
    func saveProject(_ project: Project) async throws
    func generateText(prompt: String, parameters: GenerationParams) async throws -> TextResult
    func generateImage(prompt: String, parameters: ImageGenerationParams) async throws -> ImageResult
    func saveGenerationResult(_ result: GenerationResult) async throws
}

struct GenerationParams {
    var temperature: Double
    var maxTokens: Int
    var style: TextStyle
    
    init(temperature: Double = 0.7, maxTokens: Int = 500, style: TextStyle = .creative) {
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.style = style
    }
}

struct ImageGenerationParams {
    let width: Int
    let height: Int
    let style: ArtStyle
    
    init(width: Int = 1024, height: Int = 1024, style: ArtStyle = .defaultStyle) {
        self.width = width
        self.height = height
        self.style = style
    }
}

struct TextResult {
    let text: String
    let tokensUsed: Int
}

struct ImageResult {
    let image: Data
    let prompt: String
}

@Model
final class GenerationResult {
    @Attribute(.unique) var id: UUID
    var prompt: String
    var texts: [String]
    var images: [Data]
    var createdAt: Date
    @Relationship var project: Project?
    
    init(id: UUID = UUID(), prompt: String, texts: [String] = [], images: [Data] = [], createdAt: Date = Date(), project: Project? = nil) {
        self.id = id
        self.prompt = prompt
        self.texts = texts
        self.images = images
        self.createdAt = createdAt
        self.project = project
    }
}