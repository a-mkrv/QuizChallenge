//
//  PrepareDataSource.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 29/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class PrepareGameDataSource: NSObject, UICollectionViewDataSource, PrepareDelegate {
    
    var startGameCallback: (()->())?
    var scollViewCallback: (()->())?

    func scrollToCategories() { scollViewCallback?() }
    func startGame() { startGameCallback?() }
    
    // MARK: - Collection View data source

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeQuizCell", for: indexPath as IndexPath) as! TypeQuizCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicQuizCell", for: indexPath as IndexPath) as! TopicQuizCell
            cell.delegate = self
            return cell
        }
    }
}

