//
//  TextResultsView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/22.
//

import SwiftUI
import UIKit

struct TextResultsView: View {
    let project: Project
    @State private var showingActionSheet = false
    @State private var selectedText: String = ""
    
    var body: some View {
        if let firstResult = project.generationResults.first,
           !firstResult.texts.isEmpty {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(firstResult.texts.indices, id: \.self) { index in
                        TextResultCard(text: firstResult.texts[index], index: index + 1)
                    }
                }
                .padding(.horizontal)
            }
        } else {
            VStack {
                Image(systemName: "doc.text")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                Text("暂无文案结果")
                    .foregroundColor(.secondary)
            }
            .frame(maxHeight: 200)
            .padding(.horizontal)
        }
    }
    
    private struct TextResultCard: View {
        let text: String
        let index: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                // Text header with label and actions
                HStack {
                    Text("文案 \(index)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                    Spacer()
                    // Action buttons
                    HStack(spacing: 12) {
                        // Copy button
                        Button(action: {
                            // Copy text to clipboard functionality
                            UIPasteboard.general.string = text
                        }) {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                                .padding(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("复制文案")
                        
                        // Favorite button
                        Button(action: {
                            // Favorite action
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(.gray)
                                .padding(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("收藏文案")
                    }
                }
                
                // Text content with improved styling
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
                            // Share action
                        }) {
                            Label("分享", systemImage: "square.and.arrow.up")
                        }
                        
                        Divider()
                        
                        Button(action: {
                            // Favorite action
                        }) {
                            Label("收藏", systemImage: "heart")
                        }
                    }
                
                // Action buttons for text
                HStack {
                    Button(action: {
                        // Like action
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
                        // Share action
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
                        // Edit action
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
}

struct TextResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TextResultsView(project: Project(name: "Test Project", generationResults: [GenerationResult(prompt: "Test prompt", texts: ["This is a sample text result.", "This is another sample text result."])]))
    }
}