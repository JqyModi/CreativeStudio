//
//  ImageResultsView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/22.
//

import SwiftUI

struct ImageResultsView: View {
    let project: Project
    
    var body: some View {
        if let firstResult = project.generationResults.first,
           !firstResult.images.isEmpty {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                ForEach(0..<min(firstResult.images.count, 4), id: \.self) { index in
                    AsyncDataImage(data: firstResult.images[index])
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipped()
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        } else {
            VStack {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                Text("暂无图像结果")
                    .foregroundColor(.secondary)
            }
            .frame(maxHeight: 200)
            .padding(.horizontal)
        }
    }
}

struct ImageResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ImageResultsView(project: Project(name: "Test Project", generationResults: [GenerationResult(prompt: "Test prompt", images: [])]))
    }
}
