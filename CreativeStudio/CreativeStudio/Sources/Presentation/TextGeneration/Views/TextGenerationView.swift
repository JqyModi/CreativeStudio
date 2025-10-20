//
//  TextGenerationView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/8.
//

import SwiftUI

struct TextGenerationView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject var viewModel = TextGenerationViewModel()
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Input area
                VStack(alignment: .leading, spacing: 15) {
                    TextEditor(text: $viewModel.inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 150, maxHeight: 200)
                        .padding(15)
                        .background(Color(red: 0.973, green: 0.973, blue: 0.98))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 2)
                        )
                        .focused($isInputFocused)
                    
                    HStack {
                        Text("💡 提示：点击键盘麦克风图标可语音输入")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Generate button
                Button(action: {
                    if appCoordinator.userQuota.canGenerate() {
                        viewModel.generateContent { project in
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
                        
                        Text(viewModel.isGenerating ? "生成中..." : "✨ 生成创意内容")
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("文字生成")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("←") {
                        appCoordinator.navigateToDashboard()
                    }
                    .foregroundColor(Color.white)
                }
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
                            
                            Text("正在生成创意内容，请稍候...")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                }
            )
        }
    }
}

class TextGenerationViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var isGenerating: Bool = false
    @Published var generatedText: String = ""
    @Published var progress: Double = 0.0
    
    func generateContent(completion: @escaping (Project) -> Void) {
        guard !inputText.isEmpty else { return }
        
        isGenerating = true
        progress = 0.0
        
        // Simulate generation process
        let initialProgress = progress
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            DispatchQueue.main.async {
                self.progress += 0.02
                
                if self.progress >= 1.0 {
                    timer.invalidate()
                    self.isGenerating = false
                    self.progress = 0.0
                    
                    // Create a new project with the generated result
                    let generationResult = GenerationResult(
                        prompt: self.inputText,
                        texts: ["示例生成文案：根据您的描述生成的创意内容，具有高度的个性化和专业性。"]
                    )
                    
                    let project = Project(
                        name: "文字生成项目",
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
    
    func saveResult() {
        // Implementation for saving result
    }
}

#Preview {
    NavigationStack {
        TextGenerationView()
            .environmentObject(AppCoordinator())
    }
}