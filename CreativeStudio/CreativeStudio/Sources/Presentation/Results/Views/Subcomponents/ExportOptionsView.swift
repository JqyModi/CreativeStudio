//
//  ExportOptionsView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/22.
//

import SwiftUI

struct ExportOptionsView: View {
    var onSaveToAlbum: () -> Void
    var onCopyLink: () -> Void
    var onRegenerate: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: onSaveToAlbum) {
                HStack {
                    Image(systemName: "tray.and.arrow.down")
                    Text("保存到相册")
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                )
            }
            
            Button(action: onCopyLink) {
                HStack {
                    Image(systemName: "link")
                    Text("复制链接")
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                )
            }
            
            Button(action: onRegenerate) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("重新生成")
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(LinearGradient(
                    colors: [Color(red: 0.4, green: 0.498, blue: 0.918), Color(red: 0.463, green: 0.294, blue: 0.635)],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

struct ExportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        ExportOptionsView(
            onSaveToAlbum: {},
            onCopyLink: {},
            onRegenerate: {}
        )
    }
}