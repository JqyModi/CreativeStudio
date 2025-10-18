import XCTest
@testable import CreativeStudio

class ImageUploadValidationTests: XCTestCase {
    private var mockService: MockImagePlaygroundService!
    private var mockRepository: MockGenerationRepository!
    private var useCase: ImageGenerationUseCase!

    override func setUp() {
        super.setUp()
        mockService = MockImagePlaygroundService()
        mockRepository = MockGenerationRepository()
        useCase = ImageGenerationUseCase(service: mockService, repository: mockRepository)
    }

    func testValidImageUpload() async throws {
        let validImage = MockImageFile(size: 15_000_000, format: .jpg)
        
        let result = try await useCase.execute(
            files: [validImage],
            parameters: ImageGenerationParams()
        )
        
        XCTAssertTrue(mockService.generateCalled)
        XCTAssertTrue(mockRepository.saveCalled)
        XCTAssertEqual(result.images.count, 1)
    }

    func testImageExceedsSizeLimit() async {
        let largeImage = MockImageFile(size: 25_000_000, format: .png)
        
        do {
            _ = try await useCase.execute(files: [largeImage], parameters: ImageGenerationParams())
            XCTFail("Should have thrown error")
        } catch {
            XCTAssertEqual((error as? ImageGenerationError), .fileTooLarge)
            XCTAssertFalse(mockService.generateCalled)
        }
    }

    func testInvalidImageFormat() async {
        let gifImage = MockImageFile(size: 10_000_000, format: .gif)
        
        do {
            _ = try await useCase.execute(files: [gifImage], parameters: ImageGenerationParams())
            XCTFail("Should have thrown error")
        } catch {
            XCTAssertEqual((error as? ImageGenerationError), .invalidFormat)
            XCTAssertFalse(mockService.generateCalled)
        }
    }

    func testExceedsFileCountLimit() async {
        let files = (0..<6).map { _ in MockImageFile(size: 10_000_000, format: .jpg) }
        
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
    let size: Int
    let format: ImageFormat
    
    init(size: Int, format: ImageFormat) {
        self.size = size
        self.format = format
    }
}

class MockImagePlaygroundService {
    var generateCalled = false
    
    func generateImage(from file: ImageFileProtocol, style: ArtStyle) async throws -> UIImage {
        generateCalled = true
        return UIImage()
    }
}

enum ImageGenerationError: Error {
    case fileTooLarge
    case invalidFormat
    case tooManyFiles
}
