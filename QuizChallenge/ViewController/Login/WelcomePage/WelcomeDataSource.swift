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
        
        addPage(title: "Get Fun", desc: "Enjoy playing a quiz with friends or random users!", image: "fun")
        addPage(title: "Game Type", desc: "Quick play on the road or keen tournament!", image: "game_type")
        addPage(title: "Creativity", desc: "Create your own questions for everyone!", image: "creativity")
        addPage(title: "Be smarter", desc: "It’s never too late to learn!", image: "mind")
        addPage(title: "Good luck", desc: "", image: "goodgame")
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
        
        cell.titleLabel.text = pages[indexPath.row].title.uppercased()
        cell.descriptionLabel.text = pages[indexPath.row].description
        cell.imageView.image = UIImage(named: pages[indexPath.row].imageName)
        
        return cell
    }
    
    func addPage(title: String, desc: String, image: String) {
        pages.append(Page(title: title, description: desc, imageName: image))
    }
}
