import SwiftUI
import UniformTypeIdentifiers

final class ResultsViewModel: ObservableObject {
    @Published var selectedTab: ResultsTab = .images
    @Published var imageResults: [Data] = []
    @Published var textResults: [String] = []
    @Published var socialMediaTexts: [String] = []
    @Published var combinedResults: [CombinedResult] = []
    @Published var recommendedVariants: [RecommendedVariant] = []
    @Published var trendingTemplates: [Template] = []
    @Published var isGenerating: Bool = false
    @Published var progress: Double = 0.0
    
    private let textGenerationUseCase: TextGenerationUseCase
    private let imageGenerationUseCase: ImageGenerationUseCase
    private let repository: GenerationRepository
    private var currentProject: Project?
    
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
        initializeSampleData()
    }
    
    func loadResults() {
        // In a real implementation, this would load results from the repository
        // For now, we'll use sample data
        loadSampleResults()
    }
    
    func regenerateContent() async {
        guard !isGenerating, let project = currentProject else { return }
        
        isGenerating = true
        progress = 0.0
        
        // Simulate regeneration process
        Task {
            do {
                // This would actually regenerate content based on the project
                // For now, we'll just simulate the process
                for i in 1...10 {
                    try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                    await MainActor.run {
                        self.progress = Double(i) / 10.0
                    }
                }
                
                await MainActor.run {
                    self.isGenerating = false
                    self.progress = 1.0
                    // Reload results after regeneration
                    self.loadSampleResults()
                }
            } catch {
                await MainActor.run {
                    self.isGenerating = false
                    self.progress = 0.0
                    print("Regeneration error: $error)")
                }
            }
        }
    }
    
    func deleteImageResult(at index: Int) {
        guard index < imageResults.count else { return }
        imageResults.remove(at: index)
    }
    
    func deleteTextResult(at index: Int) {
        guard index < textResults.count else { return }
        textResults.remove(at: index)
    }
    
    func deleteCombinedResult(at index: Int) {
        guard index < combinedResults.count else { return }
        combinedResults.remove(at: index)
    }
    
    func shareImageResult(at index: Int) {
        guard index < imageResults.count else { return }
        let imageData = imageResults[index]
        // Implementation for sharing image
        print("Sharing image result at index $index)")
    }
    
    func shareTextResult(at index: Int) {
        guard index < textResults.count else { return }
        let text = textResults[index]
        // Implementation for sharing text
        print("Sharing text result at index $index): $text)")
    }
    
    func copyTextResult(at index: Int) {
        guard index < textResults.count else { return }
        let text = textResults[index]
        UIPasteboard.general.string = text
        print("Copied text result at index $index) to clipboard")
    }
    
    func copySocialMediaText(at index: Int) {
        guard index < socialMediaTexts.count else { return }
        let text = socialMediaTexts[index]
        UIPasteboard.general.string = text
        print("Copied social media text at index $index) to clipboard")
    }
    
    func shareCombinedResult(at index: Int) {
        guard index < combinedResults.count else { return }
        let result = combinedResults[index]
        // Implementation for sharing combined result
        print("Sharing combined result at index $index)")
    }
    
    func selectRecommendedVariant(at index: Int) {
        guard index < recommendedVariants.count else { return }
        let variant = recommendedVariants[index]
        // Implementation for selecting recommended variant
        print("Selected recommended variant: $variant.title)")
    }
    
    func applyTemplate(at index: Int) {
        guard index < trendingTemplates.count else { return }
        let template = trendingTemplates[index]
        // Implementation for applying template
        print("Applied template: $template.name)")
    }
    
    func exportHighResolutionImages() {
        // Implementation for exporting high resolution images
        print("Exporting high resolution images")
    }
    
    func exportTexts() {
        // Implementation for exporting texts
        print("Exporting texts")
    }
    
    func exportForSocialMedia() {
        // Implementation for exporting for social media
        print("Exporting for social media")
    }
    
    func archiveProject() {
        // Implementation for archiving project
        print("Archiving project")
    }
    
    private func loadSampleResults() {
        // Generate sample image data (empty for now)
        imageResults = [
            Data(count: 1000), // Placeholder data
            Data(count: 1000),
            Data(count: 1000),
            Data(count: 1000)
        ]
        
        // Sample text results
        textResults = [
            "这是一段生成的文本内容，展示了AI生成的文案质量。内容可以根据不同的风格和参数进行调整，以满足各种创作需求。",
            "另一段示例文本，用于演示文本生成功能。该功能可以生成各种类型的文案，包括文章、故事、诗歌等。",
            "更多示例文本内容，展示多样化的生成结果。AI可以根据用户的提示和参数生成丰富多样的内容。"
        ]
        
        // Sample social media texts
        socialMediaTexts = [
            "AI生成的社交媒体文案示例 #AI创作 #创意内容",
            "使用AI工具快速生成高质量内容 🚀 #效率提升 #科技创新",
            "探索AI在内容创作领域的无限可能 💡 #人工智能 #未来科技"
        ]
        
        // Sample combined results
        combinedResults = [
            CombinedResult(
                imageData: Data(count: 1000),
                text: "图文结合的示例内容，展示了图像和文本的完美结合。",
                layout: Layout(title: "图文环绕", type: .textWrap)
            ),
            CombinedResult(
                imageData: Data(count: 1000),
                text: "另一种布局的图文结合示例，展示了不同的排版风格。",
                layout: Layout(title: "上下布局", type: .vertical)
            )
        ]
        
        // Sample recommended variants
        recommendedVariants = [
            RecommendedVariant(
                title: "风格变体1",
                description: "不同的艺术风格变体",
                previewImage: Data(count: 1000)
            ),
            RecommendedVariant(
                title: "风格变体2",
                description: "另一种艺术风格变体",
                previewImage: Data(count: 1000)
            )
        ]
        
        // Sample trending templates
        trendingTemplates = [
            Template(
                name: "产品展示模板",
                tags: ["电商", "营销"],
                previewImage: nil
            ),
            Template(
                name: "社交媒体模板",
                tags: ["社交", "推广"],
                previewImage: nil
            ),
            Template(
                name: "文章写作模板",
                tags: ["内容", "文案"],
                previewImage: nil
            )
        ]
    }
    
    private func initializeSampleData() {
        loadSampleResults()
    }
}

// MARK: - Supporting Types
enum ResultsTab: CaseIterable {
    case images
    case texts
    case combined
    case recommended
    
    var title: String {
        switch self {
        case .images: return "图像"
        case .texts: return "文案"
        case .combined: return "组合"
        case .recommended: return "推荐"
        }
    }
    
    var iconName: String {
        switch self {
        case .images: return "photo"
        case .texts: return "doc.text"
        case .combined: return "rectangle.3.group"
        case .recommended: return "star"
        }
    }
}

struct CombinedResult {
    let imageData: Data?
    let text: String
    let layout: Layout
}

struct Layout {
    let title: String
    let type: LayoutType
    
    enum LayoutType {
        case textWrap
        case vertical
        case horizontal
        case grid
    }
}

struct RecommendedVariant {
    let title: String
    let description: String
    let previewImage: Data?
}

struct Template {
    let name: String
    let tags: [String]
    let previewImage: Data?
}