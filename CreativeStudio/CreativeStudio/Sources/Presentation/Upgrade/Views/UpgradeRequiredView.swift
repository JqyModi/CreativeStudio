import SwiftUI

struct UpgradeRequiredView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Header with icon
                VStack(spacing: 16) {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("配额已用完")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("您已达到今日生成限额")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                // Quota details
                VStack(spacing: 16) {
                    HStack {
                        Text("已使用")
                        Spacer()
                        Text("\(appCoordinator.userQuota.usedToday)/\(appCoordinator.userQuota.dailyLimit)")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Progress bar
                    ProgressView(value: appCoordinator.getUsagePercentage())
                        .progressViewStyle(LinearProgressViewStyle())
                        .accentColor(.blue)
                    
                    // Time until reset
                    HStack {
                        Text("下次重置")
                        Spacer()
                        Text(appCoordinator.formatTimeUntilReset())
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                // Upgrade options
                VStack(alignment: .leading, spacing: 20) {
                    Text("升级选项")
                        .font(.headline)
                    
                    // Free upgrade option (wait for reset)
                    Button(action: {
                        appCoordinator.dismissQuotaExceededAlert()
                        appCoordinator.navigateBack()
                    }) {
                        HStack {
                            Image(systemName: "clock")
                            Text("等待重置 (\(appCoordinator.formatTimeUntilReset()))")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Premium upgrade option
                    Button(action: {
                        // In a real app, this would navigate to payment
                        print("Navigate to premium upgrade")
                    }) {
                        HStack {
                            Image(systemName: "crown")
                            Text("升级到专业版")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("¥19.90/月")
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                
                // Benefits of upgrading
                VStack(alignment: .leading, spacing: 16) {
                    Text("专业版特权")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        BenefitRow(icon: "chart.bar", text: "每日生成次数提升至200次")
                        BenefitRow(icon: "sparkles", text: "解锁所有AI模型和风格")
                        BenefitRow(icon: "arrow.down.doc", text: "无限制导出和批量操作")
                        BenefitRow(icon: "person.2", text: "团队协作功能")
                        BenefitRow(icon: "speedometer", text: "优先生成队列")
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("升级账户")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.body)
            
            Spacer()
        }
    }
}

#Preview {
    UpgradeRequiredView()
        .environmentObject(AppCoordinator())
}