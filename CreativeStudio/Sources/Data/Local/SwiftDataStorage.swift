// CreativeStudio/Sources/Data/Local/SwiftDataStorage.swift
import Foundation
import SwiftData
import Domain

final class SwiftDataStorage: GenerationRepository {
    private let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "CreativeStudio")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent store: $error)")
            }
        }
    }

    func saveProject(_ project: Project) async throws {
        try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                context.insert(project)
                do {
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchProjects() async throws -> [Project] {
        try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                let request = Project.fetchRequest()
                do {
                    let projects = try context.fetch(request)
                    continuation.resume(returning: projects)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func deleteProject(_ project: Project) async throws {
        try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                context.delete(project)
                do {
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func saveGenerationResult(_ result: GenerationResult) async throws {
        try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                context.insert(result)
                do {
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchGenerationResults(for project: Project) async throws -> [GenerationResult] {
        try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                let request = GenerationResult.fetchRequest()
                request.predicate = NSPredicate(format: "project == $", project)
                do {
                    let results = try context.fetch(request)
                    continuation.resume(returning: results)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}