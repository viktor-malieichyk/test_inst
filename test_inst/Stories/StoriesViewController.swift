//
//  StoriesViewController.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import UIKit

class StoriesViewController: UICollectionViewController {
    var repository = Repository.shared
    
    private var items: [UserData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerClass(AvatarViewCell.self)
        
        getItems(page: .first)
    }
    
    func getItems(page: Repository.Page) {
        repository.getUsers(page: page) { result in
            switch result {
                
            case .success(let items):
                DispatchQueue.main.async {
                    switch page {
                    case .some(_):
                        self.items.append(contentsOf: items)
                        self.items = self.items.removeDuplicates()
                    case .next:
                        self.items.append(contentsOf: items)
                        self.items = self.items.removeDuplicates()
                    case .first:
                        self.items = items
                    }
                    
                    print(items.count)
                    self.collectionView.reloadData()
                }
                
                print("#### func getItems(page: Repository.Page)  \(items.count)")
            case .failure(let error):
                print("#### \(error)")
            }
        }
    }
}

extension StoriesViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return items.count }
        else { return 0 }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AvatarViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setUser(items[indexPath.row])
        
        if items.count - 1 == indexPath.row {
            if repository.hasMore(.user) { getItems(page: .next) }
        }
        
        return cell
    }
    
}

class StoryLayout: UICollectionViewFlowLayout {
    func setup() {
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
        self.sectionInset = .zero
        self.itemSize = CGSize(width: 80, height: 80)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}
