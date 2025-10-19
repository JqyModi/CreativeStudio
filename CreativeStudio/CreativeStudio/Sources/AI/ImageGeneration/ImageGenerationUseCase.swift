// CreativeStudio/Sources/AI/ImageGeneration/ImageGenerationUseCase.swift
import Foundation
import UIKit

enum ImageGenerationError: Error {
    case fileTooLarge
    case invalidFormat
    case tooManyFiles
}

struct ImageGenerationUseCase {
    let service: ImagePlaygroundService
    let repository: GenerationRepository

    func execute(files: [any ImageFileProtocol], parameters: ImageGenerationParams) async throws -> [ImageResult] {
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

        // Convert to data and create results
        var results = [ImageResult]()
        for image in generatedImages {
            if let imageData = image.jpegData(compressionQuality: 0.9) {
                let result = ImageResult(image: imageData, prompt: "Image Upload")
                results.append(result)
            }
        }

        // Save to repository
        let generationResult = GenerationResult(
            prompt: "Image Upload",
            texts: [],
            images: generatedImages.compactMap { $0.jpegData(compressionQuality: 0.9) }
        )
        try await repository.saveGenerationResult(generationResult)

        return results
    }
}
