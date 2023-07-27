//
//  NetworkService.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/26/23.
//

import Foundation

class Network: ObservableObject {
    private let apiUri = "http://localhost:3000"
    func login(body: LoginBody, onSuccess: @escaping () -> Void) {
        guard let url = URL(string: "\(apiUri)/users/login") else { fatalError("Missing URL") }
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
                onSuccess()
                print("Logged In!")
            } else {
                print("Token not retrieved")
            }
        }
        
        task.resume()
    }
    
    func createPost(body: CreatePost, onSuccess: @escaping () -> Void, onError: @escaping (_ status: Int) -> Void) {
        guard let url = URL(string: "\(apiUri)/users/post") else { fatalError("Missing URL") }
        let jsonData = try! JSONEncoder().encode(body)
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let response = response as? HTTPURLResponse;
            let statusCode = response?.statusCode ?? 0;
            if statusCode == 201 {
                onSuccess()
            } else {
                onError(statusCode)
            }
        }
        
        task.resume()
    }
    
}