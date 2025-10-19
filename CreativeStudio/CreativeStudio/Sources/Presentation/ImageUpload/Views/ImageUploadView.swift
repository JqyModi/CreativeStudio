import SwiftUI
import UIKit

struct ImageUploadView: View {
    @StateObject var viewModel: ImageUploadViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Upload area
                uploadAreaView
                
                // Image previews
                if !viewModel.selectedImages.isEmpty {
                    imagePreviewsView
                }
                
                // Description input
                descriptionInputView
                
                // Style selection
                styleSelectionView
                
                // Generate button
                generateButtonView
                
                Spacer()
            }
            .padding()
            .navigationTitle("图像上传")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var uploadAreaView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(viewModel.isDragOver ? Color.blue : Color.gray, lineWidth: 2)
                .background(Color(.systemGray6))
                .onTapGesture {
                    viewModel.showImagePicker = true
                }
            
            VStack(spacing: 12) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                
                Text("点击上传或拖拽图片")
                    .foregroundColor(.secondary)
                
                Text("支持 JPG/PNG 格式，最大20MB")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
        }
        .onDrop(of: ["public.file-url"], isTargeted: $viewModel.isDragOver) { providers in
            return viewModel.handleDrop(providers: providers)
        }
    }
    
    private var imagePreviewsView: some View {
        VStack(spacing: 12) {
            Text("已选择的图片")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(viewModel.selectedImages.enumerated()), id: \.offset) { index, imageData in
                        let uiImage = UIImage(data: imageData) ?? UIImage()
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(8)
                            .overlay(
                                Button(action: {
                                    viewModel.removeImage(at: index)
                                }) {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Image(systemName: "xmark")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        )
                                }
                                .offset(x: 40, y: -40)
                                .zIndex(1)
                            )
                    }
                }
            }
        }
    }
    
    private var descriptionInputView: some View {
        Group {
            if viewModel.selectedImages.count > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("描述 (可选)")
                            .font(.headline)
                        Spacer()
                        Text("\(viewModel.descriptionText.count)/200")
                            .font(.caption)
                            .foregroundColor(viewModel.descriptionText.count > 180 ? .red : .secondary)
                    }
                    
                    TextEditor(text: $viewModel.descriptionText)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
        }
    }
    
    private var styleSelectionView: some View {
        Group {
            if viewModel.selectedImages.count > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    Text("艺术风格")
                        .font(.headline)
                    
                    Picker("选择风格", selection: $viewModel.selectedStyle) {
                        ForEach(ArtStyle.allCases, id: \.self) { style in
                            Text(getStyleName(for: style)).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
    
    private var generateButtonView: some View {
        Group {
            if viewModel.selectedImages.count > 0 {
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
                        Text(viewModel.isGenerating ? "生成中..." : "生成内容")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isGenerating ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(viewModel.isGenerating)
            }
        }
    }
    
    private func getStyleName(for style: ArtStyle) -> String {
        switch style {
        case .defaultStyle: return "默认"
        case .artistic: return "艺术"
        case .realistic: return "写实"
        }
    }
}

#Preview {
    ImageUploadView(viewModel: ImageUploadViewModel())
        .environmentObject(AppCoordinator())
}