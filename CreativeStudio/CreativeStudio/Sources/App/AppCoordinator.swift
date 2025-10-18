// CreativeStudio/Sources/App/AppCoordinator.swift
import SwiftUI
import Combine
//import UIKit
// import Domain (removed - files are in same module)

final class AppCoordinator: ObservableObject {
    @Published var userQuota: UserQuota
    @Published var currentProject: Project?
    @Published var navigationStack: [NavigationDestination] = [.dashboard]
    
    private let userDefaultsStorage: UserDefaultsStorage
    private var cancellables = Set<AnyCancellable>()

    init(userDefaultsStorage: UserDefaultsStorage = .init()) {
        self.userDefaultsStorage = userDefaultsStorage
        self.userQuota = userDefaultsStorage.loadUserQuota() ?? 
            UserQuota(dailyLimit: 50, usedToday: 0, resetTime: Date().addingTimeInterval(86400))
        
        // Restore navigation history
        if let savedHistory = userDefaultsStorage.loadNavigationHistory() {
            navigationStack = savedHistory
        }
        
        // Setup accessibility observers
        setupAccessibilityObservers()
    }

    func navigateTo(_ destination: NavigationDestination) {
        // Check quota for generation destinations
        if case .textGeneration = destination, !userQuota.canGenerate() {
            navigationStack.append(.upgradeRequired)
            return
        }
        
        navigationStack.append(destination)
        saveNavigationState()
    }

    func navigateBack() {
        guard navigationStack.count > 1 else { return }
        navigationStack.removeLast()
        saveNavigationState()
    }

    func navigateToTextGeneration() {
        navigateTo(.textGeneration)
    }

    func navigateToImageUpload() {
        navigateTo(.imageUpload)
    }

    func navigateToResults(for project: Project) {
        self.currentProject = project
        navigateTo(.results)
    }

    func resetQuotaIfNeeded() {
        userQuota.resetIfNeeded()
        userDefaultsStorage.saveUserQuota(userQuota)
    }

    private func saveNavigationState() {
        userDefaultsStorage.saveNavigationHistory(navigationStack)
    }

    private func setupAccessibilityObservers() {
        // Monitor VoiceOver status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleVoiceOverStatusChanged),
            name: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil
        )
        
        // Monitor Switch Control
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSwitchControlStatusChanged),
            name: UIAccessibility.switchControlStatusDidChangeNotification,
            object: nil
        )
    }

    @objc private func handleVoiceOverStatusChanged() {
        print("VoiceOver status changed: $UIAccessibility.isVoiceOverRunning)")
        // Update UI accessibility elements
    }

    @objc private func handleSwitchControlStatusChanged() {
        print("SwitchControl status changed: $UIAccessibility.isSwitchControlRunning)")
        // Adjust focus management
    }
}

enum NavigationDestination: Hashable, Codable {
    case dashboard
    case textGeneration
    case imageUpload
    case results
    case upgradeRequired
}

// MARK: - Accessibility Support
extension AppCoordinator {
    func getAccessibilityRoute(for destination: NavigationDestination) -> String {
        switch destination {
        case .dashboard: return "仪表盘"
        case .textGeneration: return "文字生成"
        case .imageUpload: return "图像上传"
        case .results: return "结果展示"
        case .upgradeRequired: return "升级账户"
        }
    }
    
    func getNavigationHistory() -> [String] {
        navigationStack.prefix(5).map { getAccessibilityRoute(for: $0) }
    }
}
