// CreativeStudio/Sources/Presentation/Dashboard/ViewModels/DashboardViewModel.swift
import SwiftUI
import Combine
// import Domain (removed - files are in same module)
// import Data (removed - files are in same module)

final class DashboardViewModel: ObservableObject {
    @Published var stats: DashboardStats = DashboardStats(creationCount: 0, inProgressCount: 0, completionRate: 0, resetTime: Date())
    @Published var projects: [Project] = []
    @Published var userQuota: UserQuota
    
    private let repository: GenerationRepository
    private let userDefaultsStorage: UserDefaultsStorage
    private var cancellables = Set<AnyCancellable>()

    init(
        repository: GenerationRepository = SwiftDataStorage(),
        userDefaultsStorage: UserDefaultsStorage = .init()
    ) {
        self.repository = repository
        self.userDefaultsStorage = userDefaultsStorage
        self.userQuota = userDefaultsStorage.loadUserQuota() ?? 
            UserQuota(dailyLimit: 50, usedToday: 0, resetTime: Date().addingTimeInterval(86400))
    }

    func loadDashboardData() {
        Task {
            do {
                // Load stats
                let projects = try await repository.fetchProjects()
                self.stats = calculateStats(from: projects)
                
                // Load recent projects
                self.projects = Array(projects.prefix(8))
                    .sorted(by: { $0.createdAt > $1.createdAt })
                
                // Reset quota if needed
                resetQuotaIfNeeded()
            } catch {
                print("Failed to load dashboard data: $error)")
            }
        }
    }

    func resetQuotaIfNeeded() {
        userQuota.resetIfNeeded()
        userDefaultsStorage.saveUserQuota(userQuota)
    }

    func sortProjects(by criterion: SortCriterion) {
        switch criterion {
        case .time:
            projects.sort { $0.createdAt > $1.createdAt }
        case .name:
            projects.sort { $0.name < $1.name }
        }
    }

    private func calculateStats(from projects: [Project]) -> DashboardStats {
        let total = projects.count
        let inProgress = projects.filter { $0.status == .inProgress }.count
        let completionRate = total > 0 ? Double(inProgress) / Double(total) : 0
        
        return DashboardStats(
            creationCount: total,
            inProgressCount: inProgress,
            completionRate: completionRate,
            resetTime: userQuota.resetTime
        )
    }
}

struct DashboardStats {
    let creationCount: Int
    let inProgressCount: Int
    let completionRate: Double
    let resetTime: Date
}

enum SortCriterion {
    case time, name
}
