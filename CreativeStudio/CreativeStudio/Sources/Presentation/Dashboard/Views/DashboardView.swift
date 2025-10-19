import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 20) {
                        // User statistics with pie chart
                        userStatisticsView
                        
                        // Usage quota with progress bar and countdown
                        usageQuotaView
                        
                        // Quick creation entrance
                        quickCreationView
                        
                        // History template recommendation
                        historyTemplateView
                        
                        // Recent projects list
                        recentProjectsView
                    }
                    .padding()
                }
                
                // Floating action button
                floatingActionButton
            }
            .navigationTitle("仪表盘")
            .onAppear {
                viewModel.loadDashboardData()
            }
        }
    }
    
    private var userStatisticsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("用户统计数据")
                .font(.headline)
            
            // Pie chart for different content types
            HStack {
                // Pie chart representation (simplified)
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: 0.3)
                        .stroke(Color.blue, lineWidth: 20)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0.3, to: 0.7)
                        .stroke(Color.green, lineWidth: 20)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0.7, to: 1.0)
                        .stroke(Color.orange, lineWidth: 20)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 100, height: 100)
                    
                    Text("内容\n占比")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                }
                
                // Legend
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                        Text("文字 (30%)")
                            .font(.caption)
                    }
                    HStack {
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                        Text("图像 (40%)")
                            .font(.caption)
                    }
                    HStack {
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 12, height: 12)
                        Text("混合 (30%)")
                            .font(.caption)
                    }
                }
            }
            
            // In-progress projects list
            VStack(alignment: .leading, spacing: 8) {
                Text("进行中项目列表")
                    .font(.headline)
                
                ForEach(viewModel.projects.filter { $0.status == .inProgress }) { project in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(project.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("最后修改: \(project.createdAt, formatter: dateFormatter)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Progress bar for each project
                        ProgressView(value: 0.5) // Simplified progress
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(width: 80)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // Completion rate trend chart
            VStack(alignment: .leading, spacing: 8) {
                Text("项目完成率统计")
                    .font(.headline)
                
                // Weekly trend (simplified bar chart)
                HStack(alignment: .bottom, spacing: 4) {
                    ForEach(0..<7) { day in
                        VStack {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: CGFloat(20 + day * 10)) // Simplified heights
                            
                            Text("周\(day+1)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(height: 100)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var usageQuotaView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("使用限制")
                .font(.headline)
            
            HStack {
                // Progress bar
                VStack(alignment: .leading, spacing: 8) {
                    let remaining = max(0, appCoordinator.userQuota.dailyLimit - appCoordinator.userQuota.usedToday)
                    let percentage = appCoordinator.userQuota.dailyLimit > 0 ? 
                        Double(remaining) / Double(appCoordinator.userQuota.dailyLimit) : 0
                    
                    Text("\(remaining)/\(appCoordinator.userQuota.dailyLimit)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    ProgressView(value: 1.0 - percentage)
                        .progressViewStyle(LinearProgressViewStyle())
                        .accentColor(remaining < 10 ? .red : .green)
                }
                
                Spacer()
                
                // Countdown timer
                VStack(alignment: .trailing, spacing: 4) {
                    Text("次日重置")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(calculateCountdown())
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            
            // Upgrade prompt when approaching limit
            if appCoordinator.userQuota.usedToday > Int(Double(appCoordinator.userQuota.dailyLimit) * 0.8) {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                    
                    Text("接近限额，考虑升级账户")
                        .font(.caption)
                    
                    Spacer()
                    
                    Button("立即升级") {
                        // Navigate to upgrade
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.orange.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var quickCreationView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("快速创作入口")
                .font(.headline)
            
            HStack(spacing: 20) {
                Button(action: {
                    appCoordinator.navigateToTextGeneration()
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "textformat")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.blue)
                            .clipShape(Circle())
                        
                        Text("文字生成")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
                
                Button(action: {
                    appCoordinator.navigateToImageUpload()
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.green)
                            .clipShape(Circle())
                        
                        Text("图像上传")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
                
                Button(action: {
                    // Voice input action
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "mic")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.purple)
                            .clipShape(Circle())
                        
                        Text("语音输入")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var historyTemplateView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("历史模板推荐")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { index in
                        Button(action: {
                            // Apply template
                        }) {
                            VStack(alignment: .leading, spacing: 8) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 120, height: 80)
                                    .cornerRadius(8)
                                
                                Text("模板 \(index + 1)")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            .padding(8)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var recentProjectsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("最近项目列表")
                    .font(.headline)
                
                Spacer()
                
                Menu("筛选") {
                    Button("全部") {
                        // Filter all projects
                    }
                    Button("进行中") {
                        // Filter in-progress projects
                    }
                    Button("已完成") {
                        // Filter completed projects
                    }
                }
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                ForEach(viewModel.projects.prefix(8)) { project in
                    ProjectCardView(project: project) {
                        // Navigate to project results
                    }
                }
            }
            
            // Sorting options
            HStack {
                Button(action: {
                    viewModel.sortProjects(by: .time)
                }) {
                    Text("按时间排序")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray5))
                        .cornerRadius(16)
                }
                
                Button(action: {
                    viewModel.sortProjects(by: .name)
                }) {
                    Text("按名称排序")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray5))
                        .cornerRadius(16)
                }
                
                Spacer()
            }
        }
    }
    
    private var floatingActionButton: some View {
        Button(action: {
            // Show quick creation options
        }) {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .padding(16)
        .onHover { hovering in
            // Add hover animation if needed
        }
    }
    
    private func calculateCountdown() -> String {
        let calendar = Calendar.current
        let now = Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
        let startOfTomorrow = calendar.startOfDay(for: tomorrow)
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: now, to: startOfTomorrow)
        
        if let hours = components.hour, let minutes = components.minute, let seconds = components.second {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
        return "24:00:00"
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
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
                .clipShape(Circle())
            
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