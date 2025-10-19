import SwiftUI

struct ResultsView: View {
    @StateObject var viewModel: ResultsViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab view for different result types
                TabView(selection: $viewModel.selectedTab) {
                    // Images tab
                    imagesTabView
                        .tabItem {
                            Image(systemName: "photo")
                            Text("图像")
                        }
                        .tag(ResultsTab.images)
                    
                    // Texts tab
                    textsTabView
                        .tabItem {
                            Image(systemName: "doc.text")
                            Text("文案")
                        }
                        .tag(ResultsTab.texts)
                    
                    // Combined content tab
                    combinedTabView
                        .tabItem {
                            Image(systemName: "rectangle.3.group")
                            Text("组合")
                        }
                        .tag(ResultsTab.combined)
                    
                    // Recommended content tab
                    recommendedTabView
                        .tabItem {
                            Image(systemName: "star")
                            Text("推荐")
                        }
                        .tag(ResultsTab.recommended)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Custom tab bar
                customTabBar
            }
            .navigationTitle("生成结果")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        // Regenerate button
                        Button(action: {
                            Task {
                                await viewModel.regenerateContent()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.blue)
                        }
                        .disabled(viewModel.isGenerating)
                        
                        // Export menu
                        Menu {
                            Button("导出高清图像") {
                                viewModel.exportHighResolutionImages()
                            }
                            
                            Button("导出文案") {
                                viewModel.exportTexts()
                            }
                            
                            Button("社交媒体适配导出") {
                                viewModel.exportForSocialMedia()
                            }
                            
                            Button("项目归档") {
                                viewModel.archiveProject()
                            }
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.loadResults()
            }
        }
    }
    
    private var imagesTabView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.imageResults.indices, id: \.self) { index in
                    ImageResultCell(
                        imageData: viewModel.imageResults[index],
                        onDelete: {
                            viewModel.deleteImageResult(at: index)
                        },
                        onShare: {
                            viewModel.shareImageResult(at: index)
                        }
                    )
                }
            }
            .padding()
        }
    }
    
    private var textsTabView: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Long text sections
                ForEach(viewModel.textResults.indices, id: \.self) { index in
                    TextResultCell(
                        text: viewModel.textResults[index],
                        onDelete: {
                            viewModel.deleteTextResult(at: index)
                        },
                        onShare: {
                            viewModel.shareTextResult(at: index)
                        },
                        onCopy: {
                            viewModel.copyTextResult(at: index)
                        }
                    )
                }
                
                // Short text sections for social media
                VStack(alignment: .leading, spacing: 12) {
                    Text("社交媒体文案")
                        .font(.headline)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(viewModel.socialMediaTexts.indices, id: \.self) { index in
                            SocialMediaTextCell(
                                text: viewModel.socialMediaTexts[index],
                                onCopy: {
                                    viewModel.copySocialMediaText(at: index)
                                }
                            )
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var combinedTabView: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.combinedResults.indices, id: \.self) { index in
                    CombinedResultCell(
                        result: viewModel.combinedResults[index],
                        onDelete: {
                            viewModel.deleteCombinedResult(at: index)
                        },
                        onShare: {
                            viewModel.shareCombinedResult(at: index)
                        }
                    )
                }
            }
            .padding()
        }
    }
    
    private var recommendedTabView: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("相似内容推荐")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Variants of current results
                ForEach(viewModel.recommendedVariants.indices, id: \.self) { index in
                    RecommendedVariantCell(
                        variant: viewModel.recommendedVariants[index],
                        onSelect: {
                            viewModel.selectRecommendedVariant(at: index)
                        }
                    )
                }
                
                // Trending templates
                Text("热门模板")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(viewModel.trendingTemplates.indices, id: \.self) { index in
                        TemplateCell(
                            template: viewModel.trendingTemplates[index],
                            onSelect: {
                                viewModel.applyTemplate(at: index)
                            }
                        )
                    }
                }
            }
            .padding()
        }
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(ResultsTab.allCases, id: \.self) { tab in
                Button(action: {
                    viewModel.selectedTab = tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 20))
                        Text(tab.title)
                            .font(.caption)
                    }
                    .foregroundColor(viewModel.selectedTab == tab ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .background(Color(.systemGray6))
    }
}

// MARK: - Result Cells
struct ImageResultCell: View {
    let imageData: Data
    let onDelete: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(12)
            }
            
            // Action buttons overlay
            HStack(spacing: 8) {
                Button(action: onShare) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
            }
            .padding(8)
        }
    }
}

struct TextResultCell: View {
    let text: String
    let onDelete: () -> Void
    let onShare: () -> Void
    let onCopy: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(text)
                .font(.body)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            HStack(spacing: 16) {
                Button(action: onCopy) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.on.doc")
                        Text("复制")
                    }
                    .font(.caption)
                }
                
                Button(action: onShare) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                        Text("分享")
                    }
                    .font(.caption)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .foregroundColor(.blue)
        }
    }
}

struct SocialMediaTextCell: View {
    let text: String
    let onCopy: () -> Void
    
    var body: some View {
        Button(action: onCopy) {
            Text(text)
                .font(.caption)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}

struct CombinedResultCell: View {
    let result: CombinedResult
    let onDelete: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image part
            if let imageData = result.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(12)
            }
            
            // Text part
            Text(result.text)
                .font(.body)
                .lineLimit(nil)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            // Layout controls
            HStack {
                Text("布局: \(result.layout.title)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: onShare) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                        Text("分享")
                    }
                    .font(.caption)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct RecommendedVariantCell: View {
    let variant: RecommendedVariant
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 8) {
                if let imageData = variant.previewImage, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(8)
                }
                
                Text(variant.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(variant.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct TemplateCell: View {
    let template: Template
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 100)
                    .cornerRadius(8)
                
                Text(template.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                HStack {
                    ForEach(template.tags.prefix(2), id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}

#Preview {
    ResultsView(viewModel: ResultsViewModel())
        .environmentObject(AppCoordinator())
}