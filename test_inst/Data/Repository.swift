//
//  Repository.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import Foundation

class Repository {
    let networkService: InstService
    let cache: Cache
    
    static let shared = Repository(networkService: InstServiceImpl(), cache: Cache(container: .init(modelName: "test_inst")))
    
    init(networkService: InstService, cache: Cache) {
        self.networkService = networkService
        self.cache = cache
    }
    
    func getPosts(forceReload: Bool = false, completion: @escaping (Result<[Post], Error>) -> Void) {
        let posts = cache.fetchPostModels()
        if !posts.isEmpty && !forceReload {
            print("#### CACHE \(#function)")
            completion(.success(posts))
        } else {
            print("#### SERVICE \(#function)")
            networkService.getPosts() { result in
                switch result {
                case let .success(items):
                    completion(.success(items.data))
                    self.cache.storePosts(items.data)
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getUsers(forceReload: Bool = false, completion: @escaping (Result<[UserData], Error>) -> Void) {
        let posts = cache.fetchUserModels()
        if !posts.isEmpty && !forceReload {
            print("#### CACHE \(#function)")
            completion(.success(posts))
        } else {
            print("#### SERVICE \(#function)")
            networkService.getStories(){ result in
                switch result {
                case let .success(items):
                    completion(.success(items.data))
                    self.cache.storeUsers(items.data)
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
