//
//  ProfileView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            // Header
            Image("HeaderAnnapolis")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .ignoresSafeArea(edges: .top)
            ProfilePicture()
                .offset(y: -175)
                .padding(.bottom, -250)
            Text("Josue Morales")
                .font(.title)
                .offset(y: -10)

            Text("My Description Belongs Here")
                .font(.subheadline)
                .padding(.bottom, 8)

            PostListView()
        }.frame(maxHeight: .infinity)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
