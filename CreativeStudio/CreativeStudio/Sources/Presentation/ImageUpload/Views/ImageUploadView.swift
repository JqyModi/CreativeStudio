import SwiftUI
import PhotosUI

struct ImageUploadView: View {
    @StateObject var viewModel: ImageUploadViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    @State private var isPresentingImagePicker = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Upload area with drag and drop support
                    uploadAreaView
                    
                    // Selected images preview
                    if !viewModel.selectedImages.isEmpty {
                        selectedImagesPreviewView
                    }
                    
                    // Description input area
                    descriptionInputView
                    
                    // Style selection
                    styleSelectionView
                    
                    // Generation controls
                    generationControlsView
                    
                    // Progress indicator
                    if viewModel.isGenerating {
                        progressIndicatorView
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("图像上传")
            .navigationBarTitleDisplayMode(.inline)
            .photosPicker(isPresented: $isPresentingImagePicker, selection: $selectedPhotoItem, matching: .images)
            .onChange(of: selectedPhotoItem) { newItem in
                Task {
                    await viewModel.loadImage(from: newItem)
                }
            }
        }
    }
    
    private var uploadAreaView: some View {
        VStack(spacing: 16) {
            Text("上传区域")
                .font(.headline)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(viewModel.isDragOver ? Color.blue : Color.gray, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                    .frame(height: 200)
                
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text("点击或拖拽上传图片")
                        .foregroundColor(.secondary)
                    
                    Text("支持 JPG/PNG 格式，最大20MB")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("选择图片") {
                        isPresentingImagePicker = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .onDrop(of: [.fileURL], isTargeted: $viewModel.isDragOver) { providers in
                return viewModel.handleDrop(providers: providers)
            }
        }
    }
    
    private var selectedImagesPreviewView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("已选择的图片 (\(viewModel.selectedImages.count)/5)")
                    .font(.headline)
                
                Spacer()
                
                Button("清空所有") {
                    viewModel.clearSelectedImages()
                }
                .foregroundColor(.red)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                        SelectedImageView(
                            imageData: viewModel.selectedImages[index],
                            onDelete: {
                                viewModel.removeImage(at: index)
                            }
                        )
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
    
    private var descriptionInputView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("图像描述 (可选)")
                .font(.headline)
            
            TextEditor(text: $viewModel.descriptionText)
                .frame(height: 100)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            HStack {
                Text("智能建议")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(viewModel.descriptionText.count)/200")
                    .font(.caption)
                    .foregroundColor(viewModel.descriptionText.count > 180 ? .red : .secondary)
            }
            
            // Smart suggestions for description
            if !viewModel.descriptionSuggestions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.descriptionSuggestions, id: \.self) { suggestion in
                            Button(suggestion) {
                                viewModel.descriptionText = suggestion
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
    
    private var styleSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("艺术风格")
                .font(.headline)
            
            Picker("选择风格", selection: $viewModel.selectedStyle) {
                ForEach(ArtStyle.allCases, id: \.self) { style in
                    Text(getStyleName(for: style)).tag(style)
                }
            }
            .pickerStyle(.segmented)
            
            // Style intensity slider
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("风格强度")
                    Spacer()
                    Text(String(format: "%.1f", viewModel.styleIntensity))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Slider(value: $viewModel.styleIntensity, in: 0.1...1.0, step: 0.1)
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
                    Text(viewModel.isGenerating ? "生成中..." : "开始生成")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isGenerating ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.selectedImages.isEmpty || viewModel.isGenerating)
            
            // Advanced options
            DisclosureGroup("高级选项") {
                VStack(spacing: 16) {
                    // Reference image mixing
                    Toggle("参考图混合", isOn: $viewModel.enableReferenceMixing)
                    
                    // Color saturation adjustment
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("色彩饱和度")
                            Spacer()
                            Text(String(format: "%.1f", viewModel.colorSaturation))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Slider(value: $viewModel.colorSaturation, in: 0.0...2.0, step: 0.1)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private var progressIndicatorView: some View {
        VStack(spacing: 12) {
            ProgressView(value: viewModel.progress, total: 1.0)
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            
            Text("处理中... \(Int(viewModel.progress * 100))%")
                .font(.headline)
            
            if viewModel.estimatedCompletionTime > 0 {
                Text("预计完成时间: \(viewModel.estimatedCompletionTime, specifier: "%.0f")秒")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Button("取消") {
                viewModel.cancelGeneration()
            }
            .buttonStyle(.bordered)
            .foregroundColor(.red)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func getStyleName(for style: ArtStyle) -> String {
        switch style {
        case .defaultStyle: return "默认"
        case .artistic: return "艺术"
        case .realistic: return "写实"
        case .anime: return "动漫"
        case .oilPainting: return "油画"
        case .watercolor: return "水彩"
        case .sketch: return "素描"
        }
    }
}

struct SelectedImageView: View {
    let imageData: Data
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 120, height: 120)
                    .cornerRadius(8)
            }
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .offset(x: 8, y: -8)
        }
    }
}

#Preview {
    ImageUploadView(viewModel: ImageUploadViewModel())
        .environmentObject(AppCoordinator())
}