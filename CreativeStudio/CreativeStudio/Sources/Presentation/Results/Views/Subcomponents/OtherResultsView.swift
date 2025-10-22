//
//  OtherResultsView.swift
//  CreativeStudio
//
//  Created by Modi on 2025/10/22.
//

import SwiftUI

struct OtherResultsView: View {
    var body: some View {
        VStack {
            Image(systemName: "rectangle.dashed")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("此功能正在开发中")
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: 200)
        .padding(.horizontal)
    }
}

struct OtherResultsView_Previews: PreviewProvider {
    static var previews: some View {
        OtherResultsView()
    }
}