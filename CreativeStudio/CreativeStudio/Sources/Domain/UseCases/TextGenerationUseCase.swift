// CreativeStudio/Sources/Domain/UseCases/TextGenerationUseCase.swift
import Foundation

enum TextGenerationError: Error {
    case invalidPromptLength
    case serviceUnavailable
}

// Using TextResult from GenerationRepository.swift

struct TextGenerationUseCase {
    let service: FoundationModelsService
    let repository: GenerationRepository

    func execute(prompt: String, parameters: GenerationParams) async throws -> TextResult {
        guard prompt.count <= 500 else {
            throw TextGenerationError.invalidPromptLength
        }

        do {
            let generatedText = try await service.generateText(
                from: prompt,
                temperature: parameters.temperature,
                maxTokens: parameters.maxTokens,
                style: parameters.style
            )
            
            let result = GenerationResult(
                id: UUID(),
                prompt: prompt,
                texts: [generatedText],
                createdAt: Date()
            )
            
            try await repository.saveGenerationResult(result)
            return TextResult(text: generatedText, tokensUsed: generatedText.count)
        } catch {
            throw TextGenerationError.serviceUnavailable
        }
    }
}