//
//  ViewController.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import UIKit

class ViewController: UICollectionViewController {
    private var items: [Post] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerClass(InstagramPostCell.self)
        
        Repository.shared.getPosts { result in
            switch result {
                
            case .success(let items):
                self.items = items
                print("#### \(items.count)")
            case .failure(let error):
                print("#### \(error)")
            }
        }


    }
}

class Instlayout: UICollectionViewFlowLayout {
    func setup() {
        self.scrollDirection = .vertical
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
        self.sectionInset = .zero
        let width = UIScreen.main.bounds.width
        self.itemSize = CGSize(width: width, height: InstagramPostCell.recommendedHeight(width: width))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return items.count }
        else { return 0 }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InstagramPostCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setPost(items[indexPath.row])
        
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return
//     }
    
}
