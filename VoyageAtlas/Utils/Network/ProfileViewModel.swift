//
//  ProfilePostFetcher.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/27/23.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var followers = [AuthUser]()
    @Published var followerCount = 0
    @Published var following = [AuthUser]()
    @Published var followingCount = 0
    @Published var isLoading = false
    @Published var isFollowing = false

    private let apiUri = "http://localhost:3000"
    
    func getUserById(userId: String) {
        isLoading = true
        guard let url = URL(string: "\(apiUri)/users/\(userId)") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let user = try? JSONDecoder().decode(AuthUser.self, from: data) {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } else {
                let response = response as? HTTPURLResponse;
                let statusCode = response?.statusCode ?? 0;
                print("Somethign went wrong: \(statusCode)")
                print("response: \(data)")
                print("error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func getUsersPost(userId: String) {
        
        isLoading = true
        guard let url = URL(string: "\(apiUri)/users/\(userId)/posts") else { fatalError("Missing URL") }

        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let posts = try? JSONDecoder().decode([Post].self, from: data) {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.posts = posts.sorted(by: {p1, p2 in p1.created_at > p2.created_at })
                }
                print("posts: \(posts)")
            } else {
                let response = response as? HTTPURLResponse;
                let statusCode = response?.statusCode ?? 0;
                print("Somethign went wrong: \(statusCode)")
                print("response: \(data)")
                print("error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func followUser(userId: String, onSuccess: @escaping () -> Void) {
        guard let url = URL(string: "\(apiUri)/users/\(userId)/follow") else { fatalError("Missing URL") }
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let response = response as? HTTPURLResponse
            let statusCode = response?.statusCode ?? 0
            if statusCode == 201 {
                DispatchQueue.main.async {
                    self.isFollowing = true
                    self.followerCount += 1
                }
                onSuccess()
            }
            print("status code for following user: \(statusCode)")
        }
        
        task.resume()
    }
    
    func unfollowUser(userId: String, onSuccess: @escaping () -> Void) {
        guard let url = URL(string: "\(apiUri)/users/\(userId)/unfollow") else { fatalError("Missing URL") }
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let response = response as? HTTPURLResponse
            let statusCode = response?.statusCode ?? 0
            if statusCode == 200 {
                DispatchQueue.main.async {
                    self.isFollowing = false
                    self.followerCount = self.followerCount - 1
                }
                onSuccess()
            }
            print("status code for following user: \(statusCode)")
        }
        
        task.resume()
    }
    
    func getFollowers(userId: String) {
        guard let url = URL(string: "\(apiUri)/users/\(userId)/followers") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let users = try? JSONDecoder().decode([AuthUser].self, from: data) {
                DispatchQueue.main.async {
                    self.followers = users
                    self.followerCount = users.count
                    print("follower count is: \(self.followerCount)")
                }
                print("Followers: \(users)")
            } else {
                let response = response as? HTTPURLResponse;
                let statusCode = response?.statusCode ?? 0;
                print("Somethign went wrong: \(statusCode)")
                print("response: \(data)")
                print("error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func getFollowing(userId: String) {
        guard let url = URL(string: "\(apiUri)/users/\(userId)/following") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let users = try? JSONDecoder().decode([AuthUser].self, from: data) {
                DispatchQueue.main.async {
                    self.following = users
                    self.isFollowing = self.followers.contains { user in
                        (UserDefaults.standard.string(forKey: "userId") ?? "") == user.id
                    }
                    self.followingCount = users.count
                    print("following count is: \(self.followingCount)")
                }
                print("Following: \(users)")
            } else {
                let response = response as? HTTPURLResponse;
                let statusCode = response?.statusCode ?? 0
                print("Somethign went wrong: \(statusCode)")
                print("response: \(data)")
                print("error: \(error)")
            }
        }
        
        task.resume()
    }
}
