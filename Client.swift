//
//  Client.swift
//  GenericNetwork
//
//  Created by Karolina Muñoz Vargas on 19/6/21.
//

import Foundation

public class Client: NetworkGeneric {
    var session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func post<T: Codable>(url: String, type:T.Type,  object: T, complete: @escaping (Result<T, ApiError>) -> Void) {
        var request = URLRequest(url: URL(string:url)!)
        let body = try! JSONEncoder().encode(object)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        request.httpBody = body
        self.fetch(type: T.self, with: request, completion: complete)
    }
    
    public func get<T: Decodable>(url: String, type:T.Type, complete: @escaping (Result<T, ApiError>) -> Void) {
        let request = URLRequest(url: URL(string:url)!)
        self.fetch(type: T.self, with: request, completion: complete)
    }
    
    public func put<T: Codable>(url: String, type:T.Type,  object: T, complete: @escaping (Result<T, ApiError>) -> Void) {
        var request = URLRequest(url: URL(string:url)!)
        let body = try! JSONEncoder().encode(object)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "PUT"
        request.httpBody = body
        self.fetch(type: T.self, with: request, completion: complete)
    }
    
    public func delete(url: String, complete: @escaping (Result<String, ApiError>) -> Void) {
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "DELETE"
        self.fetch(with: request, completion: complete)
    }
}
