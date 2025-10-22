//
//  ResultsView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/8.
//

import SwiftUI
import UIKit

// MARK: - ResultsView
struct ResultsView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = ResultsViewModel()
    
    let project: Project
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Quick regenerate button
//                    QuickRegenerateButtonView {
//                        // Regenerate content
//                        print("Regenerating content...")
//                    }
                    
                    // Result tabs
                    ResultTabsView(viewModel: viewModel)
                    
                    // Tab-specific content based on the project's generation results
                    ResultContentView(
                        project: project,
                        selectedTab: viewModel.selectedTab
                    )
                    .padding(10)
                    .background(
                        Color.white
                            .opacity(0.8)
                    )
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Export options
                    ExportOptionsView(
                        onSaveToAlbum: {
                            // Save to album
                        },
                        onCopyLink: {
                            // Copy link
                        },
                        onRegenerate: {
                            print("Regenerating content...")
                        }
                    )
                }
                .padding(.top, 10)
            }
        }
    }
}

// MARK: - Result Content View
struct ResultContentView: View {
    let project: Project
    let selectedTab: ResultTab
    
    var body: some View {
        Group {
            switch selectedTab {
            case .image:
                ImageResultsView(project: project)
            case .text:
                TextResultsView(project: project)
            case .combined:
                CombinedResultsView(project: project)
            case .derived, .relatedText, .style:
                OtherResultsView()
            }
        }
    }
}

// MARK: - Result Tab Enum
enum ResultTab: CaseIterable {
    case image
    case text
    case combined
    case derived
    case relatedText
    case style
    
    var title: String {
        switch self {
        case .image:
            return "图像"
        case .text:
            return "文案"
        case .combined:
            return "组合"
        case .derived:
            return "衍生图像"
        case .relatedText:
            return "相关文案"
        case .style:
            return "风格变化"
        }
    }
}

// MARK: - Results View Model
class ResultsViewModel: ObservableObject {
    @Published var selectedTab: ResultTab = .image
    
    func regenerateContent(for project: Project) {
        // Implementation for regenerating content
        print("Regenerating content for project: \(project.name)")
    }
}

#Preview {
    NavigationStack {
        ResultsView(project: Project(name: "Test Project"))
            .environmentObject(AppCoordinator())
    }
}
