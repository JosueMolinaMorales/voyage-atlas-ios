//
//  CreatePostViewModel.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/28/23.
//

import Foundation

class CreatePostViewModel: ObservableObject {
    private let apiUri = "http://localhost:3000"
    
    func createPost(body: CreatePost, onSuccess: @escaping () -> Void, onError: @escaping (_ status: Int) -> Void) {
        let jsonData = try! JSONEncoder().encode(body)
        let token = UserDefaults.standard.string(forKey: "token") ?? "";

        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/users/post")
            .setMethod(method: "POST")
            .setBody(body: jsonData)
            .jsonContentType()
            .bearerToken(token: token)
            .build()
        
        let task = URLSession.shared.dataTask(with: network.createRequest()) { _, response, error in
            guard error == nil else {
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
