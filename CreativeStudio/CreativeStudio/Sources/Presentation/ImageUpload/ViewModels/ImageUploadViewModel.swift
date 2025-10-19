import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

final class ImageUploadViewModel: ObservableObject {
    @Published var selectedImages: [Data] = []
    @Published var descriptionText: String = ""
    @Published var selectedStyle: ArtStyle = .defaultStyle
    @Published var styleIntensity: Double = 0.7
    @Published var isGenerating: Bool = false
    @Published var isDragOver: Bool = false
    @Published var progress: Double = 0.0
    @Published var estimatedCompletionTime: TimeInterval = 0
    @Published var enableReferenceMixing: Bool = false
    @Published var colorSaturation: Double = 1.0
    @Published var descriptionSuggestions: [String] = []
    
    private let imageGenerationUseCase: ImageGenerationUseCase
    private let repository: GenerationRepository
    private var progressTimer: Timer?
    
    init(
        imageGenerationUseCase: ImageGenerationUseCase = ImageGenerationUseCase(
            service: ImagePlaygroundService(),
            repository: SwiftDataStorage()
        ),
        repository: GenerationRepository = SwiftDataStorage()
    ) {
        self.imageGenerationUseCase = imageGenerationUseCase
        self.repository = repository
        
        // Generate initial description suggestions
        self.descriptionSuggestions = [
            "风景照片处理",
            "人物肖像美化",
            "产品展示图",
            "艺术风格转换",
            "复古照片修复"
        ]
    }
    
    func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        do {
            if let imageData = try await item.loadTransferable(type: Data.self) {
                // Validate image size and format
                guard validateImageSize(imageData) else {
                    print("Image size exceeds limit")
                    return
                }
                
                guard validateImageFormat(imageData) else {
                    print("Invalid image format")
                    return
                }
                
                // Check file count limit
                guard selectedImages.count < 5 else {
                    print("Maximum file count exceeded")
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.selectedImages.append(imageData)
                }
            }
        } catch {
            print("Error loading image: $error)")
        }
    }
    
    func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
    
    func clearSelectedImages() {
        selectedImages.removeAll()
    }
    
    func generateContent() async {
        guard !selectedImages.isEmpty, !isGenerating else { return }
        
        isGenerating = true
        progress = 0.0
        estimatedCompletionTime = Double(selectedImages.count) * Double.random(in: 10...30)
        
        // Start progress simulation
        startProgressSimulation()
        
        do {
            // Create image files from data
            var imageFiles: [any ImageFileProtocol] = []
            for imageData in selectedImages {
                if let uiImage = UIImage(data: imageData) {
                    let imageFile = UploadedImageFile(uiImage: uiImage, size: imageData.count, format: .jpg)
                    imageFiles.append(imageFile)
                }
            }
            
            // Generate parameters
            let params = ImageGenerationParams(
                width: 1024,
                height: 1024,
                style: selectedStyle
            )
            
            let results = try await imageGenerationUseCase.execute(
                files: imageFiles,
                parameters: params
            )
            
            // Stop progress simulation
            stopProgressSimulation()
            
            DispatchQueue.main.async { [weak self] in
                self?.isGenerating = false
                self?.progress = 1.0
                self?.estimatedCompletionTime = 0
                
                // Increment usage quota
                self?.incrementUsageQuota()
                
                print("Generated \(results.count) images")
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
    
    func cancelGeneration() {
        isGenerating = false
        stopProgressSimulation()
    }
    
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        // Handle file drops
        for provider in providers {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (item, error) in
                if let url = item as? URL {
                    self.processDroppedFile(url: url)
                }
            }
        }
        return true
    }
    
    private func processDroppedFile(url: URL) {
        do {
            let imageData = try Data(contentsOf: url)
            
            // Validate image
            guard validateImageSize(imageData) else {
                print("Dropped image size exceeds limit")
                return
            }
            
            guard validateImageFormat(imageData) else {
                print("Dropped image format not supported")
                return
            }
            
            // Check file count limit
            guard selectedImages.count < 5 else {
                print("Maximum file count exceeded")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.selectedImages.append(imageData)
            }
        } catch {
            print("Error processing dropped file: $error)")
        }
    }
    
    private func validateImageSize(_ imageData: Data) -> Bool {
        return imageData.count <= 20_000_000 // 20MB limit
    }
    
    private func validateImageFormat(_ imageData: Data) -> Bool {
        // Simple validation based on file signature
        guard imageData.count >= 4 else { return false }
        
        let bytes = [UInt8](imageData.prefix(4))
        
        // JPEG signature: FF D8 FF
        if bytes.starts(with: [0xFF, 0xD8, 0xFF]) {
            return true
        }
        
        // PNG signature: 89 50 4E 47
        if bytes == [0x89, 0x50, 0x4E, 0x47] {
            return true
        }
        
        return false
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
    
    private func incrementUsageQuota() {
        NotificationCenter.default.post(name: .usageQuotaIncremented, object: nil)
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