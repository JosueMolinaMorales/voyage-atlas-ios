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
    @ObservedObject private var vm: ProfileViewModel = ProfileViewModel()
    @State var followedUserToastTitle = ""
    @State var user: AuthUser
    @State var onLogout: () -> Void
    
    init(user: AuthUser, onLogout: @escaping () -> Void = {}) {
        self.user = user
        self.onLogout = onLogout
        vm.getUsersPost(userId: self.user.id)
        vm.getFollowers(userId: self.user.id)
        vm.getFollowing(userId: self.user.id)
        print("fetching profile for \(self.user.username)")
    }

    
    var body: some View {
        ScrollView {
            VStack {
                // Header
                ProfileHeaderView(
                    user: user,
                    vm: vm,
                    followedUserToastTitle: $followedUserToastTitle,
                    showFollowToast: $showFollowToast,
                    onSignout: onLogout
                )
                
                Divider()
                
                
                PostListView(posts: vm.posts)
            }
        }
        .refreshable {
            vm.getUsersPost(userId: self.user.id)
            vm.getFollowers(userId: self.user.id)
            vm.getFollowing(userId: self.user.id)
        }
        .toast(isPresenting: $vm.isLoading) {
            AlertToast(displayMode: .alert, type: .loading)
        }
        .toast(isPresenting: $showFollowToast) {
            AlertToast(displayMode: .banner(.slide), type: .regular, title: followedUserToastTitle)
        }
    }

}
struct ProfileFollowView: View {
    @State var ff: FollowerFollowing
    var body: some View {
        PagerTabStripView() {
            VStack {
                ForEach(ff.followers) { u in
                    NavigationLink(destination: ProfileView(user: u)) {
                        UserSearchResultView(user: u)
                    }
                }
            }.pagerTabItem(tag: 0) {Text("Followers")}
            VStack {
                ForEach(ff.following) { u in
                    NavigationLink(destination: ProfileView(user: u)) {
                        UserSearchResultView(user: u)
                    }
                }
            }.pagerTabItem(tag: 1){Text("Following")}
        }
    }
}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: AuthUser(id: "a8275da5-7ab9-4a48-9527-0e61ecf949f6", username: "JosueMorales", email: "", name: "Josue Morales", description: "My description"))
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

struct ProfileHeaderView: View {
    var user: AuthUser
    @ObservedObject var vm: ProfileViewModel
    @Binding var followedUserToastTitle: String
    @Binding var showFollowToast: Bool
    @State var onSignout: () -> Void

    var body: some View {
        HStack {
            VStack {
                ProfilePicture(width: 100, height: 100, circleOverlayWidth: 2)
                    .offset(y: -16)
            }
            
            VStack {
                VStack {
                    Text("\(user.name)")
                        .font(.headline)
                    Text("@\(user.username)")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 4, trailing: 12))
                VStack {
                    Text("\(user.description)")
                        .font(.subheadline)
                        .padding(.bottom, 8)
                    HStack {
                        NavigationLink(destination: ProfileFollowView(ff: FollowerFollowing(followers: vm.followers, following: vm.following))) {
                            Text("\(vm.followerCount) Followers")
                        }
                        NavigationLink(destination: ProfileFollowView(ff: FollowerFollowing(followers: vm.followers, following: vm.following))) {
                            Text("\(vm.followingCount) Following")
                        }
                    }
                    if (user.id != UserDefaults.standard.string(forKey: "userId") ?? "") {
                        if (vm.isFollowing) {
                            Button(action: {vm.unfollowUser(userId: user.id) {
                                followedUserToastTitle = "User Unfollowed!"
                                showFollowToast = true
                                vm.getFollowers(userId: user.id)
                            }}) {
                                Text("Unfollow")
                            }
                        } else {
                            Button(action: {vm.followUser(userId: user.id, onSuccess: {
                                followedUserToastTitle = "User Followed!"
                                showFollowToast = true
                                vm.getFollowers(userId: user.id)
                            })}) {
                                Text("Follow")
                            }
                        }
                    }
                    if (user.id == UserDefaults.standard.string(forKey: "userId") ?? "") {
                        Button(action: {
                            UserDefaults.standard.removeObject(forKey: "userId")
                            UserDefaults.standard.removeObject(forKey: "email")
                            UserDefaults.standard.removeObject(forKey: "username")
                            UserDefaults.standard.removeObject(forKey: "token")
                            onSignout()
                        }) {
                            Text("Sign out")
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FollowerFollowing: Hashable {
    public var followers: [AuthUser] = []
    public var following: [AuthUser] = []
}
