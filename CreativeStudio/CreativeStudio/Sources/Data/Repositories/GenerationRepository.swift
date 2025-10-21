//
//  GenerationRepository.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/20.
//

import Foundation

protocol GenerationRepository {
    func saveProject(_ project: Project) throws
    func fetchProjects() throws -> [Project]
    func saveGenerationResult(_ result: GenerationResult) throws
    func fetchGenerationResults(for project: Project) throws -> [GenerationResult]
}

// For now, using in-memory storage as a placeholder
class MockGenerationRepository: GenerationRepository {
    private var projects: [Project] = []
    
    func saveProject(_ project: Project) throws {
        projects.append(project)
    }
    
    func fetchProjects() throws -> [Project] {
        return projects
    }
    
    func saveGenerationResult(_ result: GenerationResult) throws {
        // In a real implementation, this would save to persistent storage
    }
    
    func fetchGenerationResults(for project: Project) throws -> [GenerationResult] {
        // In a real implementation, this would fetch from persistent storage
        return project.generationResults
    }
}