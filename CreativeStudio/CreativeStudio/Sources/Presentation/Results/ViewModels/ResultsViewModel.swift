import SwiftUI

final class ResultsViewModel: ObservableObject {
    @Published var generatedImages: [Data] = []
    @Published var generatedTexts: [String] = []
    @Published var currentTab: ResultsTab = .images
    
    private let textGenerationUseCase: TextGenerationUseCase
    private let imageGenerationUseCase: ImageGenerationUseCase
    private let repository: GenerationRepository

    init(
        textGenerationUseCase: TextGenerationUseCase = TextGenerationUseCase(
            service: FoundationModelsService(),
            repository: SwiftDataStorage()
        ),
        imageGenerationUseCase: ImageGenerationUseCase = ImageGenerationUseCase(
            service: ImagePlaygroundService(),
            repository: SwiftDataStorage()
        ),
        repository: GenerationRepository = SwiftDataStorage()
    ) {
        self.textGenerationUseCase = textGenerationUseCase
        self.imageGenerationUseCase = imageGenerationUseCase
        self.repository = repository
        
        // Initialize with sample data for preview
        loadSampleResults()
    }

    private func loadSampleResults() {
        // Generate sample image data (empty for now)
        generatedImages = [Data(count: 100), Data(count: 100), Data(count: 100), Data(count: 100)]
        generatedTexts = [
            "这是第一段生成的文本内容。",
            "这是第二段生成的文本内容。",
            "这是第三段生成的文本内容。",
            "这是第四段生成的文本内容。"
        ]
    }

    func regenerateContent() {
        // In a real implementation, this would regenerate the content
        print("Regenerating content...")
    }

    func exportResults() {
        // In a real implementation, this would handle exporting results
        print("Exporting results...")
    }
}

enum ResultsTab {
    case images
    case texts
    case combined
}