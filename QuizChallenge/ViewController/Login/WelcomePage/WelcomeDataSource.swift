//
//  WelcomeDataSource.swift
//  QuizChallenge
//
//  Created by A.Makarov on 13/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

private struct Page {
    let title: String
    let description: String
    let imageName: String
}

class WelcomeDataSource: NSObject, UICollectionViewDataSource {
    
    private var pages: [Page] = []
    
    var countPages: Int {
        return pages.count
    }
    
    override init() {
        super.init()
        
        addPage(title: "First page", desc: "First page", image: "nn")
        addPage(title: "Second page", desc: "Second page", image: "nn")
        addPage(title: "Third page", desc: "Third page", image: "nn")
        addPage(title: "Good Game!", desc: "Fourth page", image: "nn")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomePageCell", for: indexPath) as! WelcomePageCell
        
        if indexPath.row == pages.count - 1 {
            cell.configLastPage()
            cell.callback = {
                UserDefaults.standard.isShowWelcomeScreen = true
                Router.rootLoginVC()
            }
        }
        
        cell.titleLabel.text = pages[indexPath.row].title
        cell.descriptionLabel.text = pages[indexPath.row].description
        
        return cell
    }
    
    func addPage(title: String, desc: String, image: String) {
        pages.append(Page(title: title, description: desc, imageName: image))
    }
}
