//
//  PrepareGameViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 23/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

protocol PrepareDelegate {
    func scrollToCategories()
    func startGame()
}

class PrepareGameViewController: UIViewController {
    
    @IBOutlet weak var prepareCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView.isScrollEnabled = false
    }
    
    @IBAction func pressBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: PrepareDelegate
extension PrepareGameViewController: PrepareDelegate {
    
    func scrollToCategories() {
        prepareCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .bottom, animated: true)
    }
    
    func startGame() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gameVC = storyBoard.instantiateViewController(withIdentifier: "GameSB") as! GameViewController        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}

//MARK: CollectioView Delegates
extension PrepareGameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
