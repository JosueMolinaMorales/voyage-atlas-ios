//
//  ContentView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI
import AlertToast

struct ContentView: View {
    @State private var selection: String? = nil
    @State private var isLoggedIn = false;
    @State private var navPath = NavigationPath()
    @State private var showSnackbar = false
    @State private var snackbarType: SnackbarType = SnackbarType.Error
    @State private var snackbarTitle = ""
    @State private var snackbarMsg = ""
    @ViewBuilder
    var body: some View {
        let token = UserDefaults.standard.string(forKey: "token")
        VStack {
            if !isLoggedIn && token == "" {
                LoginView(onSuccess: {
                    snackbarTitle = "Logged In!"
                    snackbarMsg = "You have been successfully logged in"
                    snackbarType = SnackbarType.Success
                    showSnackbar = true
                }, isLoggedIn: $isLoggedIn)
            } else {
                HomeView() {
                    snackbarTitle = "Post Created!"
                    snackbarMsg = "Your post has been created."
                    snackbarType = SnackbarType.Success
                    showSnackbar = true
                }
            }
        }.toast(isPresenting: $showSnackbar, duration: 5){
            AlertToast(
                displayMode: .banner(.pop),
                type: snackbarType == SnackbarType.Error ? .error(Color.red) : .complete(Color.green),
                title: snackbarTitle,
                subTitle: snackbarMsg
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
