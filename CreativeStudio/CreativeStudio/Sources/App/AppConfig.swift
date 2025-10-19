import Foundation

struct AppConfig {
    static let shared = AppConfig()
    
    // App configuration settings
    let dailyGenerationLimit: Int = 50
    let maxImageSize: Int = 20_000_000 // 20MB
    let maxFileCount: Int = 5
    let maxPromptLength: Int = 500
    let maxDescriptionLength: Int = 200
    
    private init() {}
}