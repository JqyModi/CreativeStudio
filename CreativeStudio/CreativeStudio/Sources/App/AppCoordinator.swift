// CreativeStudio/Sources/App/AppCoordinator.swift
import SwiftUI
import Combine
import UIKit

final class AppCoordinator: ObservableObject {
    @Published var userQuota: UserQuota
    @Published var currentProject: Project?
    @Published var navigationStack: [NavigationDestination] = [.dashboard]
    @Published var isQuotaExceeded: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var quotaTimer: Timer?
    
    // Make UserDefaultsStorage available to other parts of the app
    let userDefaultsStorage: UserDefaultsStorage

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
        
        // Start quota monitoring
        startQuotaMonitoring()
        
        // Setup notification observer for quota increments
        setupQuotaIncrementObserver()
    }
    
    deinit {
        quotaTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }

    func navigateTo(_ destination: NavigationDestination) {
        // Check quota for generation destinations
        if isGenerationDestination(destination) && !userQuota.canGenerate() {
            isQuotaExceeded = true
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
    
    func navigateToUpgrade() {
        navigateTo(.upgradeRequired)
    }
    
    func dismissQuotaExceededAlert() {
        isQuotaExceeded = false
    }

    func resetQuotaIfNeeded() {
        userQuota.resetIfNeeded()
        userDefaultsStorage.saveUserQuota(userQuota)
    }
    
    func incrementUsage() {
        userQuota.incrementUsage()
        userDefaultsStorage.saveUserQuota(userQuota)
        
        // Check if quota is now exceeded
        if !userQuota.canGenerate() {
            isQuotaExceeded = true
        }
    }
    
    func getRemainingQuota() -> Int {
        return userQuota.getRemainingQuota()
    }
    
    func getUsagePercentage() -> Double {
        return userQuota.getUsagePercentage()
    }
    
    func getTimeUntilReset() -> TimeInterval {
        return userQuota.getTimeUntilReset()
    }
    
    func formatTimeUntilReset() -> String {
        return userQuota.formatTimeUntilReset()
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
    
    private func setupQuotaIncrementObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUsageQuotaIncremented),
            name: .usageQuotaIncremented,
            object: nil
        )
    }
    
    private func startQuotaMonitoring() {
        // Check quota every minute
        quotaTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.resetQuotaIfNeeded()
        }
    }
    
    private func isGenerationDestination(_ destination: NavigationDestination) -> Bool {
        switch destination {
        case .textGeneration, .imageUpload:
            return true
        default:
            return false
        }
    }

    @objc private func handleVoiceOverStatusChanged() {
        print("VoiceOver status changed: \(UIAccessibility.isVoiceOverRunning)")
        // Update UI accessibility elements
    }

    @objc private func handleSwitchControlStatusChanged() {
        print("SwitchControl status changed: \(UIAccessibility.isSwitchControlRunning)")
        // Adjust focus management
    }
    
    @objc private func handleUsageQuotaIncremented() {
        incrementUsage()
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
    
    // Enhanced navigation with accessibility features
    func navigateWithAccessibilityAnnouncement(_ destination: NavigationDestination) {
        let announcement = getAccessibilityRoute(for: destination)
        UIAccessibility.post(notification: .announcement, argument: "导航到\(announcement)")
        navigateTo(destination)
    }
    
    // Quota status announcements for accessibility
    func announceQuotaStatus() {
        let remaining = userQuota.getRemainingQuota()
        let percentage = Int(userQuota.getUsagePercentage() * 100)
        let announcement = "今日剩余配额: \(remaining)次, 已使用: \(percentage)%"
        UIAccessibility.post(notification: .announcement, argument: announcement)
    }
}
