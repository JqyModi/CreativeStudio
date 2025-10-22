//
//  TextGenerationUseCase.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/20.
//

import Foundation
import FoundationModels

@Observable
class TextGenerationUseCase {
    private let textGenerationService: FoundationModelsService
    
    init(textGenerationService: FoundationModelsService = FoundationModelsService()) {
        self.textGenerationService = textGenerationService
    }
    
    func execute(prompt: String, parameters: GenerationParams) async throws -> [String] {
        // Call the AI service with the provided parameters
        let generatedText = try await textGenerationService.generateText(
            prompt: prompt,
            creativity: parameters.creativity,
            temperature: parameters.temperature
        )
        
        // Split the generated text into chunks if needed based on length parameter
        let textChunks = splitTextIntoChunks(generatedText, maxLength: parameters.length)
        
        return textChunks
    }
    
    private func splitTextIntoChunks(_ text: String, maxLength: Int) -> [String] {
        guard maxLength > 0 else { return [text] }
        
        var chunks: [String] = []
        let words = text.components(separatedBy: " ")
        
        var currentChunk = ""
        for word in words {
            if currentChunk.count + word.count + 1 <= maxLength {
                currentChunk += (currentChunk.isEmpty ? "" : " ") + word
            } else {
                if !currentChunk.isEmpty {
                    chunks.append(currentChunk)
                }
                currentChunk = word
            }
        }
        
        if !currentChunk.isEmpty {
            chunks.append(currentChunk)
        }
        
        return chunks
    }
}

public struct GenerationParams {
    public var style: String = "default"
    public var creativity: Double = 0.5
    public var temperature: Double = 0.7
    public var length: Int = 100 // Maximum number of characters
    
    public init(style: String = "default", creativity: Double = 0.5, temperature: Double = 0.7, length: Int = 100) {
        self.style = style
        self.creativity = creativity
        self.temperature = temperature
        self.length = length
    }
}
