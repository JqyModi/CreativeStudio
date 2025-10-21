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
                    
                    // Tab-specific content based on the project's generation results
                    VStack(spacing: 20) {
                        switch viewModel.selectedTab {
                        case .image:
                            // Image results
                            if let firstResult = project.generationResults.first,
                               !firstResult.images.isEmpty {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                                    ForEach(0..<min(firstResult.images.count, 4), id: \.self) { index in
                                        AsyncDataImage(data: firstResult.images[index])
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: .infinity, maxHeight: 200)
                                            .clipped()
                                            .cornerRadius(8)
                                    }
                                }
                            } else {
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                    Text("暂无图像结果")
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxHeight: 200)
                            }
                            
                        case .text:
                            // Text results
                            if let firstResult = project.generationResults.first,
                               !firstResult.texts.isEmpty {
                                VStack(alignment: .leading, spacing: 15) {
                                    ForEach(firstResult.texts.indices, id: \.self) { index in
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("文案 \(index + 1)")
                                                .font(.headline)
                                                .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                                            
                                            Text(firstResult.texts[index])
                                                .font(.body)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                                        )
                                    }
                                }
                            } else {
                                VStack {
                                    Image(systemName: "doc.text")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                    Text("暂无文案结果")
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxHeight: 200)
                            }
                            
                        case .combined:
                            // Combined content - showing both text and images
                            VStack(alignment: .leading, spacing: 15) {
                                if let firstResult = project.generationResults.first {
                                    // Show prompt
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("原始提示词")
                                            .font(.headline)
                                            .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                                        
                                        Text(firstResult.prompt)
                                            .font(.body)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                                    )
                                    
                                    // Show generated texts
                                    if !firstResult.texts.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("生成文案")
                                                .font(.headline)
                                                .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                                            
                                            ForEach(firstResult.texts.prefix(2), id: \.self) { text in
                                                Text(text)
                                                    .font(.body)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding()
                                                    .background(Color.white)
                                                    .cornerRadius(8)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                                                    )
                                            }
                                        }
                                    }
                                    
                                    // Show generated images
                                    if !firstResult.images.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("生成图像")
                                                .font(.headline)
                                                .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                                            
                                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                                                ForEach(0..<min(firstResult.images.count, 2), id: \.self) { index in
                                                    AsyncDataImage(data: firstResult.images[index])
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(maxWidth: .infinity, maxHeight: 150)
                                                        .clipped()
                                                        .cornerRadius(8)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        case .derived, .relatedText, .style:
                            // For other tabs, show a message or future implementation
                            VStack {
                                Image(systemName: "rectangle.dashed")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                Text("此功能正在开发中")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxHeight: 200)
                        }
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