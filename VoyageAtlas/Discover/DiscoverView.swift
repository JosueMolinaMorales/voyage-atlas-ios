//
//  DiscoverView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/29/23.
//

import SwiftUI
import AlertToast

struct DiscoverView: View {
    @StateObject private var vm = DiscoverViewModel()
  
    var body: some View {
        NavigationStack {
            ForEach(vm.users) { user in
                NavigationLink(value: user) {
                    UserSearchResultView(user: user)
                }
                
                Divider()
            }
            .navigationDestination(for: AuthUser.self) { user in
                ProfileView(user: user)
            }
            if vm.users.count == 0 && !vm.isLoading {
                Text("No users matched the query: \(vm.searchText)")
            }
        }
        .toast(isPresenting: $vm.isLoading) {
            AlertToast(type: .loading)
        }
        .searchable(text: $vm.searchText)
        .textInputAutocapitalization(.never)
        
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}

struct UserSearchResultView: View {
    var user: AuthUser
    var body: some View {
        HStack {
            // Profile Pic
            ProfilePicture(width: 50, height: 50, shadowRadius: 1, circleOverlayWidth: 1)
            Text(user.username)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
