import SwiftUI

struct ResultsView: View {
    @StateObject var viewModel: ResultsViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
//        NavigationStack {
            VStack {
                // Tab view for different result types
                TabView {
                    // Images tab
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(0..<4, id: \.self) { index in
                                if index < viewModel.generatedImages.count {
                                    Image(uiImage: UIImage(data: viewModel.generatedImages[index]) ?? UIImage())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: 200)
                                        .clipped()
                                        .cornerRadius(8)
                                } else {
                                    Rectangle()
                                        .fill(Color(.systemGray6))
                                        .frame(maxWidth: .infinity, maxHeight: 200)
                                        .overlay(
                                            Text("Image $index + 1)")
                                                .foregroundColor(.secondary)
                                        )
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                    .tabItem {
                        Image(systemName: "photo")
                        Text("图像")
                    }
                    
                    // Texts tab
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.generatedTexts.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("文本结果 $index + 1)")
                                        .font(.headline)
                                    
                                    Text(viewModel.generatedTexts[index])
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                    .tabItem {
                        Image(systemName: "doc.text")
                        Text("文案")
                    }
                    
                    // Combined content tab
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(0..<min(viewModel.generatedImages.count, viewModel.generatedTexts.count), id: \.self) { index in
                                VStack(alignment: .leading, spacing: 12) {
                                    Image(uiImage: UIImage(data: viewModel.generatedImages[index]) ?? UIImage())
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(8)
                                    
                                    Text(viewModel.generatedTexts[index])
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .tabItem {
                        Image(systemName: "rectangle.3.group")
                        Text("组合")
                    }
                }
                
                // Action buttons
                actionButtonsView
            }
            .navigationTitle("生成结果")
            .navigationBarTitleDisplayMode(.inline)
//        }
    }
    
    private var actionButtonsView: some View {
        HStack(spacing: 12) {
            Button("重新生成") {
                viewModel.regenerateContent()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button("导出") {
                viewModel.exportResults()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ResultsView(viewModel: ResultsViewModel())
        .environmentObject(AppCoordinator())
}
