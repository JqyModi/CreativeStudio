// CreativeStudio/Sources/Data/Local/SwiftDataStorage.swift
import Foundation
import SwiftData

@Model
final class StoredProject {
    var id: UUID
    var name: String
    var createdAt: Date
    var status: ProjectStatus
    var results: [StoredGenerationResult]
    
    init(id: UUID = UUID(), name: String, createdAt: Date = Date(), status: ProjectStatus = .inProgress, results: [StoredGenerationResult] = []) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.status = status
        self.results = results
    }
}

@Model
final class StoredGenerationResult {
    var id: UUID
    var prompt: String
    var texts: [String]
    var images: [Data]
    var createdAt: Date
    
    init(id: UUID = UUID(), prompt: String, texts: [String] = [], images: [Data] = [], createdAt: Date = Date()) {
        self.id = id
        self.prompt = prompt
        self.texts = texts
        self.images = images
        self.createdAt = createdAt
    }
}

final class SwiftDataStorage: GenerationRepository {
    private var modelContainer: ModelContainer
    
    init() {
        let schema = Schema([
            StoredProject.self,
            StoredGenerationResult.self
        ])
        
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true) // For testing purposes
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    func saveProject(_ project: Project) async throws {
        let context = ModelContext(modelContainer)
        let storedProject = StoredProject(
            id: project.id,
            name: project.name,
            createdAt: project.createdAt,
            status: project.status
        )
        
        context.insert(storedProject)
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }

    func fetchProjects() async throws -> [Project] {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<StoredProject>()
        
        do {
            let storedProjects = try context.fetch(descriptor)
            return storedProjects.map { storedProject in
                Project(
                    id: storedProject.id,
                    name: storedProject.name,
                    createdAt: storedProject.createdAt,
                    status: storedProject.status
                )
            }
        } catch {
            throw error
        }
    }

    func saveGenerationResult(_ result: GenerationResult) async throws {
        let context = ModelContext(modelContainer)
        let storedResult = StoredGenerationResult(
            id: result.id,
            prompt: result.prompt,
            texts: result.texts,
            images: result.images,
            createdAt: result.createdAt
        )
        
        context.insert(storedResult)
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    // Implementation for other required methods
    func generateText(prompt: String, parameters: GenerationParams) async throws -> TextResult {
        // This would typically call the text generation service
        // For now, return a mock result
        return TextResult(text: "Mock generated text", tokensUsed: 0)
    }
    
    func generateImage(prompt: String, parameters: ImageGenerationParams) async throws -> ImageResult {
        // This would typically call the image generation service
        // For now, return a mock result
        return ImageResult(image: Data(), prompt: prompt)
    }
}