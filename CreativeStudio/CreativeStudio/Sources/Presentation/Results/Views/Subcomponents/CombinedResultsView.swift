//
//  CombinedResultsView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/22.
//

import SwiftUI

struct CombinedResultsView: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let firstResult = project.generationResults.first {
                // Show prompt
                VStack(alignment: .leading, spacing: 8) {
                    Text("原始提示词")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                    
                    Text(firstResult.prompt)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                // Show generated texts
                if !firstResult.texts.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("生成文案")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                            .padding(.horizontal)
                        
                        ForEach(firstResult.texts.prefix(2), id: \.self) { text in
                            VStack(alignment: .leading, spacing: 8) {
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
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Show generated images
                if !firstResult.images.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("生成图像")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                            ForEach(0..<min(firstResult.images.count, 2), id: \.self) { index in
                                AsyncDataImage(data: firstResult.images[index])
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, maxHeight: 150)
                                    .clipped()
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct CombinedResultsView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedResultsView(project: Project(name: "Test Project", generationResults: [GenerationResult(prompt: "Test prompt", images: [], texts: ["Sample text"])]))
    }
}
