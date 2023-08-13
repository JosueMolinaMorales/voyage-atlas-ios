//
//  Network.swift
//  VoyageAtlas
//
//  Created by Josue morales on 8/12/23.
//

import Foundation

// This class handles making network calls to the api
class NetworkBuilder {
    var method: String
    var body: Data?
    var url: String
    var headers: [String: String] = [:]
    
    init() {
        self.method = ""
        self.url = ""
        self.body = nil
    }
    
    func setMethod(method: String) -> Self {
        // TODO: Validate method
        self.method = method
        return self
    }
    
    func setBody(body: Data) -> Self {
        self.body = body
        return self
    }
    
    func setUrl(url: String) -> Self {
        self.url = url
        return self
    }
    
    func jsonContentType() -> Self {
        self.headers.updateValue("application/json", forKey: "content-type")
        return self
    }
    
    func bearerToken(token: String) -> Self {
        self.headers.updateValue("Bearer \(token)", forKey: "Authorization")
        return self
    }
    
    func addHeader(key: String, value: String) -> Self {
        self.headers.updateValue(value, forKey: key)
        return self
    }
    
    func build() -> Network {
        return Network(url: self.url, body: self.body, method: self.method, headers: self.headers)
    }
}

class Network {
    var url: String
    var body: Data?
    var method: String
    var headers: [String: String]
    init(url: String, body: Data? = nil, method: String, headers: [String: String]) {
        self.url = url
        self.body = body
        self.method = method
        self.headers = headers
    }
    
    func createRequest() -> URLRequest {
        guard let url = URL(string: self.url) else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method
        urlRequest.allHTTPHeaderFields = self.headers
        if let body = self.body {
            urlRequest.httpBody = body
        }
        return urlRequest
    }
}

enum StatusCode: Int {
    case Ok = 200
    case NotFound = 404
    case ServerError = 500
    case Created = 201
    case NoContent = 204
}
