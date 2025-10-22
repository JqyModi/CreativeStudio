//
//  ResultTabsView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/22.
//

import SwiftUI

struct ResultTabsView: View {
    @ObservedObject var viewModel: ResultsViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ResultTab.allCases, id: \.self) { tab in
                    Button(action: {
                        viewModel.selectedTab = tab
                    }) {
                        Text(tab.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .foregroundColor(viewModel.selectedTab == tab ? .white : Color(red: 0.4, green: 0.498, blue: 0.918))
                            .cornerRadius(20)
                            .background(
                                Capsule()
                                    .fill(
//                                        Group {
//                                            if viewModel.selectedTab == tab {
//                                                LinearGradient(
//                                                    colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
//                                                    startPoint: .leading,
//                                                    endPoint: .trailing
//                                                )
//                                            } else {
//                                                Color(red: 0.973, green: 0.973, blue: 0.98)
//                                            }
//                                        }
                                        viewModel.selectedTab == tab ? Color(red: 0.4, green: 0.498, blue: 0.918) : Color(red: 0.973, green: 0.973, blue: 0.98)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("切换到\(tab.title)标签")
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ResultTabsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultTabsView(viewModel: ResultsViewModel())
            .environmentObject(AppCoordinator())
    }
}
