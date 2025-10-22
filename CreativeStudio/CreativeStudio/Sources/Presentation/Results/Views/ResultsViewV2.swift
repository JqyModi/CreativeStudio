//
//  ResultsViewV2.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/22.
//

import SwiftUI
import UIKit

// MARK: - ResultsViewV2
struct ResultsViewV2: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = ResultsViewModel()
    
    let project: Project
    
    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // 页面标题
                    HStack {
                        Text("创作结果")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // 快速重新生成按钮
//                    QuickRegenerateButtonView {
//                        print("重新生成内容")
//                    }
                    
                    // 混合结果显示
                    MixedResultsView(project: project)
                    
                    // 底部操作按钮组
                    BottomActionButtonsView(
                        onSaveToAlbum: {
                            print("保存到相册")
                        },
                        onShare: {
                            print("分享")
                        },
                        onRegenerate: {
                            print("重新生成")
                        }
                    )
                }
                .padding(.top, 10)
            }
        }
    }
}

// MARK: - 混合结果显示视图
struct MixedResultsView: View {
    let project: Project
    
    var body: some View {
        VStack(spacing: 20) {
            if let firstResult = project.generationResults.first {
                // 显示原始提示词
                if !firstResult.prompt.isEmpty {
                    PromptSectionView(prompt: firstResult.prompt)
                }
                
                // 显示文字结果
                ForEach(firstResult.texts.indices, id: \.self) { index in
                    TextResultCardView(text: firstResult.texts[index], index: index + 1)
                }
                
                // 显示图像结果
                if !firstResult.images.isEmpty {
                    ImageViewSectionView(images: firstResult.images)
                }
            } else {
                // 空状态
                EmptyResultsView()
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

// MARK: - 原始提示词视图
struct PromptSectionView: View {
    let prompt: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("原始提示词")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                
                Spacer()
            }
            
            Text(prompt)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(red: 0.973, green: 0.973, blue: 0.98))
                .cornerRadius(8)
        }
        .padding(.bottom, 10)
    }
}

// MARK: - 文字结果卡片视图
struct TextResultCardView: View {
    let text: String
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 文案标题和操作按钮
            HStack {
                Text("文案 \(index)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                
                Spacer()
                
                // 操作按钮组
                HStack(spacing: 12) {
                    // 复制按钮
                    Button(action: {
                        UIPasteboard.general.string = text
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                            .padding(4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("复制文案")
                    
                    // 收藏按钮
                    Button(action: {
                        // 收藏逻辑
                    }) {
                        Image(systemName: "heart")
                            .foregroundColor(.gray)
                            .padding(4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("收藏文案")
                }
            }
            
            // 文案内容
            Text(text)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                )
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = text
                    }) {
                        Label("复制", systemImage: "doc.on.doc")
                    }
                    
                    Button(action: {
                        // 分享操作
                    }) {
                        Label("分享", systemImage: "square.and.arrow.up")
                    }
                    
                    Divider()
                    
                    Button(action: {
                        // 收藏操作
                    }) {
                        Label("收藏", systemImage: "heart")
                    }
                }
            
            // 底部操作按钮
            HStack {
                Button(action: {
                    // 点赞操作
                }) {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                        Text("赞")
                    }
                    .font(.caption)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.973, green: 0.973, blue: 0.98))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("点赞")
                
                Button(action: {
                    // 分享操作
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("分享")
                    }
                    .font(.caption)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.973, green: 0.973, blue: 0.98))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("分享")
                
                Spacer()
                
                Button(action: {
                    // 编辑操作
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("编辑")
                    }
                    .font(.caption)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.973, green: 0.973, blue: 0.98))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("编辑")
            }
        }
    }
}

// MARK: - 图像结果视图
struct ImageViewSectionView: View {
    let images: [Data]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("生成图像")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                ForEach(0..<min(images.count, 4), id: \.self) { index in
                    AsyncDataImage(data: images[index])
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipped()
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                        )
                }
            }
        }
    }
}

// MARK: - 空结果视图
struct EmptyResultsView: View {
    var body: some View {
        VStack {
            Image(systemName: "photo.on.rectangle")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("暂无生成结果")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - 底部操作按钮组视图
struct BottomActionButtonsView: View {
    var onSaveToAlbum: () -> Void
    var onShare: () -> Void
    var onRegenerate: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: onSaveToAlbum) {
                VStack(spacing: 12) {
                    Image(systemName: "tray.and.arrow.down")
                    Text("保存相册")
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(LinearGradient(
                    colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
                    startPoint: .bottom,
                    endPoint: .top
                ))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button(action: onShare) {
                VStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                    Text("分享")
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(LinearGradient(
                    colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
                    startPoint: .bottom,
                    endPoint: .top
                ))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button(action: onRegenerate) {
                VStack(spacing: 12) {
                    Image(systemName: "arrow.clockwise")
                    Text("重新生成")
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(LinearGradient(
                    colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
                    startPoint: .bottom,
                    endPoint: .top
                ))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        ResultsViewV2(project: Project(name: "测试", generationResults: [GenerationResult(prompt: "测试生成文字", images: [
            UIImage(systemName: "star")!.pngData()!,
            UIImage(systemName: "star")!.pngData()!,
            UIImage(systemName: "star")!.pngData()!,
            UIImage(systemName: "leaf")!.pngData()!],texts: [
                "生成文字结果，啊哈哈哈哈哈",
                "生成文字结果，啊哈哈哈哈哈",
                "生成文字结果，啊哈哈哈哈哈",
                "生成文字结果，啊哈哈哈哈哈",
                "生成文字结果，啊哈哈哈哈哈",
                "生成结果指的是呵呵呵呵呵呵"])]))
            .environmentObject(AppCoordinator())
    }
}
