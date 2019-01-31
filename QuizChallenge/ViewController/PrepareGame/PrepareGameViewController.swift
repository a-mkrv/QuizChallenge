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
    
    // MARK: - Outlets & Properties
    @IBOutlet weak var prepareCollectionView: UICollectionView!
    private let dataSource = PrepareGameDataSource()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDataSource()
    }
    
    //MARK: - IBActions
    @IBAction func pressBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private methods
    private func prepareDataSource() {
        prepareCollectionView.dataSource = dataSource

        // FIXME: Find solution, how pass data through delegate, instead callback
        dataSource.scollViewCallback = {
            self.prepareCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .bottom, animated: true)
        }
        
        dataSource.startGameCallback = {
            let gameVC = CommonHelper.loadViewController(from: "Main", named: "GameSB") as! GameViewController
            self.navigationController?.pushViewController(gameVC, animated: true)
        }
    }
}
