//
//  PostListView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI

struct PostListView: View {
    var body: some View {
        ScrollView {
            ForEach(1..<50) {_ in
                VStack {
                    PostView()
                    Divider()
                }
            }
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}
