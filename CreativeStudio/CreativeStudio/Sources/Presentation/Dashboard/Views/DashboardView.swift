//
//  DashboardView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/8.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with title
                VStack(spacing: 10) {
                    Text("创意内容工作室")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.42, blue: 0.42), Color(red: 0.306, green: 0.8, blue: 0.788)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("AI驱动的视觉内容创作平台")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.525, green: 0.525, blue: 0.545))
                }
//                    .padding(.top, 20)
                
                // Stats grid
                VStack(spacing: 15) {
                    Text("统计概览")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                        StatCard(title: "本月创作", value: "24")
                        StatCard(title: "进行中项目", value: "8")
                    }
                    .padding(.horizontal)
                }
                
                // Usage bar
                VStack(spacing: 10) {
                    HStack {
                        Text("今日剩余生成次数")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.525, green: 0.525, blue: 0.545))
                        
                        Spacer()
                        
                        Text("\(appCoordinator.userQuota.remaining)/\(appCoordinator.userQuota.dailyLimit)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                    }
                    .padding(.horizontal)
                    
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(red: 0.933, green: 0.933, blue: 0.941))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(LinearGradient(
                                colors: [Color(red: 0.306, green: 0.8, blue: 0.788), Color(red: 0.4, green: 0.498, blue: 0.918)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: CGFloat(appCoordinator.userQuota.usagePercentage) * 200, height: 8)
                    }
                    .padding(.horizontal)
                    
                    Text("免费版")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.525, green: 0.525, blue: 0.545))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                }
                
                // Quick creation options
                VStack(spacing: 25) {
                    Text("快速创作")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    HStack(spacing: 15) {
                        CreationOptionCard(
                            icon: "📝",
                            title: "文字生成",
                            action: { appCoordinator.navigateToTextGeneration() }
                        )
                        
                        CreationOptionCard(
                            icon: "🖼️",
                            title: "图像生成",
                            action: { appCoordinator.navigateToImageUpload() }
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Recent projects
                VStack(spacing: 15) {
                    HStack {
                        Text("最近项目")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            appCoordinator.navigateToProjectList()
                        } label: {
                            Text("全部")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                        }

                    }
                    .padding(.horizontal)
                    
                    ForEach(viewModel.recentProjects, id: \.id) { project in
                        ProjectRowView(project: project)
                    }
                }
            }
//                .padding(.vertical, 20)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("仪表盘")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
        .onAppear {
            viewModel.loadDashboardData()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color(red: 0.525, green: 0.525, blue: 0.545))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(15)
        .background(Color(red: 0.973, green: 0.973, blue: 0.98))
        .cornerRadius(12)
    }
}

struct CreationOptionCard: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Text(icon)
                    .font(.system(size: 32))
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(20)
            .background(Color(red: 0.973, green: 0.973, blue: 0.98))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 0.4, green: 0.498, blue: 0.918), lineWidth: 0)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ProjectRowView: View {
    let project: Project
    
    var body: some View {
        HStack {
            // Project icon with gradient background
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(
                        colors: [Color(red: 0.306, green: 0.8, blue: 0.788), Color(red: 0.4, green: 0.498, blue: 0.918)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 40, height: 40)
                
                Text(getProjectIcon(for: project.name))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(project.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(getRelativeTime(for: project.createdAt))
                    .font(.caption)
                    .foregroundColor(Color(red: 0.525, green: 0.525, blue: 0.545))
            }
            
            Spacer()
            
            // Status badge
            ZStack {
                Capsule()
                    .fill(Color(red: 0.851, green: 0.851, blue: 0.851))
                    .frame(height: 20)
                
                Text(project.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 60)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.clear)
    }
    
    private func getProjectIcon(for name: String) -> String {
        if name.contains("节日") || name.contains("海报") {
            return "🎉"
        } else if name.contains("产品") || name.contains("展示") {
            return "📸"
        } else if name.contains("博客") || name.contains("封面") {
            return "📝"
        } else {
            return "🎨"
        }
    }
    
    private func getRelativeTime(for date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .day, .weekOfYear], from: date, to: now)

        if let hour = components.hour, hour < 24 {
            return "\(hour)小时前"
        } else if let day = components.day, day == 1 {
            return "昨天"
        } else if let day = components.day, day < 7 {
            return "\(day)天前"
        } else {
            return "\(calendar.component(.month, from: date))月\(calendar.component(.day, from: date))日"
        }
    }
}

struct ProjectListView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            Text("项目列表")
        }
    }
}

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var stats = DashboardStats()
    @Published var projects: [Project] = []
    @Published var recentProjects: [Project] = []
    
    func loadDashboardData() {
        // Load recent projects
        recentProjects = [
            Project(name: "节日营销海报", createdAt: Date().addingTimeInterval(-2*60*60), status: .inProgress),
            Project(name: "产品展示图", createdAt: Date().addingTimeInterval(-24*60*60), status: .completed),
            Project(name: "博客封面设计", createdAt: Date().addingTimeInterval(-3*24*60*60), status: .completed)
        ]
    }
}

struct DashboardStats {
    var monthlyCreations: Int = 24
    var projectsInProgress: Int = 8
    var usagePercentage: Double = 0.3
}

#Preview {
    NavigationStack {
        DashboardView()
            .environmentObject(AppCoordinator())
    }
}
