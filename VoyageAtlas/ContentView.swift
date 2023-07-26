//
//  ContentView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: String? = nil
    @State private var isLoggedIn = false;
    @State private var navPath = NavigationPath()
    @ViewBuilder
    var body: some View {
        if !isLoggedIn {
            LoginView(isLoggedIn: $isLoggedIn)
        } else {
            ProfileView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
