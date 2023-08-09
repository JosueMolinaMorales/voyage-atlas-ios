//
//  ContentView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI
import AlertToast

class Navigation: ObservableObject {
    @Published var path = NavigationPath()
}

struct ContentView: View {
    @State private var selection: String? = nil
    @State private var isLoggedIn = false
    @State private var showSnackbar = false
    @State private var snackbarType: SnackbarType = SnackbarType.Error
    @State private var snackbarTitle = ""
    @State private var snackbarMsg = ""
    @State private var showLoginView = false
    @State private var loggedInUser: AuthUser
    @StateObject private var path: Navigation = Navigation()
    
    init() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        if !token.isEmpty {
            print("Token is not empty")
            self.isLoggedIn = true
            self.loggedInUser = AuthUser(
                id: UserDefaults.standard.string(forKey: "userId")!,
                username: UserDefaults.standard.string(forKey: "username")!,
                email: UserDefaults.standard.string(forKey: "email")!,
                name: UserDefaults.standard.string(forKey: "name")!,
                description: UserDefaults.standard.string(forKey: "description")!
            )
        } else {
            print("In else block of content view init")
            self.loggedInUser = AuthUser(id: "", username: "", email: "", name: "", description: "")
        }
    }
    
    var body: some View {
        NavigationStack(path: $path.path) {
            WelcomeView(onSignInWithEmail: {
                showLoginView = true
            })
            .navigationDestination(isPresented: $showLoginView) {
                LoginView(
                    onSuccess: {
                        showSnackbar = true
                        snackbarMsg = "You have been logged in"
                        snackbarType = SnackbarType.Success
                        snackbarTitle = "Logged in!"
                        loggedInUser = AuthUser(
                            id: UserDefaults.standard.string(forKey: "userId")!,
                            username: UserDefaults.standard.string(forKey: "username")!,
                            email: UserDefaults.standard.string(forKey: "email")!,
                            name: UserDefaults.standard.string(forKey: "name")!,
                            description: UserDefaults.standard.string(forKey: "description")!
                        )
                        isLoggedIn = true
                    }
                )
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView(loggedInUser: loggedInUser) {
                    snackbarTitle = "Post Created!"
                    snackbarMsg = "Your post has been created."
                    snackbarType = SnackbarType.Success
                    showSnackbar = true
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HeaderView()
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarBackButtonHidden(true)
                .toast(isPresenting: $showSnackbar, duration: 2){
                    AlertToast(
                        displayMode: snackbarType == SnackbarType.Error ? .banner(.pop) : .hud,
                        type: snackbarType == SnackbarType.Error ? .error(Color.red) : .complete(Color.green),
                        title: snackbarTitle,
                        subTitle: snackbarMsg
                    )
                }
            }
        }
        .environmentObject(path)
        .frame(maxHeight: .infinity)
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Views: Hashable {
    case Login
    case Home
}
