//
//  FullPostView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 8/5/23.
//

import SwiftUI

struct FullPostView: View {
    @State var post: Post
    @ObservedObject var vm: PostViewModel
    @State private var newComment: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                PostView(post: post)
                // Comment Section
                Divider()
                ForEach(vm.comments) { comment in
                    VStack {
                        HStack {
                            ProfilePicture(width: 50, height: 50, shadowRadius: 1, circleOverlayWidth: 1)
                            Text("@\(comment.user.name)")
                            Text(comment.convertCreatedAt())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color.red, width: 1)
                        Text("\(comment.comment)")
                        Divider()
                    }
                    
                }
                Spacer()
                TextField("New Comment", text: $newComment).textFieldStyle(.roundedBorder).padding(.horizontal, 16)

            }
            .frame(maxHeight: .infinity)
            .onAppear {
                vm.getCommentsForPost(postId: post.id)
            }
        }
    }
}

struct FullPostView_Previews: PreviewProvider {
    static var previews: some View {
        FullPostView(post: Post(title: "A new post", location: "", content: "A new post", id: "", author: "", created_at: 9), vm: PostViewModel())
    }
}
