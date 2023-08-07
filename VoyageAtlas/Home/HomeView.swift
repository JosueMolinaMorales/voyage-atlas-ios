//
//  HomeView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/25/23.
//

import SwiftUI
import FloatingButton

struct HomeView: View {
    @State private var showCreatePost = false
    @State var loggedInUser: AuthUser
    @State var onCreatePostSuccess: () -> Void
    
    var body: some View {
        TabView {
            HomeFeedView(showCreatePost: $showCreatePost, onCreatePostSuccess: onCreatePostSuccess)
            .tabItem {
                Label("Home", systemImage: "house")
            }
            NavigationView {
                DiscoverView()
            }
            .tabItem {
                Label("Discover", systemImage: "sparkles")
            }
            ProfileView(user: loggedInUser)
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
        .background(Color.red)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(loggedInUser: AuthUser(id: "", username: "", email: "")) {
            
        }
    }
}

struct HomeFeedView: View {
    @ObservedObject private var vm = HomeViewModel()
    @Binding var showCreatePost: Bool
    @State var onCreatePostSuccess:  () -> Void
    
    var body: some View {
        VStack {
            HeaderView()
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack {
                        ForEach(vm.feed) {post in
                            PostView(post: post)
                        }
                    }
                }

                Button {
                    showCreatePost.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)

                }
                .padding()
                .sheet(isPresented: $showCreatePost ) {
                    CreatePostView(onSuccess: onCreatePostSuccess)
                        .presentationDragIndicator(.visible)
                        .presentationCompactAdaptation(.popover)
                }
            }
        }.onAppear {
            vm.getHomeFeed()
        }
        .refreshable {
            vm.getHomeFeed()
        }
    }
}
