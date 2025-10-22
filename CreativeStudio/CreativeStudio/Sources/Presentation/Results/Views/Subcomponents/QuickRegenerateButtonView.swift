//
//  QuickRegenerateButtonView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/22.
//

import SwiftUI

struct QuickRegenerateButtonView: View {
    var onRegenerate: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onRegenerate) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("不满意？一键重新生成")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color(red: 0.4, green: 0.498, blue: 0.918))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
            )
            .accessibilityLabel("一键重新生成内容")
            
            Spacer()
        }
    }
}

struct QuickRegenerateButtonView_Previews: PreviewProvider {
    static var previews: some View {
        QuickRegenerateButtonView {
            print("Regenerate button tapped")
        }
    }
}