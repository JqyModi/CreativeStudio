import Foundation
import FoundationModels

// Example usage of FoundationModelsService
//@main
struct FoundationModelsExample {
    static func main() async {
        do {
            // Create an instance of the service
            let service = FoundationModelsService()
            
            // Check availability first
            if SystemLanguageModel.default.availability != .available {
                print("Foundation Model is not available on this device")
                return
            }
            
            // Basic text generation
            let basicResult = try await service.generateText(prompt: "What is the capital of France?")
            print("Basic result: \(basicResult)")
            
            // Text generation with parameters
            let params = GenerationParams(creativity: 0.7, temperature: 0.8)
            let paramResult = try await service.generateText(
                prompt: "Write a short poem about creativity",
                creativity: params.creativity,
                temperature: params.temperature
            )
            print("Parameter result: \(paramResult)")
            
        } catch {
            print("Error: \(error)")
        }
    }
}
