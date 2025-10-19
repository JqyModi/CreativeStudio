import SwiftUI
import Combine

final class TextGenerationViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var isGenerating: Bool = false
    @Published var generatedText: String = ""
    @Published var progress: Double = 0.0
    @Published var parameters = GenerationParams()
    @Published var recentPrompts: [String] = []
    @Published var smartSuggestions: [String] = []
    @Published var selectedLanguage: Language = .chinese
    @Published var estimatedCompletionTime: TimeInterval = 0
    
    private let textGenerationUseCase: TextGenerationUseCase
    private let repository: GenerationRepository
    private let userDefaultsStorage: UserDefaultsStorage
    private var cancellables = Set<AnyCancellable>()
    
    // Timer for simulating progress
    private var progressTimer: Timer?

    init(
        textGenerationUseCase: TextGenerationUseCase = TextGenerationUseCase(
            service: FoundationModelsService(),
            repository: SwiftDataStorage()
        ),
        repository: GenerationRepository = SwiftDataStorage(),
        userDefaultsStorage: UserDefaultsStorage = .init()
    ) {
        self.textGenerationUseCase = textGenerationUseCase
        self.repository = repository
        self.userDefaultsStorage = userDefaultsStorage
        
        // Load recent prompts
        self.recentPrompts = userDefaultsStorage.loadRecentPrompts() ?? []
        
        // Generate smart suggestions based on common patterns
        self.smartSuggestions = [
            "写一篇关于人工智能的文章",
            "描述一个美丽的风景",
            "创建一个产品介绍文案",
            "写一封商务邮件",
            "创作一首诗歌"
        ]
        
        // Observe input text changes for smart suggestions
        $inputText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.updateSmartSuggestions(for: text)
            }
            .store(in: &cancellables)
    }
    
    func generateContent() async {
        guard !inputText.isEmpty, !isGenerating else { return }
        
        isGenerating = true
        progress = 0.0
        generatedText = ""
        estimatedCompletionTime = Double.random(in: 5...30) // Random estimate between 5-30 seconds
        
        // Start progress simulation
        startProgressSimulation()
        
        do {
            let result = try await textGenerationUseCase.execute(
                prompt: inputText,
                parameters: parameters
            )
            
            // Stop progress simulation
            stopProgressSimulation()
            
            DispatchQueue.main.async { [weak self] in
                self?.generatedText = result.text
                self?.isGenerating = false
                self?.progress = 1.0
                self?.estimatedCompletionTime = 0
                
                // Add to recent prompts
                self?.addToRecentPrompts()
                
                // Increment usage quota
                self?.incrementUsageQuota()
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.isGenerating = false
                self?.progress = 0.0
                self?.estimatedCompletionTime = 0
                print("Generation error: $error)")
            }
        }
    }
    
    func stopGeneration() {
        isGenerating = false
        stopProgressSimulation()
    }
    
    private func startProgressSimulation() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Simulate progress with acceleration/deceleration
                let randomIncrement = Double.random(in: 0.01...0.05)
                self.progress = min(0.95, self.progress + randomIncrement)
                
                // Decrease estimated time
                if self.estimatedCompletionTime > 0 {
                    self.estimatedCompletionTime = max(0, self.estimatedCompletionTime - 0.1)
                }
            }
        }
    }
    
    private func stopProgressSimulation() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    private func updateSmartSuggestions(for text: String) {
        // Simple implementation - in a real app, this would use AI or ML
        if text.count > 3 {
            smartSuggestions = [
                "$text) 的详细描述",
                "关于 $text) 的故事",
                "$text) 的优缺点分析",
                "如何使用 $text)",
                "$text) 的未来发展"
            ].filter { $0.count <= 200 } // Ensure within character limit
        } else {
            // Default suggestions
            smartSuggestions = [
                "写一篇关于人工智能的文章",
                "描述一个美丽的风景",
                "创建一个产品介绍文案",
                "写一封商务邮件",
                "创作一首诗歌"
            ]
        }
    }
    
    private func addToRecentPrompts() {
        // Add to recent prompts if not already present
        if !recentPrompts.contains(inputText) {
            recentPrompts.insert(inputText, at: 0)
            
            // Keep only last 10 prompts
            if recentPrompts.count > 10 {
                recentPrompts.removeLast()
            }
            
            // Save to user defaults
            userDefaultsStorage.saveRecentPrompts(recentPrompts)
        }
    }
    
    private func incrementUsageQuota() {
        // This would typically be handled by the coordinator
        // but we can notify through a delegate or callback
        NotificationCenter.default.post(name: .usageQuotaIncremented, object: nil)
    }
}

// Notification extension
extension Notification.Name {
    static let usageQuotaIncremented = Notification.Name("usageQuotaIncremented")
}

// Extension for UserDefaultsStorage to handle recent prompts
extension UserDefaultsStorage {
    private static let recentPromptsKey = "recentPrompts"
    
    func saveRecentPrompts(_ prompts: [String]) {
        UserDefaults.standard.set(prompts, forKey: Self.recentPromptsKey)
    }
    
    func loadRecentPrompts() -> [String]? {
        return UserDefaults.standard.array(forKey: Self.recentPromptsKey) as? [String]
    }
}