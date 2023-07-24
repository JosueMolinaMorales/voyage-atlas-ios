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
    @State private var auth = Auth()
    var body: some View {
        VStack {
            GroupBox(label: Label("Login", systemImage: "person.circle.fill")) {
                TextField("Email", text: $email)
                    .autocorrectionDisabled(true)
                    .padding(4)
                SecureField("Password", text: $password) {}.padding(4)
                HStack {
                    Button(action: {auth.login(body: LoginBody(email: email, password: password))}) {
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
        LoginView()
    }
}

struct LoginBody: Decodable, Encodable {
    var email: String
    var password: String
}

class Auth: ObservableObject {
    func login(body: LoginBody) {
        guard let url = URL(string: "http://localhost:3000/users/login") else { fatalError("Missing URL") }
        let jsonData = try! JSONEncoder().encode(body)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if let token = try? JSONDecoder().decode(Token.self, from: data) {
                UserDefaults.standard.set(token.bearer, forKey: "token")
            } else {
                print("Token not retrieved")
            }
        }
        
        task.resume()
    }
}

struct Token: Decodable {
    var bearer: String
}
