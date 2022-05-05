//
//  LikesCollectionViewController.swift
//  PhotosLibrary
//
//  Created by Valeriya Trofimova on 19.04.2022.
//

import UIKit

final class LikesCollectionViewController: UICollectionViewController {
    
    var photosLike = [UnsplashPhoto]()
    private var selectedPhotos = [UIImage]()
    
    private var numberOfSelectedPhotosLike: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    private lazy var trashBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItemButton))
    }()
    
    private let enterSearchTermLabel = UILabel(text: "You haven't add a photos yet",
                                               font: UIFont.boldSystemFont(ofSize: 20),
                                               textAlignment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        setupCollectionView()
        setupEnterLabel()
        setupNavigationBar()
        updateNavButton()
    }
    
    private func updateNavButton() {
        trashBarButtonItem.isEnabled = numberOfSelectedPhotosLike > 0
    }
    
    // MARK: - NavigationItems Action
    
    @objc private func deleteItemButton() {
        print(#function)
        
        guard let selectedCells = collectionView.indexPathsForSelectedItems else { return }
        let items = selectedCells.map { $0.item }.sorted().reversed()
        for item in items {
            photosLike.remove(at: item)
        }
        collectionView.deleteItems(at: selectedCells)
        trashBarButtonItem.isEnabled = false
    }
    
    // MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.register(LikesCell.self, forCellWithReuseIdentifier: LikesCell.reuseId)
        
        collectionView.allowsMultipleSelection = true
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
    }
    
    private func setupEnterLabel() {
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.translatesAutoresizingMaskIntoConstraints = false
        enterSearchTermLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        enterSearchTermLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 50).isActive = true
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel(text: "FAVOURITES",
                                 font: UIFont.systemFont(ofSize: 15, weight: .bold),
                                 textColor: UIColor(named: "NewGray") ?? .systemGray)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItem = trashBarButtonItem
        trashBarButtonItem.isEnabled = false
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = photosLike.count != 0
        return photosLike.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesCell.reuseId, for: indexPath) as! LikesCell
        let unsplashPhoto = photosLike[indexPath.item]
        cell.set(photo: unsplashPhoto) 
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LikesCell
        guard let image = cell.likeImageView.image else { return }
        selectedPhotos.append(image)
        
        updateNavButton()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButton()
        
        let cell = collectionView.cellForItem(at: indexPath) as! LikesCell
        guard let image = cell.likeImageView.image else { return }
        if let index = selectedPhotos.firstIndex(of: image) {
            selectedPhotos.remove(at: index)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension LikesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        return CGSize(width: width/3 - 1, height: width/3 - 1)
    }
}

