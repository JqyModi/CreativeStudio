import XCTest
@testable import CreativeStudio

class TextGenerationUseCaseTests: XCTestCase {
    private var mockService: MockFoundationModelsService!
    private var mockRepository: TextGenerationMockRepository!
    private var useCase: TextGenerationUseCase!

    override func setUp() {
        super.setUp()
        mockService = MockFoundationModelsService()
        mockRepository = TextGenerationMockRepository()
        useCase = TextGenerationUseCase(service: mockService, repository: mockRepository)
    }

    func testExecute_validPrompt_savesResult() async throws {
        mockService.stubbedGenerateTextResult = "Generated text"
        
        let result = try await useCase.execute(
            prompt: "Create a beautiful landscape",
            parameters: GenerationParams(style: .creative)
        )
        
        XCTAssertEqual(result.text, "Generated text")
        XCTAssertTrue(mockRepository.saveCalled)
        XCTAssertEqual(mockRepository.savedResult?.prompt, "Create a beautiful landscape")
    }

    func testExecute_promptExceedsLimit_throwsError() async {
        do {
            _ = try await useCase.execute(
                prompt: String(repeating: "a", count: 501),
                parameters: GenerationParams()
            )
            XCTFail("Should have thrown error")
        } catch {
            XCTAssertEqual((error as? TextGenerationError), .invalidPromptLength)
        }
    }

    func testExecute_serviceFailure_propagatesError() async {
        mockService.stubbedGenerateTextError = TextGenerationError.serviceUnavailable
        
        do {
            _ = try await useCase.execute(prompt: "Valid prompt", parameters: GenerationParams())
            XCTFail("Should have thrown error")
        } catch {
            XCTAssertEqual((error as? TextGenerationError), .serviceUnavailable)
            XCTAssertFalse(mockRepository.saveCalled)
        }
    }
}

class MockFoundationModelsService: FoundationModelsService {
    var stubbedGenerateTextResult: String?
    var stubbedGenerateTextError: Error?

    override func generateText(from prompt: String, temperature: Double, maxTokens: Int, style: TextStyle) async throws -> String {
        if let error = stubbedGenerateTextError {
            throw error
        }
        return stubbedGenerateTextResult ?? ""
    }
}

class TextGenerationMockRepository: GenerationRepository {
    var saveCalled = false
    var savedResult: GenerationResult?

    func saveProject(_ project: Project) async throws {
        // Mock implementation
    }

    func fetchProjects() async throws -> [Project] {
        return []
    }

    func saveGenerationResult(_ result: GenerationResult) async throws {
        saveCalled = true
        savedResult = result
    }
    
    func generateText(prompt: String, parameters: GenerationParams) async throws -> TextResult {
        return TextResult(text: "", tokensUsed: 0)
    }
    
    func generateImage(prompt: String, parameters: ImageGenerationParams) async throws -> ImageResult {
        return ImageResult(image: Data(), prompt: "")
    }
}
