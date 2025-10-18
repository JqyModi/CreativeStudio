// CreativeStudio/Sources/AI/ImageGeneration/ImageGenerationUseCase.swift
import Foundation
import UIKit

enum ImageGenerationError: Error {
    case fileTooLarge
    case invalidFormat
    case tooManyFiles
}

// Removed - use ImageResult from GenerationRepository.swift

// Use ImageGenerationParams from GenerationRepository.swift

struct ImageGenerationUseCase {
    let service: ImagePlaygroundService
    let repository: GenerationRepository

    func execute(files: [ImageFile], parameters: ImageGenerationParams) async throws -> ImageResult {
        // Validate input constraints
        guard files.count <= 5 else {
            throw ImageGenerationError.tooManyFiles
        }

        for file in files {
            guard file.size <= 20_000_000 else {
                throw ImageGenerationError.fileTooLarge
            }
            guard file.format == .jpg || file.format == .png else {
                throw ImageGenerationError.invalidFormat
            }
        }

        // Generate images
        var generatedImages = [UIImage]()
        for file in files {
            let image = try await service.generateImage(
                from: file.uiImage,
                style: parameters.style
            )
            generatedImages.append(image)
        }

        // Save to repository
        let result = GenerationResult(
            id: UUID(),
            prompt: "Image Upload",
            texts: [],
            createdAt: Date()
        )
        try await repository.saveGenerationResult(result)

        return ImageResult(image: generatedImages.first?.jpegData(compressionQuality: 0.9) ?? Data(), prompt: "Image Upload")
    }
}

struct ImageFile {
    let uiImage: UIImage
    let size: Int
    let format: ImageFormat
}

enum ImageFormat {
    case jpg, png, gif
}
