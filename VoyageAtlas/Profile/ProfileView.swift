//
//  ProfileView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI
import AlertToast
import PagerTabStripView

struct ProfileView: View {
    @State private var showFollowToast = false
    var user: AuthUser
    @ObservedObject private var profilePostFetcher: ProfilePostFetcher = ProfilePostFetcher()
    @State var followedUserToastTitle = ""
    
    init(user: AuthUser) {
        self.user = user
        profilePostFetcher.getUsersPost(userId: self.user.id)
        profilePostFetcher.getFollowers(userId: self.user.id)
        profilePostFetcher.getFollowing(userId: self.user.id)
        print("fetching profile")
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    // Header
                    HStack {
                        VStack {
                            ProfilePicture(width: 100, height: 100, circleOverlayWidth: 2)
                                .offset(y: -16)
                        }
                        
                        VStack {
                            VStack {
                                Text("Josue Morales")
                                    .font(.headline)
                                Text("@\(user.username)")
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 4, trailing: 12))
                            VStack {
                                Text("My Description Belongs Here")
                                    .font(.subheadline)
                                    .padding(.bottom, 8)
                                HStack {
                                    Text("\(profilePostFetcher.followerCount) Followers")
                                    Text("\(profilePostFetcher.followingCount) Following")
                                }
                                if (profilePostFetcher.isFollowing) {
                                    Button(action: {profilePostFetcher.unfollowUser(userId: user.id) {
                                        followedUserToastTitle = "User Unfollowed!"
                                        showFollowToast = true
                                        profilePostFetcher.getFollowers(userId: user.id)
                                    }}) {
                                        Text("Unfollow")
                                    }
                                } else {
                                    Button(action: {profilePostFetcher.followUser(userId: user.id, onSuccess: {
                                        followedUserToastTitle = "User Followed!"
                                        showFollowToast = true
                                        profilePostFetcher.getFollowers(userId: user.id)
                                    })}) {
                                        Text("Follow")
                                    }
                                }
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    
                    PostListView(posts: profilePostFetcher.posts)
                }
            }
            .refreshable {
                profilePostFetcher.getUsersPost(userId: self.user.id)
                profilePostFetcher.getFollowers(userId: self.user.id)
                profilePostFetcher.getFollowing(userId: self.user.id)
            }
            .toast(isPresenting: $profilePostFetcher.isLoading) {
                AlertToast(displayMode: .alert, type: .loading)
            }
            .toast(isPresenting: $showFollowToast) {
                AlertToast(displayMode: .banner(.slide), type: .regular, title: followedUserToastTitle)
            }
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: AuthUser(id: "a8275da5-7ab9-4a48-9527-0e61ecf949f6", username: "JosueMorales", email: ""))
    }
}

struct ScrollingProfileView: View {
    var body: some View {
        VStack {
            Image("HeaderAnnapolis")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .ignoresSafeArea(edges: .top)
            ProfilePicture(width: 200, height: 200)
                .offset(y: -175)
                .padding(.bottom, -250)
            Text("Josue Morales")
                .font(.title)
                .offset(y: -10)

            Text("My Description Belongs Here")
                .font(.subheadline)
                .padding(.bottom, 8)
        }
    }
}
