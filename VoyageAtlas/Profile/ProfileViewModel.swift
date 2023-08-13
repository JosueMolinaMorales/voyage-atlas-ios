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
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/users/\(userId)")
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
                    self.isLoading = false
                }
            } else {
                let response = response as? HTTPURLResponse;
                let statusCode = response?.statusCode ?? 0;
                print("Somethign went wrong: \(statusCode)")
            }
        }
        
        task.resume()
    }
    
    func getUsersPost(userId: String) {
        
        isLoading = true
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/users/\(userId)/posts")
            .setMethod(method: "GET")
            .jsonContentType()
            .bearerToken(token: token)
            .build()

        let task = URLSession.shared.dataTask(with: network.createRequest()) { data, response, error in
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
            }
        }
        
        task.resume()
    }
    
    func followUser(userId: String, onSuccess: @escaping () -> Void) {
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/users/\(userId)/follow")
            .setMethod(method: "POST")
            .bearerToken(token: token)
            .jsonContentType()
            .build()

        let task = URLSession.shared.dataTask(with: network.createRequest()) { _, response, error in
            guard error == nil else {
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
        let token = UserDefaults.standard.string(forKey: "token") ?? "";
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/users/\(userId)/unfollow")
            .setMethod(method: "DELETE")
            .bearerToken(token: token)
            .jsonContentType()
            .build()

        let task = URLSession.shared.dataTask(with: network.createRequest()) { _, response, error in
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
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/users/\(userId)/followers")
            .setMethod(method: "GET")
            .jsonContentType()
            .build()

        let task = URLSession.shared.dataTask(with: network.createRequest()) { data, response, error in
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
            }
        }
        
        task.resume()
    }
    
    func getFollowing(userId: String) {
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/users/\(userId)/following")
            .setMethod(method: "GET")
            .jsonContentType()
            .build()

        let task = URLSession.shared.dataTask(with: network.createRequest()) { data, response, error in
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
            }
        }
        
        task.resume()
    }
}
