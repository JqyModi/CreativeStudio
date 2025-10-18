// CreativeStudio/Sources/Domain/Repositories/GenerationRepository.swift
import Foundation
import SwiftData

protocol GenerationRepository {
    func saveProject(_ project: Project) async throws
    func fetchProjects() async throws -> [Project]
    func deleteProject(_ project: Project) async throws
    func saveGenerationResult(_ result: GenerationResult) async throws
    func fetchGenerationResults(for project: Project) async throws -> [GenerationResult]
}