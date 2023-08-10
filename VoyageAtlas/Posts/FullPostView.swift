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
                            Text("@Username") // TODO: Add username of commenter
                            Text(comment.convertCreatedAt())
                        }
                        Text("\(comment.comment)")
                        Divider()
                    }
                    
                }
                Spacer()

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
        FullPostView(post: Post(title: "", location: "", content: "", id: "", author: "", created_at: 9), vm: PostViewModel())
    }
}
