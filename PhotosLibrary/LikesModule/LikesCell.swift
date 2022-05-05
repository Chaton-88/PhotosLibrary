//
//  LikesCell.swift
//  PhotosLibrary
//
//  Created by Valeriya Trofimova on 26.04.2022.
//

import Foundation
import UIKit
import SDWebImage

class LikesCell: UICollectionViewCell {
    
    static let reuseId = "LikesCollectionViewCell"
    
    var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    private let checkmark: UIImageView = {
        let image = UIImage(systemName: "checkmark.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        likeImageView.image = nil
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    private func updateSelectedState() {
        likeImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        setupViews()
    }
    
    private func setupViews() {
        addSubview(likeImageView)
        addSubview(checkmark)
        
        likeImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        likeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        likeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        likeImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        checkmark.trailingAnchor.constraint(equalTo: likeImageView.trailingAnchor, constant: -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: likeImageView.bottomAnchor, constant: -8).isActive = true
    }
    
    func set(photo: UnsplashPhoto) {
        let photoURL = photo.urls["regular"]
        guard let photoURL = photoURL, let url = URL(string: photoURL) else { return }
        likeImageView.sd_setImage(with: url, completed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
