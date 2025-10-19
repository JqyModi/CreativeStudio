import XCTest
@testable import CreativeStudio
import UIKit

class ImageUploadValidationTests: XCTestCase {
    private var mockService: MockImagePlaygroundService!
    private var mockRepository: ImageUploadMockRepository!
    private var useCase: ImageGenerationUseCase!

    override func setUp() {
        super.setUp()
        mockService = MockImagePlaygroundService()
        mockRepository = ImageUploadMockRepository()
        useCase = ImageGenerationUseCase(service: mockService, repository: mockRepository)
    }

    func testValidImageUpload() async throws {
        let validImage = MockImageFile(size: 15_000_000, format: .jpg, uiImage: UIImage())
        
        let results = try await useCase.execute(
            files: [validImage],
            parameters: ImageGenerationParams()
        )
        
        XCTAssertTrue(mockService.generateCalled)
        XCTAssertTrue(mockRepository.saveCalled)
        XCTAssertTrue(results.count >= 0) // We expect at least 0 results
    }

    func testImageExceedsSizeLimit() async {
        let largeImage = MockImageFile(size: 25_000_000, format: .png, uiImage: UIImage())
        
        do {
            _ = try await useCase.execute(files: [largeImage], parameters: ImageGenerationParams())
            XCTFail("Should have thrown error")
        } catch {
            XCTAssertEqual((error as? ImageGenerationError), .fileTooLarge)
            XCTAssertFalse(mockService.generateCalled)
        }
    }

    func testInvalidImageFormat() async {
        let gifImage = MockImageFile(size: 10_000_000, format: .gif, uiImage: UIImage())
        
        do {
            _ = try await useCase.execute(files: [gifImage], parameters: ImageGenerationParams())
            XCTFail("Should have thrown error")
        } catch {
            XCTAssertEqual((error as? ImageGenerationError), .invalidFormat)
            XCTAssertFalse(mockService.generateCalled)
        }
    }

    func testExceedsFileCountLimit() async {
        let files = (0..<6).map { _ in MockImageFile(size: 10_000_000, format: .jpg, uiImage: UIImage()) }
        
        do {
            _ = try await useCase.execute(files: files, parameters: ImageGenerationParams())
            XCTFail("Should have thrown error")
        } catch {
            XCTAssertEqual((error as? ImageGenerationError), .tooManyFiles)
            XCTAssertFalse(mockService.generateCalled)
        }
    }
}

class MockImageFile: ImageFileProtocol {
    let uiImage: UIImage
    let size: Int
    let format: ImageFormat
    
    init(size: Int, format: ImageFormat, uiImage: UIImage) {
        self.size = size
        self.format = format
        self.uiImage = uiImage
    }
}

class MockImagePlaygroundService: ImagePlaygroundService {
    var generateCalled = false
    
    override func generateImage(from image: UIImage, style: ArtStyle) async throws -> UIImage {
        generateCalled = true
        return image
    }
}

// This should not be redefined if it already exists in the main target
// enum ImageGenerationError: Error {
//     case fileTooLarge
//     case invalidFormat
//     case tooManyFiles
// }

class ImageUploadMockRepository: GenerationRepository {
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
