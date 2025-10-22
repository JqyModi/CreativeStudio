import Foundation
import FoundationModels

/// Service class for interacting with Apple's Foundation Models for text generation
public class FoundationModelsService: ObservableObject {
    
    private let model: SystemLanguageModel
    
    public init() {
        self.model = SystemLanguageModel.default
    }
    
    /// Generates text based on the provided prompt
    /// - Parameter prompt: The input prompt for text generation
    /// - Returns: Generated text as a String
    public func generateText(prompt: String) async throws -> String {
        // Check if the model is available
        guard model.availability == .available else {
            throw TextGenerationError.modelUnavailable
        }
        
        // Create a session with the model
        let session = LanguageModelSession()
        
        // Generate the response
        let response = try await session.respond(to: prompt)
        
        return response.content
    }
    
    /// Generates text based on the provided prompt with generation options
    /// - Parameters:
    ///   - prompt: The input prompt for text generation
    ///   - options: Generation options to control how tokens are sampled
    /// - Returns: Generated text as a String
    public func generateText(prompt: String, options: GenerationOptions) async throws -> String {
        // Check if the model is available
        guard model.availability == .available else {
            throw TextGenerationError.modelUnavailable
        }
        
        // Create a session with the model
        let session = LanguageModelSession()
        
        // Generate the response
        let response = try await session.respond(to: prompt, options: options)
        
        return response.content
    }
    
    /// Generates text based on the provided prompt with custom instructions
    /// - Parameters:
    ///   - prompt: The input prompt for text generation
    ///   - instructions: Custom instructions for the model
    /// - Returns: Generated text as a String
    public func generateText(prompt: String, instructions: String) async throws -> String {
        // Check if the model is available
        guard model.availability == .available else {
            throw TextGenerationError.modelUnavailable
        }
        
        // Create a session with the model and custom instructions
        let session = LanguageModelSession(instructions: instructions)
        
        // Generate the response
        let response = try await session.respond(to: prompt)
        
        return response.content
    }
    
    /// Generates text based on the provided prompt with parameters that map to GenrationOptions
    /// - Parameters:
    ///   - prompt: The input prompt for text generation
    ///   - creativity: Controls randomness (0.0 - 1.0), higher values make output more random
    ///   - temperature: Controls randomness of sampling (0.0 - 1.0), higher values make output more creative
    /// - Returns: Generated text as a String
    public func generateText(prompt: String, creativity: Double = 0.5, temperature: Double = 0.7) async throws -> String {
        // Check if the model is available
        guard model.availability == .available else {
            throw TextGenerationError.modelUnavailable
        }
        
        // Create generation options based on parameters
        var options = GenerationOptions()
        
        // In Foundation Models, we can set the sampling mode to control creativity
        // Using a random sampling mode with the provided temperature
        if temperature <= 0.3 {
            // For more deterministic output
            options.sampling = .random(probabilityThreshold: 0.3)
        } else if temperature <= 0.7 {
            // For balanced output
            options.sampling = .random(probabilityThreshold: 0.7)
        } else {
            // For more creative output
            options.sampling = .random(probabilityThreshold: 0.9)
        }
        
        // Create a session with the model
        let session = LanguageModelSession()
        
        // Generate the response
        let response = try await session.respond(to: prompt, options: options)
        
        return response.content
    }
}

/// Error types for text generation
enum TextGenerationError: LocalizedError {
    case modelUnavailable
    
    var errorDescription: String? {
        switch self {
        case .modelUnavailable:
            return "The Foundation Model is not available on this device or Apple Intelligence is not enabled."
        }
    }
}
