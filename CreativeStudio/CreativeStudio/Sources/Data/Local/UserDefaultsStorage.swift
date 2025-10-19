import Foundation

final class UserDefaultsStorage {
    private let userDefaults = UserDefaults.standard
    private let userQuotaKey = "userQuota"
    private let navigationHistoryKey = "navigationHistory"

    func loadUserQuota() -> UserQuota? {
        guard let data = userDefaults.data(forKey: userQuotaKey) else { return nil }
        return try? JSONDecoder().decode(UserQuota.self, from: data)
    }

    func saveUserQuota(_ quota: UserQuota) {
        if let data = try? JSONEncoder().encode(quota) {
            userDefaults.set(data, forKey: userQuotaKey)
        }
    }

    func loadNavigationHistory() -> [NavigationDestination]? {
        guard let data = userDefaults.data(forKey: navigationHistoryKey) else { return nil }
        return try? JSONDecoder().decode([NavigationDestination].self, from: data)
    }

    func saveNavigationHistory(_ history: [NavigationDestination]) {
        if let data = try? JSONEncoder().encode(history) {
            userDefaults.set(data, forKey: navigationHistoryKey)
        }
    }
}
