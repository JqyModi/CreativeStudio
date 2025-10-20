//
//  ImageUploadView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/8.
//

import SwiftUI

struct ImageUploadView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = ImageUploadViewModel()
    @State private var showingImagePicker = false
    @State private var inputDescription = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Image upload area
            VStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.973, green: 0.973, blue: 0.98))
                        )
                    
                    VStack(spacing: 15) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 48))
                            .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                        
                        Text("点击或拖拽上传图片")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("支持 JPG, PNG, HEIC 格式")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.525, green: 0.525, blue: 0.545))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        showingImagePicker = true
                    }
                }
                .frame(height: 200)
                .padding(.horizontal)
                
                Text("或")
                    .foregroundColor(Color(red: 0.525, green: 0.525, blue: 0.545))
                
                // Description input
                VStack(alignment: .leading, spacing: 10) {
                    Text("可选：为上传的图片添加描述，帮助AI更好地理解内容")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    TextEditor(text: $inputDescription)
                        .frame(minHeight: 100, maxHeight: 150)
                        .padding(10)
                        .background(Color(red: 0.973, green: 0.973, blue: 0.98))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
            }
            
            Spacer()
            
            // Generate button
            Button(action: {
                if appCoordinator.userQuota.canGenerate() {
                    viewModel.generateContent(from: inputDescription) { project in
                        // Update quota
                        appCoordinator.userQuota.useGeneration()
                        
                        // Navigate to results
                        appCoordinator.navigateToResults(for: project)
                    }
                }
            }) {
                HStack {
                    if viewModel.isGenerating {
                        ProgressView()
                            .scaleEffect(1.2)
                            .frame(width: 20, height: 20)
                    }
                    
                    Text(viewModel.isGenerating ? "生成中..." : "🔄 生成衍生内容")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(
                    colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .cornerRadius(12)
            }
            .disabled(viewModel.isGenerating || !appCoordinator.userQuota.canGenerate())
            .padding()
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .overlay(
            // Generating overlay
            ZStack {
                if viewModel.isGenerating {
                    Color.black
                        .opacity(0.2)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(2)
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.4, green: 0.498, blue: 0.918)))
                        
                        Text("正在生成衍生内容，请稍候...")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
            }
        )
        .sheet(isPresented: $showingImagePicker) {
            // In a real app, this would show an image picker
            // For now, we'll just simulate the behavior
        }
    }
}

class ImageUploadViewModel: ObservableObject {
    @Published var isGenerating: Bool = false
    @Published var progress: Double = 0.0
    
    func generateContent(from description: String, completion: @escaping (Project) -> Void) {
        isGenerating = true
        progress = 0.0
        
        // Simulate generation process
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            DispatchQueue.main.async {
                self.progress += 0.02
                
                if self.progress >= 1.0 {
                    timer.invalidate()
                    self.isGenerating = false
                    self.progress = 0.0
                    
                    // Create a new project with the generated result
                    let generationResult = GenerationResult(
                        prompt: description.isEmpty ? "用户上传的图像" : description,
                        texts: ["示例生成文案：基于上传图像的智能描述和创意建议。"]
                    )
                    
                    let project = Project(
                        name: "图像上传项目",
                        generationResults: [generationResult]
                    )
                    
                    // Call the completion handler to notify the parent view
                    completion(project)
                }
            }
        }
    }
    
    func stopGeneration() {
        isGenerating = false
        progress = 0.0
    }
}

#Preview {
    NavigationStack {
        ImageUploadView()
            .environmentObject(AppCoordinator())
    }
}