//
//  ContentView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/8.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            switch appCoordinator.currentView {
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
                    ResultsView(project: project)
                        .environmentObject(appCoordinator)
                } else {
                    DashboardView()
                        .environmentObject(appCoordinator)
                }
            case .projectList:
                ProjectListView()
                    .environmentObject(appCoordinator)
            }
            
            // Floating Action Button
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    FloatingActionButton()
//                        .environmentObject(appCoordinator)
//                        .padding(.bottom, 30)
//                        .padding(.trailing, 30)
//                }
//            }
        }
    }
}

struct FloatingActionButton: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @State private var showMenu = false
    
    var body: some View {
        ZStack {
            if showMenu {
                // Menu options background
                Color.black
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
                
                // Menu options
                VStack(spacing: 20) {
                    Button(action: {
                        appCoordinator.navigateToTextGeneration()
                        withAnimation {
                            showMenu = false
                        }
                    }) {
                        HStack {
                            Text("📝")
                                .font(.title)
                            Text("文字生成")
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                    }
                    
                    Button(action: {
                        appCoordinator.navigateToImageUpload()
                        withAnimation {
                            showMenu = false
                        }
                    }) {
                        HStack {
                            Text("🖼️")
                                .font(.title)
                            Text("图像上传")
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                    }
                }
                .offset(y: -80)
            }
            
            // Main FAB button
            Button(action: {
                withAnimation {
                    showMenu.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)
                    
                    if showMenu {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.title2)
                    } else {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppCoordinator())
}
