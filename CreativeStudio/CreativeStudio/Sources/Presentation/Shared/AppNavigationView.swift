//
//  AppNavigationView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/20.
//

import SwiftUI

struct AppNavigationView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $appCoordinator.navigationPath) {
            DashboardView()
                .environmentObject(appCoordinator)
                .navigationDestination(for: ContentViewType.self) { destination in
                    switch destination {
                    case .dashboard:
                        DashboardView()
                            .environmentObject(appCoordinator)
                    case .textGeneration:
                        TextGenerationView()
                            .environmentObject(appCoordinator)
                    case .imageUpload:
                        ImageUploadView()
                            .environmentObject(appCoordinator)
                    case .results:
                        if let project = appCoordinator.currentProject {
                            ResultsViewV2(project: project)
                                .environmentObject(appCoordinator)
                        } else {
                            // Fallback if no project is set
                            DashboardView()
                                .environmentObject(appCoordinator)
                        }
                    case .projectList:
                        ProjectListView()
                            .environmentObject(appCoordinator)
                    }
                }
        }
        .tint(.white)
    }
}

#Preview {
    AppNavigationView()
        .environmentObject(AppCoordinator())
}
