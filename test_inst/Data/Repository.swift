//
//  Repository.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import Foundation

class Repository {
    enum SomeCollection: Hashable {
        case post
        case user
    }
    enum Page {
        case some(Int)
        case next
        case first
    }
    
    let networkService: InstService
    let cache: Cache
    
    var metadataDict: [SomeCollection: PaginationMetadata] = [:]
    
    static let shared = Repository(networkService: InstServiceImpl(), cache: Cache(container: .init(modelName: "test_inst")))
    
    init(networkService: InstService, cache: Cache) {
        self.networkService = networkService
        self.cache = cache
    }
    
    func getPosts(page: Page, forceReload: Bool = false, completion: @escaping (Result<[Post], Error>) -> Void) {
        let posts = cache.fetchPostModels()
        let pageNumber = pageNumberFor(page, collection: .post)
        print("#### get page pageNumber \(#function)")
        if !posts.isEmpty && !forceReload && pageNumber == 1 {
            print("#### CACHE \(#function)")
            completion(.success(posts))
            self.metadataDict[.post] = .init(total: posts.count * 3, page: 1, perPage: posts.count)
        } else {
            print("#### SERVICE \(#function)")
            
            networkService.getPosts(page: pageNumber) { result in
                switch result {
                case let .success(metadata):
                    self.metadataDict[.post] = .init(total: metadata.total, page: metadata.page, perPage: metadata.perPage)
                    completion(.success(metadata.data))
                    self.cache.storePosts(metadata.data)
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getUsers(page: Page, forceReload: Bool = false, completion: @escaping (Result<[UserData], Error>) -> Void) {
        let posts = cache.fetchUserModels()
        let pageNumber = pageNumberFor(page, collection: .user)
        print("#### get page pageNumber \(#function)")
        if !posts.isEmpty && !forceReload && pageNumber == 1 {
            print("#### CACHE \(#function)")
            completion(.success(posts))
            self.metadataDict[.user] = .init(total: posts.count * 3, page: 1, perPage: posts.count)
        } else {
            print("#### SERVICE \(#function)")
            
            networkService.getStories(page: pageNumber) { result in
                switch result {
                case let .success(metadata):
                    self.metadataDict[.user] = .init(total: metadata.total, page: metadata.page, perPage: metadata.perPage)
                    completion(.success(metadata.data))
                    self.cache.storeUsers(metadata.data)
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func pageNumberFor(_ kind: Page, collection: SomeCollection) -> Int {
        switch kind {
        case .some(let page):
            return page
        case .next:
            if hasMore(collection), let metadata = metadataDict[.post] {
                return metadata.page + 1
            } else {
                return 1
            }
        case .first:
            return 1
        }
    }
    
    func hasMore(_ collection: SomeCollection) -> Bool {
        if let metadata = metadataDict[collection] {
            return metadata.page * metadata.perPage < metadata.total
        } else {
            return true
        }
    }
}


struct PaginationMetadata {
    let total: Int
    let page: Int
    let perPage: Int
}
