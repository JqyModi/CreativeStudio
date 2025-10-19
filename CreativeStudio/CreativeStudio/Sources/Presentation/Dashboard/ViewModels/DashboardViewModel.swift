// CreativeStudio/Sources/Presentation/Dashboard/ViewModels/DashboardViewModel.swift
import SwiftUI
import Combine

final class DashboardViewModel: ObservableObject {
    @Published var stats: DashboardStats = DashboardStats(creationCount: 0, inProgressCount: 0, completionRate: 0, contentTypeDistribution: [:])
    @Published var projects: [Project] = []
    @Published var userQuota: UserQuota
    @Published var weeklyCompletionRates: [Double] = []
    
    private let textGenerationUseCase: TextGenerationUseCase
    private let imageGenerationUseCase: ImageGenerationUseCase
    private let repository: GenerationRepository
    private let userDefaultsStorage: UserDefaultsStorage
    private var cancellables = Set<AnyCancellable>()
    
    // Timer for updating countdown
    private var countdownTimer: Timer?

    init(
        textGenerationUseCase: TextGenerationUseCase = TextGenerationUseCase(
            service: FoundationModelsService(),
            repository: SwiftDataStorage()
        ),
        imageGenerationUseCase: ImageGenerationUseCase = ImageGenerationUseCase(
            service: ImagePlaygroundService(),
            repository: SwiftDataStorage()
        ),
        repository: GenerationRepository = SwiftDataStorage(),
        userDefaultsStorage: UserDefaultsStorage = .init()
    ) {
        self.textGenerationUseCase = textGenerationUseCase
        self.imageGenerationUseCase = imageGenerationUseCase
        self.repository = repository
        self.userDefaultsStorage = userDefaultsStorage
        self.userQuota = userDefaultsStorage.loadUserQuota() ?? 
            UserQuota(dailyLimit: 50, usedToday: 0, resetTime: Date().addingTimeInterval(86400))
        
        // Start countdown timer
        startCountdownTimer()
    }
    
    deinit {
        countdownTimer?.invalidate()
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
                
                // Calculate weekly completion rates
                self.weeklyCompletionRates = calculateWeeklyCompletionRates(from: projects)
                
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
    
    func filterProjects(by status: ProjectStatus?) {
        // This would filter projects by status if needed
    }
    
    private func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // This will trigger view updates automatically
            // The actual countdown calculation is done in the view
        }
    }

    private func calculateStats(from projects: [Project]) -> DashboardStats {
        let total = projects.count
        let inProgress = projects.filter { $0.status == .inProgress }.count
        let completionRate = total > 0 ? Double(total - inProgress) / Double(total) : 0
        
        // Calculate content type distribution
        var contentTypeDistribution: [String: Double] = [:]
        let textProjects = projects.filter { $0.type == .text }.count
        let imageProjects = projects.filter { $0.type == .image }.count
        let mixedProjects = projects.filter { $0.type == .mixed }.count
        
        if total > 0 {
            contentTypeDistribution["文字"] = Double(textProjects) / Double(total)
            contentTypeDistribution["图像"] = Double(imageProjects) / Double(total)
            contentTypeDistribution["混合"] = Double(mixedProjects) / Double(total)
        }
        
        return DashboardStats(
            creationCount: total,
            inProgressCount: inProgress,
            completionRate: completionRate,
            contentTypeDistribution: contentTypeDistribution
        )
    }
    
    private func calculateWeeklyCompletionRates(from projects: [Project]) -> [Double] {
        // Calculate completion rates for the past 7 days
        let calendar = Calendar.current
        var rates: [Double] = []
        
        for dayOffset in 0..<7 {
            let targetDate = calendar.date(byAdding: .day, value: -dayOffset, to: Date())!
            let startOfDay = calendar.startOfDay(for: targetDate)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let dailyProjects = projects.filter { project in
                project.createdAt >= startOfDay && project.createdAt < endOfDay
            }
            
            let total = dailyProjects.count
            let completed = dailyProjects.filter { $0.status == .completed }.count
            
            let rate = total > 0 ? Double(completed) / Double(total) : 0
            rates.append(rate)
        }
        
        // Return in chronological order (oldest first)
        return rates.reversed()
    }
}

struct DashboardStats {
    let creationCount: Int
    let inProgressCount: Int
    let completionRate: Double
    let contentTypeDistribution: [String: Double]
}

enum SortCriterion {
    case time, name
}

