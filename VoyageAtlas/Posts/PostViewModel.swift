//
//  PostViewModel.swift
//  VoyageAtlas
//
//  Created by Josue morales on 8/5/23.
//

import Foundation

class PostViewModel: ObservableObject {
    private let apiUri = "http://localhost:3000"
    @Published var isPostLiked = false
    @Published var likes: [Like] = []
    
    func likePost(postId: String) {
        guard let url = URL(string: "\(apiUri)/post/\(postId)/like") else { fatalError("Missing URL") }
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        let desc = UserDefaults.standard.string(forKey: "description") ?? ""
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
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
                DispatchQueue.main.async {
                    self.isPostLiked = true
                    self.likes.append(Like(user: AuthUser(id: userId, username: username, email: email, name: name, description: desc), post_id: postId, created_at: 0))
                }
            }
            print("Status Code For liking a post \(statusCode)")
            print("response: \(data)")
            print("error: \(error)")
        }
        
        task.resume()
    }
    
    func getLikesOfPost(postId: String) {
        guard let url = URL(string: "\(apiUri)/post/\(postId)/like") else { fatalError("Missing URL") }

        var userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let likes = try? JSONDecoder().decode([Like].self, from: data) {
                DispatchQueue.main.async {
                    self.likes = likes
                    self.isPostLiked = likes.contains {like in like.user.id == userId}
                }
            } else {
                let response = response as? HTTPURLResponse;
                let statusCode = response?.statusCode ?? 0;
                print("Status Code for getting is post liked \(statusCode)")
                print("response: \(data)")
                print("error: \(error)")
            }
        
        }
        
        task.resume()
    }
    
    func unlikePost(postId: String) {
        guard let url = URL(string: "\(apiUri)/post/\(postId)/like") else { fatalError("Missing URL") }
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let response = response as? HTTPURLResponse;
            let statusCode = response?.statusCode ?? 0;
            
            if statusCode == 204 {
                DispatchQueue.main.async {
                    self.isPostLiked = false
                    self.likes = self.likes.filter { like in like.user.id != userId }
                }
            }
            print("Status Code For liking a post \(statusCode)")
            print("response: \(data)")
            print("error: \(error)")
        }
        
        task.resume()
    }
}

struct Like: Decodable, Hashable {
    let user: AuthUser
    let post_id: String
    let created_at: Int32
}
