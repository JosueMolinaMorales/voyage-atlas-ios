//
//  HomeView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/25/23.
//

import SwiftUI

struct HomeView: View {
    @State private var showCreatePost = false
    var body: some View {
        TabView {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    List(0..<100) { i in
                        Text("Item \(i)")
                    }
                    .navigationTitle("Home")

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
                    .sheet(isPresented: $showCreatePost) {
                        CreatePostView()
                    }
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            ProfileView()
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
