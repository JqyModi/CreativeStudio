//
//  ResultsView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/8.
//

import SwiftUI

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
                    HStack {
                        Button(action: {
                            // Regenerate content
                            print("Regenerating content...")
                        }) {
                            Label("🔄 不满意？一键重新生成", systemImage: "arrow.clockwise")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.945, green: 0.945, blue: 0.953))
                        .cornerRadius(8)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Result tabs
                    HStack(spacing: 10) {
                        ForEach(ResultTab.allCases, id: \.self) { tab in
                            Button(action: {
                                viewModel.selectedTab = tab
                            }) {
                                Text(tab.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(
                                        viewModel.selectedTab == tab
                                        ? Color(red: 0.4, green: 0.498, blue: 0.918)
                                        : Color(red: 0.973, green: 0.973, blue: 0.98)
                                    )
                                    .foregroundColor(viewModel.selectedTab == tab ? .white : .primary)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Simple placeholder for tab content
                    VStack(spacing: 20) {
                        Text("Result Content")
                            .font(.title)
                            .padding()
                        
                        Text("Selected tab: \(viewModel.selectedTab.title)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(20)
                    .background(Color(red: 0.973, green: 0.973, blue: 0.98))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Export options
                    HStack(spacing: 10) {
                        Button(action: {
                            // Save to album
                        }) {
                            HStack {
                                Image(systemName: "tray.and.arrow.down")
                                Text("保存到相册")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                            )
                        }
                        
                        Button(action: {
                            // Copy link
                        }) {
                            HStack {
                                Image(systemName: "link")
                                Text("复制链接")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                            )
                        }
                        
                        Button(action: {
                            // Regenerate
                            print("Regenerating content...")
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("重新生成")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }
        }
    }
}

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