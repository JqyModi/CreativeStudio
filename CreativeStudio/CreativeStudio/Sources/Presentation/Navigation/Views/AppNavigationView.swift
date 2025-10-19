import SwiftUI

struct AppNavigationView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @State private var selectedTab: NavigationTab = .dashboard
    @State private var isShowingCreateSheet = false
    @State private var isShowingUpgradeSheet = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Dashboard tab
                NavigationView {
                    DashboardView(viewModel: DashboardViewModel())
                        .navigationTitle("仪表盘")
                        .navigationBarTitleDisplayMode(.large)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                TopNavigationBar(title: "仪表盘")
                            }
                        }
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("首页")
                }
                .tag(NavigationTab.dashboard)
                
                // Projects tab
                NavigationView {
                    Text("项目列表")
                        .navigationTitle("项目")
                        .navigationBarTitleDisplayMode(.large)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                TopNavigationBar(title: "项目")
                            }
                        }
                }
                .tabItem {
                    Image(systemName: "folder")
                    Text("项目")
                }
                .tag(NavigationTab.projects)
                
                // Messages tab (placeholder)
                NavigationView {
                    Text("消息中心")
                        .navigationTitle("消息")
                        .navigationBarTitleDisplayMode(.large)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                TopNavigationBar(title: "消息")
                            }
                        }
                }
                .tabItem {
                    Image(systemName: "message")
                    Text("消息")
                }
                .tag(NavigationTab.messages)
                
                // Profile tab
                NavigationView {
                    Text("个人中心")
                        .navigationTitle("我的")
                        .navigationBarTitleDisplayMode(.large)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                TopNavigationBar(title: "我的")
                            }
                        }
                }
                .tabItem {
                    Image(systemName: "person")
                    Text("我的")
                }
                .tag(NavigationTab.profile)
            }
            .overlay(
                // Floating action button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingCreateSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding()
                        .sheet(isPresented: $isShowingCreateSheet) {
                            CreationOptionsSheet(isPresented: $isShowingCreateSheet)
                                .presentationDetents([.medium, .large])
                        }
                    }
                }
            )
            
            // Overlay for upgrade sheet
            if appCoordinator.isQuotaExceeded {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        appCoordinator.dismissQuotaExceededAlert()
                    }
                
                UpgradeRequiredView()
                    .frame(maxWidth: 350, maxHeight: 500)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .padding()
            }
        }
        .onChange(of: appCoordinator.isQuotaExceeded) { newValue in
            if newValue {
                isShowingUpgradeSheet = true
            }
        }
    }
}

// MARK: - Supporting Views
struct TopNavigationBar: View {
    let title: String
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        HStack {
            // Logo or app icon
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundColor(.blue)
            
            // Title
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            // Quota indicator
            Button(action: {
                appCoordinator.announceQuotaStatus()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                    Text("\(appCoordinator.getRemainingQuota())")
                        .font(.caption)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(
                            appCoordinator.getUsagePercentage() > 0.8 ? 
                            Color.red.opacity(0.2) : 
                            Color.green.opacity(0.2)
                        )
                )
            }
            
            // Notification bell
            Button(action: {
                // Navigate to notifications
            }) {
                Image(systemName: "bell")
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
    }
}

struct CreationOptionsSheet: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Sheet header
                HStack {
                    Spacer()
                    Text("新建创作")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button("关闭") {
                        isPresented = false
                    }
                }
                .padding()
                
                // Creation options
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    CreationOptionCard(
                        icon: "textformat",
                        title: "文字生成",
                        color: .blue,
                        action: {
                            appCoordinator.navigateToTextGeneration()
                            isPresented = false
                        }
                    )
                    
                    CreationOptionCard(
                        icon: "photo",
                        title: "图像上传",
                        color: .green,
                        action: {
                            appCoordinator.navigateToImageUpload()
                            isPresented = false
                        }
                    )
                    
                    CreationOptionCard(
                        icon: "mic",
                        title: "语音输入",
                        color: .purple,
                        action: {
                            // Navigate to voice input
                            isPresented = false
                        }
                    )
                    
                    CreationOptionCard(
                        icon: "camera",
                        title: "拍照上传",
                        color: .orange,
                        action: {
                            // Navigate to camera
                            isPresented = false
                        }
                    )
                }
                .padding()
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct CreationOptionCard: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
    }
}



#Preview {
    AppNavigationView()
        .environmentObject(AppCoordinator())

}

enum NavigationTab: String, CaseIterable {
    case dashboard = "Dashboard"
    case projects = "Projects"
    case messages = "Messages"
    case profile = "Profile"
}

#Preview {
    AppNavigationView()
        .environmentObject(AppCoordinator())
}
