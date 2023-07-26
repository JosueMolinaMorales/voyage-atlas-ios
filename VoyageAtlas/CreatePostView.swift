//
//  CreatePostView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/25/23.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("Hello WOrld")
            Button("Press to dismiss") {
                dismiss()
            }
            .font(.title)
            .padding()
            .background(.black)
        }
        
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
