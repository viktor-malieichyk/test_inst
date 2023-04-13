//
//  AvatarViewCell.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import UIKit
import UIKit

class AvatarViewCell: UICollectionViewCell {
    private var userData: UserData?
    
    let avatarView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.backgroundColor = .gray
        view.contentMode = .scaleAspectFill

        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func layoutSubviews() {
        avatarView.layer.borderColor = UIColor.systemPink.cgColor
        avatarView.layer.cornerRadius = (self.frame.height - 16) / 2
        avatarView.clipsToBounds = true
    }
    
    func setupViews() {
        contentView.addSubview(avatarView)
        avatarView.image = .placeholderImageSmall
        
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        avatarView.setNeedsLayout()
    }
    
    override func prepareForReuse() {
        avatarView.image = .placeholderImageSmall
    }
    
    func setUser(_ userData: UserData) {
        self.userData = userData
        
        let urlString = userData.avatar
        ImageCache.loadImage(withUrl: urlString) { [weak self] image in
            if self?.userData?.avatar == urlString {
                self?.avatarView.image = image
            }
        }
        
    }
}
