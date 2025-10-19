import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
//        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats grid
                    statsGridView
                    
                    // Quick actions
                    quickActionsView
                    
                    // Recent projects
                    recentProjectsView
                }
                .padding()
            }
            .navigationTitle("仪表盘")
            .onAppear {
                viewModel.loadDashboardData()
            }
//        }
    }
    
    private var statsGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            // Creation count card
            StatsCardView(title: "本月创作", value: "\(viewModel.stats.creationCount)", icon: "doc.fill")
            
            // In progress count card
            StatsCardView(title: "进行中", value: "\(viewModel.stats.inProgressCount)", icon: "clock.fill")
            
            // Completion rate card
            StatsCardView(title: "完成率", value: "\(Int(viewModel.stats.completionRate * 100))%", icon: "chart.pie.fill")
            
            // Usage quota card
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "gauge.with.dots.needle.67percent")
                        .foregroundColor(.blue)
                    Text("使用限制")
                        .font(.headline)
                }
                
                VStack(alignment: .leading) {
                    let remaining = max(0, appCoordinator.userQuota.dailyLimit - appCoordinator.userQuota.usedToday)
                    Text("\(remaining)/\(appCoordinator.userQuota.dailyLimit)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    ProgressView(value: Double(appCoordinator.userQuota.usedToday), total: Double(appCoordinator.userQuota.dailyLimit))
                        .progressViewStyle(LinearProgressViewStyle())
                        .accentColor(remaining < 10 ? .red : .green)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var quickActionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("快速创作")
                .font(.headline)
            
            HStack {
                Button(action: {
                    appCoordinator.navigateToTextGeneration()
                }) {
                    QuickActionCard(icon: "textformat", title: "文字生成")
                }
                
                Button(action: {
                    appCoordinator.navigateToImageUpload()
                }) {
                    QuickActionCard(icon: "photo", title: "图像上传")
                }
                
                Button(action: {
                    // Voice input action
                }) {
                    QuickActionCard(icon: "mic", title: "语音输入")
                }
            }
        }
    }
    
    private var recentProjectsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("最近项目")
                    .font(.headline)
                
                Spacer()
                
                Menu("排序") {
                    Button("按时间") {
                        viewModel.sortProjects(by: .time)
                    }
                    Button("按名称") {
                        viewModel.sortProjects(by: .name)
                    }
                }
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                ForEach(viewModel.projects) { project in
                    ProjectCardView(project: project) {
                        // Navigate to project results
                    }
                }
            }
        }
    }
}

struct StatsCardView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.blue)
                .cornerRadius(20)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ProjectCardView: View {
    let project: Project
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Project name
                Text(project.name)
                    .font(.headline)
                    .lineLimit(1)
                
                // Status badge
                HStack {
                    Circle()
                        .fill(projectStatusColor)
                        .frame(width: 8, height: 8)
                    Text(projectStatusText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Date
                Text(project.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var projectStatusColor: Color {
        switch project.status {
        case .inProgress: return .yellow
        case .completed: return .green
        case .failed: return .red
        }
    }
    
    private var projectStatusText: String {
        switch project.status {
        case .inProgress: return "进行中"
        case .completed: return "已完成"
        case .failed: return "失败"
        }
    }
}

#Preview {
    DashboardView(viewModel: DashboardViewModel())
        .environmentObject(AppCoordinator())
}
