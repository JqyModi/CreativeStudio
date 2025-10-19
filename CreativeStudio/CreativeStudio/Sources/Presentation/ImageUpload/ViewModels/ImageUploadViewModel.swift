import SwiftUI
import UniformTypeIdentifiers

final class ImageUploadViewModel: ObservableObject {
    @Published var selectedImages: [Data] = []
    @Published var descriptionText: String = ""
    @Published var selectedStyle: ArtStyle = .defaultStyle
    @Published var isGenerating: Bool = false
    @Published var isDragOver = false
    @Published var showImagePicker = false
    
    private let imageGenerationUseCase: ImageGenerationUseCase
    private let repository: GenerationRepository

    init(
        imageGenerationUseCase: ImageGenerationUseCase = ImageGenerationUseCase(
            service: ImagePlaygroundService(),
            repository: SwiftDataStorage()
        ),
        repository: GenerationRepository = SwiftDataStorage()
    ) {
        self.imageGenerationUseCase = imageGenerationUseCase
        self.repository = repository
    }

    func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.canLoadObject(ofClass: URL.self) {
                _ = provider.loadObject(ofClass: URL.self) { [weak self] url, _ in
                    guard let self = self, let url = url else { return }
                    
                    // Check if it's an image
                    guard url.pathExtension.lowercased().containsAny(of: ["jpg", "jpeg", "png"]) else { return }
                    
                    // Check file size
                    do {
                        let fileSize = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
                        if fileSize > 20_000_000 { // 20MB limit
                            print("File too large: $fileSize) bytes")
                            return
                        }
                    } catch {
                        print("Error getting file size: $error)")
                        return
                    }
                    
                    // Read image data
                    do {
                        let imageData = try Data(contentsOf: url)
                        DispatchQueue.main.async {
                            self.selectedImages.append(imageData)
                            if self.selectedImages.count > 5 {
                                self.selectedImages.removeFirst()
                            }
                        }
                    } catch {
                        print("Error reading file: $error)")
                    }
                }
            }
        }
        return true
    }

    func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }

    func generateContent() async {
        guard !selectedImages.isEmpty, !isGenerating else { return }
        
        isGenerating = true
        
        // Convert Data to ImageFileProtocol objects for the use case
        var imageFiles: [any ImageFileProtocol] = []
        for imageData in selectedImages {
            if let uiImage = UIImage(data: imageData) {
                let file = UploadedImageFile(
                    uiImage: uiImage,
                    size: imageData.count,
                    format: getImageFormat(from: imageData)
                )
                imageFiles.append(file)
            }
        }
        
        do {
            let results = try await imageGenerationUseCase.execute(
                files: imageFiles,
                parameters: ImageGenerationParams(
                    width: 1024,
                    height: 1024,
                    style: selectedStyle
                )
            )
            
            DispatchQueue.main.async {
                self.isGenerating = false
                // Process results as needed
                print("Generated $results.count) images")
            }
        } catch {
            DispatchQueue.main.async {
                self.isGenerating = false
                print("Generation error: $error)")
            }
        }
    }
    
    private func getImageFormat(from data: Data) -> ImageFormat {
        // Basic format detection based on magic numbers
        if data.starts(with: [0xFF, 0xD8, 0xFF]) {
            return .jpg
        } else if data.starts(with: [0x89, 0x50, 0x4E, 0x47]) {
            return .png
        } else {
            return .jpg // default
        }
    }
}

// Extension for String to support "containsAny" method
extension String {
    func containsAny(of strings: [String]) -> Bool {
        return strings.contains { self.lowercased().contains($0.lowercased()) }
    }
}

// Implementation of ImageFileProtocol for uploaded images
class UploadedImageFile: ImageFileProtocol {
    let uiImage: UIImage
    let size: Int
    let format: ImageFormat
    
    init(uiImage: UIImage, size: Int, format: ImageFormat) {
        self.uiImage = uiImage
        self.size = size
        self.format = format
    }
}

