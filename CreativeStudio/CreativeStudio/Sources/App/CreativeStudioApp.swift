//
//  CreativeStudioApp.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/8.
//

import SwiftUI

@main
struct CreativeStudioApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appCoordinator)
        }
    }
}
