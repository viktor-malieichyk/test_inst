//
//  ViewController.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let repository = Repository(networkService: InstServiceImpl(), cache: Cache(container: PesrsistentContainer(modelName: "test_inst")))
        
        repository.getPosts { result in
            switch result {
                
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        
        repository.getPosts { result in
            switch result {
                
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }


}

