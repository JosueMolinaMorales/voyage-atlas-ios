//
//  HomeViewModel.swift
//  VoyageAtlas
//
//  Created by Josue morales on 8/5/23.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    private var apiUri = "http://localhost:3000"
    @Published var feed: [Post] = [Post]()
    @Published var isLoading = false
    
    func getHomeFeed() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        self.isLoading = true
        
        let network = NetworkBuilder()
            .setUrl(url: "\(apiUri)/feed")
            .setMethod(method: "GET")
            .bearerToken(token: token)
            .jsonContentType()
            .build()
        let task = URLSession.shared.dataTask(with: network.createRequest()) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            DispatchQueue.main.async {
                if let feed = try? JSONDecoder().decode([Post].self, from: data) {
                    self.feed.append(contentsOf: feed)
                    self.isLoading = false
                    print("user's feed: \(feed)")
                } else {
                    let response = response as? HTTPURLResponse;
                    let statusCode = response?.statusCode ?? 0;
                    print("Status Code for getting is post liked \(statusCode)")
                    print("response: \(data)")
                }
            }
        
        }
        
        task.resume()
    }
}
