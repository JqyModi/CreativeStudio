import Foundation

open class FoundationModelsService {
    func generateText(from prompt: String, temperature: Double, maxTokens: Int, style: TextStyle) async throws -> String {
        // Mock implementation for testing
        return "Generated text for: \(prompt)"
    }
    
    func availableLanguages() -> [Language] {
        return [.chinese, .english, .japanese]
    }
}

enum Language: String, CaseIterable {
    case chinese = "zh"
    case english = "en"
    case japanese = "ja"
}