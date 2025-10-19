import SwiftUI
import Combine

final class TextGenerationViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var isGenerating: Bool = false
    @Published var generatedText: String = ""
    @Published var progress: Double = 0.0
    @Published var parameters = GenerationParams()
    @Published var recentPrompts: [String] = []
    
    private let textGenerationUseCase: TextGenerationUseCase
    private var cancellables = Set<AnyCancellable>()

    init(
        textGenerationUseCase: TextGenerationUseCase = TextGenerationUseCase(
            service: FoundationModelsService(),
            repository: SwiftDataStorage()
        )
    ) {
        self.textGenerationUseCase = textGenerationUseCase
        
        // Load recent prompts from UserDefaults or similar
        self.recentPrompts = [
            "Create a beautiful landscape",
            "Write a short poem about nature",
            "Describe a futuristic city"
        ]
    }

    func generateContent() async {
        guard !inputText.isEmpty, !isGenerating else { return }
        
        isGenerating = true
        progress = 0.0
        
        DispatchQueue.main.async {
            // Simulate progress
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                DispatchQueue.main.async {
                    self?.progress += 0.05
                    if self?.progress ?? 0.0 >= 1.0 {
                        timer.invalidate()
                        self?.progress = 1.0
                    }
                }
            }
        }
        
        do {
            let result = try await textGenerationUseCase.execute(
                prompt: inputText,
                parameters: parameters
            )
            
            DispatchQueue.main.async { [weak self] in
                self?.generatedText = result.text
                self?.isGenerating = false
                self?.progress = 1.0
                
                // Add to recent prompts if not already present
                if let self = self {
                    if !self.recentPrompts.contains(self.inputText) {
                        self.recentPrompts.insert(self.inputText, at: 0)
                        if self.recentPrompts.count > 5 {
                            self.recentPrompts.removeLast()
                        }
                    }
                }
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.isGenerating = false
                print("Generation error: $error)")
            }
        }
    }

    func stopGeneration() {
        isGenerating = false
    }
}