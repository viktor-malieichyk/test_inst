//
//  Service.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import Foundation

let baseUrl = "https://reqres.in/api"

enum IMDBServiceError: Error {
    case invalidURL
    case networkError(String)
    case invalidData(String)
}

protocol InstService {
    func getStories(completion: @escaping (Result<Stories, Error>) -> Void)
    func getPosts(completion: @escaping (Result<Posts, Error>) -> Void)
}

class InstServiceImpl: InstService {
    
    private func performRequest<T: Decodable>(with urlString: String, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global().async {
            guard let requestUrl = URL(string: urlString) else {
                completion(.failure(IMDBServiceError.invalidURL))
                return
            }
            
            let configuration = URLSessionConfiguration.default
            let task = URLSession(configuration: configuration).dataTask(with: URLRequest(url: requestUrl)) { data, response, error in
                if error == nil {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedResponse = try decoder.decode(decodingType, from: data)
                            completion(.success(decodedResponse))
                        } catch let error {
                            let errorMessage = (error as? DecodingError)?.detailedDescription ?? error.localizedDescription
                            completion(.failure(IMDBServiceError.invalidData(errorMessage)))
                        }
                    } else {
                        completion(.failure(IMDBServiceError.invalidData("Data is nil")))
                    }
                } else {
                    completion(.failure(IMDBServiceError.networkError(response?.description ?? "")))
                }
            }
            
            task.resume()
        }
    }
    
    func getStories(completion: @escaping (Result<Stories, Error>) -> Void) {
        let urlString = "\(baseUrl)/users"
        performRequest(with: urlString, decodingType: Stories.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPosts(completion: @escaping (Result<Posts, Error>) -> Void) {
        let urlString = "\(baseUrl)/unknows"
        performRequest(with: urlString, decodingType: Posts.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


extension DecodingError {
    var detailedDescription: String {
        switch self {
            
        case let .typeMismatch(_, context):
            return localizedDescription + " \(context.codingPath)"
        case let .valueNotFound(_, context):
            return localizedDescription + " \(context.codingPath)"
        case let .keyNotFound(_, context):
            return localizedDescription + " \(context.codingPath)"
        case let .dataCorrupted(context):
            return localizedDescription + " \(context.codingPath)"
        @unknown default:
            return self.localizedDescription
        }
    }
}


