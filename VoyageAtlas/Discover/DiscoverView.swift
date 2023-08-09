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
        VStack {
            List {
                Section("Users") {
                    if vm.users.count == 0 && !vm.isLoading && vm.searchText.count > 0 {
                        Text("No users matched the query: \(vm.searchText)")
                    } else {
                        ForEach(vm.users) { user in
                            NavigationLink(destination: ProfileView(user: user)) {
                                UserSearchResultView(user: user)
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $vm.searchText, placement: .navigationBarDrawer)
        .toast(isPresenting: $vm.isLoading) {
            AlertToast(type: .loading)
        }
        
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiscoverView()
        }
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
