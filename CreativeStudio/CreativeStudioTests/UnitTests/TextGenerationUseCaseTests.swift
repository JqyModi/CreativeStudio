import XCTest
@testable import CreativeStudio

class TextGenerationUseCaseTests: XCTestCase {
    private var mockService: MockFoundationModelsService!
    private var mockRepository: MockGenerationRepository!
    private var useCase: TextGenerationUseCase!

    override func setUp() {
        super.setUp()
        mockService = MockFoundationModelsService()
        mockRepository = MockGenerationRepository()
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

class MockFoundationModelsService {
    var stubbedGenerateTextResult: String?
    var stubbedGenerateTextError: Error?

    func generateText(from prompt: String, style: TextStyle) async throws -> String {
        if let error = stubbedGenerateTextError {
            throw error
        }
        return stubbedGenerateTextResult ?? ""
    }
}

class MockGenerationRepository {
    var saveCalled = false
    var savedResult: GenerationResult?

    func saveGenerationResult(_ result: GenerationResult) async throws {
        saveCalled = true
        savedResult = result
    }
}
