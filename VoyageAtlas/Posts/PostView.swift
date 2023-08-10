//
//  PostView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI

struct PostView: View {
    @State var post: Post
    @ObservedObject private var vm = PostViewModel()
    
    init(post: Post) {
        self.post = post
        vm.getLikesOfPost(postId: post.id)
        vm.getAuthorOfPost(postId: post.id, authorId: post.author)
    }

    var body: some View {
        VStack {
            HStack {
                ProfilePicture(width: 75, height: 75, circleOverlayWidth: 1)
                    .padding(.horizontal, -8)
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text("@\(vm.author?.username ?? "")")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(post.convertCreatedAt())
                            .font(.caption2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 75)
                .padding(.trailing, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            NavigationLink(destination: FullPostView(post: post, vm: vm)) {
                VStack {
                    Text(post.content)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
            }.buttonStyle(PlainButtonStyle()) 
            
            .padding(.horizontal, 8)
            ScrollView(.horizontal) {
                HStack {
                    Image("JoshTree1")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 4, x: 4, y: 4)
                    Image("JoshTree2")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 4, x: 4, y: 4)
                    Image("JoshuaTree")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 4, x: 4, y: 4)
                    Image("JoshuaTree")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 4, x: 4, y: 4)
                    Image("JoshuaTree")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 4, x: 4, y: 4)
                    Image("JoshuaTree")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 4, x: 4, y: 4)
                }.padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            }.scrollIndicators(.hidden)
            
            /* Row of Buttons */
            HStack {
                Button {
                    if !vm.isPostLiked {
                        vm.likePost(postId: post.id)
                    } else {
                        vm.unlikePost(postId: post.id)
                    }
                } label: {
                    HStack {
                        if vm.isPostLiked {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(VoyageColors.orange)
                        } else {
                            Image(systemName: "hand.thumbsup")
                        }
                    }
                }.padding(.horizontal, 4)
                NavigationLink {
                    VStack {
                        List {
                            ForEach(vm.likes, id: \.self) { like in
                                NavigationLink(destination: ProfileView(user: like.user)) {
                                    UserSearchResultView(user: like.user)
                                }
                            }
                        }
                    }.navigationTitle("Likes")
                } label: {
                    Text("\(vm.likes.count)")
                }
                Button {} label: {
                    Image(systemName: "bubble.left")
                        .renderingMode(.original)
                }.padding(.horizontal, 8)
                
                Button {} label: {
                    Image(systemName: "square.and.arrow.up")
                        .renderingMode(.original)
                }.padding(.horizontal, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .foregroundColor(Color.black)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post(
            title: "Joshua Tree National Park is Amazing!",
            location: "",
            content: "Joshua Tree has amazing hikes and beautiful star gazing",
            id: "",
            author: "",
            created_at: 231213
        ))
    }
}

/*
 Image("JoshuaTree")
     .resizable()
     .frame(width: 150, height: 100)
     .clipShape(RoundedRectangle(cornerRadius: 10))
     .aspectRatio(contentMode: .fit)
     .shadow(radius: 7)
 */
