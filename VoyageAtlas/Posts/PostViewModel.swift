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
    @Published var author: AuthUser?
    @Published var comments: [Comment] = []
    
    func likePost(postId: String) {
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        let desc = UserDefaults.standard.string(forKey: "description") ?? ""
        
        let network = NetworkBuilder()
            .bearerToken(token: token)
            .setUrl(url: "\(apiUri)/post/\(postId)/like")
            .setMethod(method: "POST")
            .jsonContentType()
            .build()
        
        let task = URLSession.shared.dataTask(with: network.createRequest()) { data, response, error in
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
        }
        
        task.resume()
    }
    
    func getLikesOfPost(postId: String) {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
     
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/post/\(postId)/like")
            .setMethod(method: "GET")
            .jsonContentType()
            .build()
        
        let task = URLSession.shared.dataTask(with: network.createRequest()) { data, response, error in
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
            }
        
        }
        
        task.resume()
    }
    
    func unlikePost(postId: String) {
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/post/\(postId)/like")
            .setMethod(method: "DELETE")
            .bearerToken(token: token)
            .jsonContentType()
            .build()
        
        let task = URLSession.shared.dataTask(with: network.createRequest()) { data, response, error in
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
            print("Status Code For unliking a post \(statusCode)")
            print("response: \(data)")
        }
        
        task.resume()
    }
    
    func getAuthorOfPost(postId: String, authorId: String) {
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/users/\(authorId)")
            .setMethod(method: "GET")
            .jsonContentType()
            .build()
        
        let task = URLSession.shared.dataTask(with: network.createRequest()) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if let user = try? JSONDecoder().decode(AuthUser.self, from: data) {
                DispatchQueue.main.async {
                    self.author = user
                }
            } else {
                let response = response as? HTTPURLResponse;
                let statusCode = response?.statusCode ?? 0;
                print("Status Code for getting is post liked \(statusCode)")
                print("response: \(data)")
            }
        }
        
        task.resume()
    }
    
    func getCommentsForPost(postId: String) {
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/post/\(postId)/comment")
            .jsonContentType()
            .setMethod(method: "GET")
            .build()
        
        let task = URLSession.shared.dataTask(with: network.createRequest()) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if let comments = try? JSONDecoder().decode([Comment].self, from: data) {
                DispatchQueue.main.async {
                    self.comments = comments
                }
            } else {
                let response = response as? HTTPURLResponse;
                let statusCode = response?.statusCode ?? 0;
                print("Status Code for getting is post liked \(statusCode)")
                print("response: \(data)")
            }
        }
        
        task.resume()
    }
}

struct Like: Decodable, Hashable {
    let user: AuthUser
    let post_id: String
    let created_at: Int32
}

struct Comment: Decodable, Hashable, Identifiable {
    let id: String
    let user: AuthUser
    let post_id: String
    let comment: String
    let created_at: Double
    let parent_comment_id: String?
    
    func convertCreatedAt() -> String {
        let date = Date(timeIntervalSince1970: self.created_at)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
