//
//  NetworkGeneric.swift
//  NetworkGenericLibrary
//
//  Created by Karolina Muñoz Vargas on 19/6/21.
//

import Foundation

protocol NetworkGeneric {
    var session: URLSession { get }
    
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest, completion: @escaping (Result<T, ApiError>) -> Void)
    
    func fetch(with request: URLRequest, completion: @escaping (Result<String, ApiError>) -> Void)
}

extension NetworkGeneric {
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, complete:@escaping (Result<T, ApiError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                complete(.failure(.requestFailed(description: error.debugDescription)))
                return
            }
            
            guard httpResponse.statusCode < 300, httpResponse.statusCode >= 200  else {
                complete(.failure(.responseUnsuccessful(description: "status code = \(httpResponse.statusCode)")))
                return
            }
            
            guard let data = data else {
                complete(.failure(.invalidData))
                return
            }
                        
            do {
                if(request.httpMethod != "DELETE") {
                    let decoder = JSONDecoder()
                    let genericModel = try decoder.decode(T.self, from: data)
                    complete(.success(genericModel))
                } else {
                    complete(.failure(.requestFailed(description: "Deleted succesfully.")))
                }
                
            }catch let error {
                complete(.failure(.jsonConversionFailure(description: error.localizedDescription)))
            }
        }
        return task
    }
    
    private func decodingTask(with request: URLRequest, complete:@escaping (Result<String, ApiError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                complete(.failure(.requestFailed(description: error.debugDescription)))
                return
            }
            
            guard httpResponse.statusCode < 300, httpResponse.statusCode >= 200  else {
                complete(.failure(.responseUnsuccessful(description: "status code = \(httpResponse.statusCode)")))
                return
            }

            if let error = error {
                complete(.failure(.jsonConversionFailure(description: error.localizedDescription)))
                return
            }
            
            let stringData = "Deleted succesfully."
            complete(.success(stringData))
        }
        return task
    }
    
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
    
    func fetch(with request: URLRequest, completion: @escaping (Result<String, ApiError>) -> Void) {
        let task = decodingTask(with: request) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
}
