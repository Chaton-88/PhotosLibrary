//
//  MainTabBarController.swift
//  PhotosLibrary
//
//  Created by Valeriya Trofimova on 19.04.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        tabBar.isTranslucent = false
      
        let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let likesVC = LikesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())

        viewControllers = [
            generateNavigationController(rootViewController: photosVC, title: "Photos", image: "photo.on.rectangle.angled"),
            generateNavigationController(rootViewController: likesVC, title: "Favourites", image: "suit.heart.fill")
        ]
    }

    private func generateNavigationController(rootViewController: UIViewController, title: String, image: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = UIImage(systemName: image)
        navigationVC.navigationBar.isTranslucent = false
        
        return navigationVC
   }
}
