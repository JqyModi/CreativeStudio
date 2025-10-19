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
            AppNavigationView()
                .environmentObject(appCoordinator)
        }
    }
}

struct AppNavigationView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $appCoordinator.navigationStack) {
            DashboardView(viewModel: DashboardViewModel())
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .dashboard:
                        DashboardView(viewModel: DashboardViewModel())
                    case .textGeneration:
                        TextGenerationView(viewModel: TextGenerationViewModel())
                    case .imageUpload:
                        ImageUploadView(viewModel: ImageUploadViewModel())
                    case .results:
                        ResultsView(viewModel: ResultsViewModel())
                    case .upgradeRequired:
                        Text("Upgrade Required")
                    }
                }
        }
    }
}
