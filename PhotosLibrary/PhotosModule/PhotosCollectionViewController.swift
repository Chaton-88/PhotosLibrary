//
//  PhotosCollectionViewController.swift
//  PhotosLibrary
//
//  Created by Valeriya Trofimova on 19.04.2022.
//

import UIKit

final class PhotosCollectionViewController: UICollectionViewController {
    
    var newworkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    
    private var photos = [UnsplashPhoto]()
    private var selectedImages = [UIImage]()
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    private let itemsPerRow: CGFloat = 2 // UICollectionViewDelegateFlowLayout
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // UICollectionViewDelegateFlowLayout
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    private let enterSearchTermLabel = UILabel(text: "Please enter search term above...",
                                               font: UIFont.boldSystemFont(ofSize: 20),
                                               textAlignment: .center)
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupEnterLabel()
        setupNavigationBar()
        setupSearchBar()
        updateNavButtonState()
    }
    
    private func updateNavButtonState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavButtonState()
    }
    
    // MARK: - NavigationItems Action
    
    @objc private func addBarButtonTapped() {
        print(#function)
        
        let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (photographs, indexPath) -> [UnsplashPhoto] in
            var mutablePhotos = photographs
            let photo = photos[indexPath.item]
            mutablePhotos.append(photo)
            return mutablePhotos
        })
        
        let allertController = UIAlertController(title: nil, message: "\(selectedPhotos!.count) ???????? ?????????? ?????????????????? ?? ????????????", preferredStyle: .alert)
       
        let add = UIAlertAction(title: "????????????????", style: .default) { (action) in
            let tabbar = self.tabBarController as! MainTabBarController
            let navVC = tabbar.viewControllers?[1] as! UINavigationController
            let likeVC = navVC.topViewController as! LikesCollectionViewController
            
            likeVC.photosLike.append(contentsOf: selectedPhotos ?? [])
            likeVC.collectionView.reloadData()
            
            self.refresh()
        }
        
        let cancel = UIAlertAction(title: "????????????????", style: .cancel) { (action) in
        }
        
        allertController.addAction(add)
        allertController.addAction(cancel)
        present(allertController, animated: true)
    }
    
    @objc private func actionBarButtonTapped(sendler: UIBarButtonItem) {
        print(#function)
        
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        shareController.popoverPresentationController?.barButtonItem = sendler
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    // MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        // ?????????? ???????????????????? ????????
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupEnterLabel() {
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.translatesAutoresizingMaskIntoConstraints = false
        enterSearchTermLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        enterSearchTermLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 50).isActive = true
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        
        let titleLabel = UILabel(text: "PHOTOS",
                                 font: UIFont.systemFont(ofSize: 15, weight: .bold),
                                 textColor: UIColor(named: "NewGray") ?? .systemGray)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItems = [addBarButtonItem,
                                             actionBarButtonItem]
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = photos.count != 0
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonState()
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else { return }
        selectedImages.append(image)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonState()
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
}

// MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        self.spinner.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { ( _ ) in
            self.newworkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let feachedPhotos = searchResults else { return }
                self?.spinner.stopAnimating()
                self?.photos = feachedPhotos.results
                self?.collectionView.reloadData()
                self?.refresh()
            }
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInserts.left
    }
}


