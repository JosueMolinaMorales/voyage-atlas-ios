//
//  DiscoverViewModel.swift
//  VoyageAtlas
//
//  Created by Josue morales on 8/2/23.
//

import Foundation
import Combine

class DiscoverViewModel: ObservableObject {
    @Published var users: [AuthUser]
    @Published var isLoading: Bool
    @Published var searchText: String
    private var publishers = [AnyCancellable]()
    private var apiUri = "http://localhost:3000"
    init() {
        self.users = []
        self.isLoading = false
        self.searchText = ""
        observeSearchTerm()
    }
    
    private func observeSearchTerm() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] (searchText) in
                guard let self = self else { return }
                self.getUsers()
            }
            .store(in: &self.publishers)
    }
    
    func getUsers() {
        isLoading = true
        guard let url = URL(string: "\(apiUri)/users?query=\(self.searchText)") else { fatalError("Missing URL") }

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
                    self.isLoading = false
                    self.users = users
                }
                print(users)
            } else {
                let response = response as? HTTPURLResponse;
                let statusCode = response?.statusCode ?? 0;
            }
        }
        
        task.resume()
    }
}
