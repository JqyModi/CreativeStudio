import SwiftUI

struct TextGenerationView: View {
    @StateObject var viewModel: TextGenerationViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
//        NavigationStack {
            VStack(spacing: 16) {
                // Input area
                inputAreaView
                
                // Generation controls
                generationControlsView
                
                // Progress indicator
                if viewModel.isGenerating {
                    progressIndicatorView
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("文字生成")
            .navigationBarTitleDisplayMode(.inline)
//        }
    }
    
    private var inputAreaView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("输入提示")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.inputText.count)/500")
                    .font(.caption)
                    .foregroundColor(viewModel.inputText.count > 450 ? .red : .secondary)
            }
            
            TextEditor(text: $viewModel.inputText)
                .frame(minHeight: 200, maxHeight: 300)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isInputFocused ? Color.blue : Color(.systemGray4), lineWidth: 1)
                )
                .focused($isInputFocused)
            
            // Quick insert buttons for recent prompts
            if !viewModel.recentPrompts.isEmpty {
                Text("最近使用")
                    .font(.headline)
                
//                LazyHStack {
                HStack {
                    ForEach(viewModel.recentPrompts, id: \.self) { prompt in
                        Button(prompt) {
                            viewModel.inputText = prompt
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    private var generationControlsView: some View {
        VStack(spacing: 12) {
            Button(action: {
                Task {
                    await viewModel.generateContent()
                }
            }) {
                HStack {
                    if viewModel.isGenerating {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                    Text(viewModel.isGenerating ? "生成中..." : "智能生成")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isGenerating ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.inputText.isEmpty || viewModel.isGenerating)
            
            // Advanced parameters
            disclosureGroup {
                ParameterSliderView(
                    title: "创意度", 
                    value: Binding(
                        get: { viewModel.parameters.temperature },
                        set: { viewModel.parameters.temperature = $0 }
                    ),
                    range: 0.1...1.0,
                    format: .number.precision(.fractionLength(1))
                )
                
                ParameterSliderView(
                    title: "最大长度", 
                    value: Binding(
                        get: { Double(viewModel.parameters.maxTokens) },
                        set: { viewModel.parameters.maxTokens = Int($0) }
                    ),
                    range: 100...1000,
                    format: .number
                )
                
                Picker("风格", selection: $viewModel.parameters.style) {
                    ForEach(TextStyle.allCases, id: \.self) { style in
                        Text(getStyleName(for: style)).tag(style)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
    
    private func disclosureGroup<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        DisclosureGroup("高级参数", content: content)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
    
    private var progressIndicatorView: some View {
        VStack(spacing: 8) {
            ProgressView(value: viewModel.progress, total: 1.0)
                .progressViewStyle(CircularProgressViewStyle())
            
            Text("处理中... ($Int(viewModel.progress * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private func getStyleName(for style: TextStyle) -> String {
        switch style {
        case .creative: return "创意"
        case .technical: return "技术"
        case .formal: return "正式"
        case .casual: return "随意"
        case .professional: return "专业"
        }
    }
}

struct ParameterSliderView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let format: FloatingPointFormatStyle<Double>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                Text(format.format(value))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Slider(value: $value, in: range)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TextGenerationView(viewModel: TextGenerationViewModel())
        .environmentObject(AppCoordinator())
}
