//
//  InstagramPostCell.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import UIKit

private let spacing: CGFloat = 8
private let iconSize: CGFloat = 24

class InstagramPostCell: UICollectionViewCell {
    var postData: Post?
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = iconSize / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .random()
        label.text = "[usernameLabel]"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeIcon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .random()
        view.tintColor = .red
        view.image = UIImage(systemName: "heart.fill")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sendIcon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .random()
        view.tintColor = .black
        view.image = UIImage(systemName: "paperplane")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bookmarkIcon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .random()
        view.tintColor = .black
        view.image = UIImage(systemName: "bookmark")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static func recommendedHeight(width: CGFloat) -> CGFloat {
        return 2 * (spacing + iconSize + spacing) + width
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(postImageView)
        contentView.addSubview(likeIcon)
        contentView.addSubview(sendIcon)
        contentView.addSubview(bookmarkIcon)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            avatarImageView.heightAnchor.constraint(equalToConstant: iconSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: spacing),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            usernameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            postImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: spacing),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.widthAnchor.constraint(equalTo: postImageView.heightAnchor, multiplier: 1.0),
            
            likeIcon.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: spacing),
            likeIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            likeIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            likeIcon.heightAnchor.constraint(equalToConstant: iconSize),
            likeIcon.widthAnchor.constraint(equalToConstant: iconSize),
            
            sendIcon.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: spacing),
            sendIcon.leadingAnchor.constraint(equalTo: likeIcon.trailingAnchor, constant: spacing),
            sendIcon.heightAnchor.constraint(equalToConstant: iconSize),
            sendIcon.widthAnchor.constraint(equalToConstant: iconSize),
            
            bookmarkIcon.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: spacing),
            bookmarkIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            bookmarkIcon.heightAnchor.constraint(equalToConstant: iconSize),
            bookmarkIcon.widthAnchor.constraint(equalToConstant: iconSize)
        ])
    }
    
    override func layoutSubviews() {
        print(contentView.frame)
    }
    
    override func prepareForReuse() {
        postImageView.image = .placeholderImageLarge?.withTintColor(.black)
        postImageView.backgroundColor = .lightGray
        usernameLabel.text = "[usernameLabel]"
    }
    
    func setPost(_ post: Post) {
        postImageView.backgroundColor = .fromHexString(post.color)
        postImageView.image = nil
        
        usernameLabel.text = post.name
    }
}
