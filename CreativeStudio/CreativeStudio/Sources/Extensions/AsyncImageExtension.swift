//
//  AsyncImageExtension.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/20.
//

import SwiftUI

// Custom view to display image from Data
struct AsyncDataImage: View {
    let data: Data
    var body: some View {
        if let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "photo")
                .foregroundColor(.gray)
        }
    }
}