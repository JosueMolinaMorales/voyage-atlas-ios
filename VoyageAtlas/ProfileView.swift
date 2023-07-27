//
//  ProfileView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI
import AlertToast

struct ProfileView: View {
    @StateObject private var profilePostFetcher = ProfilePostFetcher(userId: "")
    
    var body: some View {
        VStack {
            // Header
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

            if (!profilePostFetcher.isLoading) {
                PostListView(posts: profilePostFetcher.posts)
            } else {
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
        .toast(isPresenting: $profilePostFetcher.isLoading) {
            AlertToast(type: .loading)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
