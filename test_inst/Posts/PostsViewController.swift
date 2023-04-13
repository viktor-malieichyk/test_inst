//
//  ViewController.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import UIKit

class PostsViewController: UICollectionViewController {
    var repository = Repository.shared
    
    private var items: [Post] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var storiesViewController: StoriesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerClass(InstagramPostCell.self)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        createStoriesSubview()
        
        getItems(page: .first)
    }
    
    
    func getItems(page: Repository.Page) {
        repository.getPosts(page: page) { result in
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
    func createStoriesSubview() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "StoriesViewController") as? StoriesViewController else { return }
        self.storiesViewController = viewController
        self.addChild(viewController)
    }
    
    func addStoriesToView(_ view: UIView) {
        guard let viewController = storiesViewController else { return }
        viewController.view.removeFromSuperview()
        view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.heightAnchor.constraint(equalToConstant: 80)
        ])
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
extension PostsViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return items.count }
        else { return 0 }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InstagramPostCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setPost(items[indexPath.row])
        
        if items.count - 1 == indexPath.row {
            if repository.hasMore(.post) { getItems(page: .next) }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Create the header view and configure it as needed
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath)
        headerView.backgroundColor = .red
        
        addStoriesToView(headerView)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Return the size of the header view
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
}

