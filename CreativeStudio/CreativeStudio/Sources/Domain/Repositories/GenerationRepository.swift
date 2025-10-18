import Foundation

protocol GenerationRepository {
    func fetchProjects() async throws -> [Project]
    func saveProject(_ project: Project) async throws
    func generateText(prompt: String, parameters: GenerationParams) async throws -> TextResult
    func generateImage(prompt: String, parameters: ImageGenerationParams) async throws -> ImageResult
    func saveGenerationResult(_ result: GenerationResult) async throws
}

struct GenerationParams {
    let temperature: Double
    let maxTokens: Int
    let style: TextGenerationStyle
}

struct ImageGenerationParams {
    let width: Int
    let height: Int
    let style: ArtStyle
}

struct TextResult {
    let text: String
    let tokensUsed: Int
}

struct ImageResult {
    let image: Data
    let prompt: String
}

struct GenerationResult {
    let id: UUID
    let prompt: String
    let texts: [String]
    let createdAt: Date
}