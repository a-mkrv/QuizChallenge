//
//  AdvertisingViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 23/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class AdvertisingViewController: BaseViewController {
    
    let advertising = ["Watch Ad", "Share VK", "Share FB", "Share Tweet", "Buy 100", "Buy 300", "Buy 500"]
    let adDescription = ["+30 coins", "+30 coins", "+30 coins", "+30 coins", "60 RUB", "150 RUB", "300 RUB"]
    
    @IBOutlet weak var adCollectionView: UICollectionView!
    @IBOutlet weak var coinsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: CollectionView Delegates
extension AdvertisingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return advertising.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertisingCell", for: indexPath as IndexPath) as! AdvertisingCell
        
        cell.adIcon.image = UIImage(named: "adCoins")
        cell.countCoinsLabel.text = adDescription[indexPath.row]
        cell.nameLabel.text = advertising[indexPath.row]
        
        return cell
    }
}
