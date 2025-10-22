//
//  TextGenerationView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/8.
//

import SwiftUI

struct TextGenerationView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = TextGenerationViewModel()
    @FocusState private var isInputFocused: Bool
    
    @State private var showAdvancedParams = false
    @State private var selectedStyle = "default"
    @State private var creativity: Double = 0.5
    @State private var suggestions = ["创意", "营销", "品牌", "广告语", "标题党", "文艺", "科技感", "温馨"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Input area
            VStack(alignment: .leading, spacing: 15) {
                // Text input with character count
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("请输入您的创意描述")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.leading, 2)
                        
                        Spacer()
                        
                        // Character count
                        Text("\(min(viewModel.inputText.count, 500))/500")
                            .font(.caption)
                            .foregroundColor(viewModel.inputText.count > 500 ? .red : .white)
                    }
                    
                    TextEditor(text: $viewModel.inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 150, maxHeight: 300)
                        .padding(12)
                        .background(Color(red: 0.973, green: 0.973, blue: 0.98))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                        )
                        .focused($isInputFocused)
                }
                .padding(.horizontal)
                
                // Input assistance
                HStack {
                    Text("💡 提示：点击键盘麦克风图标可语音输入")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Quick suggestion buttons
                if !suggestions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("推荐关键词")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(suggestions, id: \.self) { suggestion in
                                    Button(action: {
                                        if viewModel.inputText.isEmpty {
                                            viewModel.inputText = suggestion
                                        } else {
                                            viewModel.inputText += " \(suggestion)"
                                        }
                                    }) {
                                        Text(suggestion)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color(red: 0.945, green: 0.945, blue: 0.953))
                                            .foregroundColor(.primary)
                                            .cornerRadius(16)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Advanced parameters toggle
                HStack {
                    Button(action: {
                        showAdvancedParams.toggle()
                    }) {
                        HStack {
                            Image(systemName: showAdvancedParams ? "chevron.down" : "chevron.right")
                                .font(.caption)
                            Text("高级参数")
                                .font(.subheadline)
                        }
//                        .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Advanced parameters panel
                if showAdvancedParams {
                    VStack(spacing: 15) {
                        
                        // Creativity slider
                        HStack {
                            Text("创意度")
                                .font(.subheadline)
                                .frame(width: 60, alignment: .leading)
                            
                            Slider(value: $creativity, in: 0...1, step: 0.1)
                                .padding(.trailing)
                            
                            Text(String(format: "%.0f", creativity * 100) + "%")
                                .font(.subheadline)
                                .frame(width: 40, alignment: .leading)
                        }
                        .padding()
                        
                        // Style selection
                        HStack {
                            Text("风格")
                                .font(.subheadline)
                                .frame(width: 60, alignment: .leading)
                            
                            Picker("风格", selection: $selectedStyle) {
                                Text("默认").tag("default")
                                Text("正式").tag("formal")
                                Text("创意").tag("creative")
                                Text("幽默").tag("humorous")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.973, green: 0.973, blue: 0.98).opacity(0.5))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .tint(Color(red: 0.4, green: 0.498, blue: 0.918))
                }
            }
            .padding(.top)
            
            Spacer()
            
            // Generate button
            Button(action: {
                if appCoordinator.userQuota.canGenerate() {
                    let parameters = GenerationParams(
                        style: selectedStyle,
                        creativity: creativity,
                        temperature: 0.7,
                        length: 500
                    )
                    
                    Task {
                        await viewModel.generateContentAsync(prompt: viewModel.inputText, parameters: parameters) { project in
                            // Update quota
                            appCoordinator.userQuota.useGeneration()
                            
                            // Navigate to results
                            appCoordinator.navigateToResults(for: project)
                        }
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
                        
                        // Progress ring
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                                .frame(width: 80, height: 80)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(viewModel.progress))
                                .stroke(LinearGradient(
                                    colors: [Color(red: 0.306, green: 0.8, blue: 0.788), Color(red: 0.4, green: 0.498, blue: 0.918)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .rotationEffect(Angle(degrees: -90))
                                .frame(width: 80, height: 80)
                            
                            Text(String(format: "%.0f%%", viewModel.progress * 100))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        )
    }
}

class TextGenerationViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var isGenerating: Bool = false
    @Published var generatedText: String = ""
    @Published var progress: Double = 0.0
    
    private let textGenerationUseCase: TextGenerationUseCase
    
    init(textGenerationUseCase: TextGenerationUseCase = TextGenerationUseCase()) {
        self.textGenerationUseCase = textGenerationUseCase
    }
    
    @MainActor
    func generateContentAsync(prompt: String, parameters: GenerationParams, completion: @escaping (Project) -> Void) async {
        guard !prompt.isEmpty else { return }
        
        isGenerating = true
        progress = 0.0
        
        do {
            // Update progress during generation
            let generatedTexts = try await textGenerationUseCase.execute(prompt: prompt, parameters: parameters)
            
            // Update progress during the process
            for i in 1...10 {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
                progress = Double(i) * 0.1
            }
            
            // Create a new project with the generated result
            let generationResult = GenerationResult(
                prompt: prompt,
                texts: generatedTexts
            )
            
            let project = Project(
                name: "文字生成项目 - \(prompt.prefix(20))...",
                generationResults: [generationResult]
            )
            
            // Call the completion handler to notify the parent view
            completion(project)
            
        } catch {
            print("Error generating content: $error)")
            // In a real implementation, we would show an error message to the user
        }
        
        isGenerating = false
        progress = 0.0
    }
}

#Preview {
    NavigationStack {
        TextGenerationView()
            .environmentObject(AppCoordinator())
    }
}
