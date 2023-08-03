//
//  PostListView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI

struct PostListView: View {
    @State var posts: [Post]
    @ViewBuilder
    var body: some View {
        if posts.isEmpty {
            VStack {
                Text("No Post")
            }.frame(maxHeight: .infinity)
        } else {
            ForEach(posts) {post in
                VStack {
                    PostView(post: post)
                    Divider()
                }
            }
        }

    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView(posts: [])
    }
}
