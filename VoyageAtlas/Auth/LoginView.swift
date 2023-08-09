//
//  LoginView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/24/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var vm = AuthViewModel()
    @State var onSuccess: () -> Void
    
    var body: some View {
        VStack {
            GroupBox(label: Label("Login", systemImage: "person.circle.fill")) {
                TextField("Email", text: $email)
                    .autocorrectionDisabled(true)
                    .padding(4)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password) {}.padding(4)
                HStack {
                    Button(action: {
                        vm.login(body: LoginBody(email: email, password: password)) {
                            onSuccess()
                        }
                        
                    }) {
                        Text("Sign In")
                    }.buttonStyle(.bordered)
                    Button(action: {}) {
                        Text("Register")
                    }.buttonStyle(.bordered)
                }
                
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        @State var loggedIn = false;
        LoginView(onSuccess: {})
    }
}

struct LoginBody: Decodable, Encodable {
    var email: String
    var password: String
}

struct Token: Decodable {
    var bearer: String
    var user: AuthUser
}

struct AuthUser: Decodable, Identifiable, Hashable {
    var id: String
    var username: String
    var email: String
    var name: String
    var description: String
}
