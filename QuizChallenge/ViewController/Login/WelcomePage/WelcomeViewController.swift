//C
//  WelcomeViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 31/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSpaceHeaderView: NSLayoutConstraint!
    
    let bottomViewHeight: CGFloat = 46
    var pagesDataSource = WelcomeDataSource()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topSpaceHeaderView.constant = -headerView.frame.height
        bottomViewConstraint.constant = 0
        pageControl.numberOfPages = pagesDataSource.countPages
        
        // Collection View Config
        collectionView.dataSource = pagesDataSource
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
    }
    
    // MARK: - Actions with Next/Skip buttons
    
    @IBAction func nextPage(_ sender: Any) {
        
        // Opening the last page
        if pageControl.currentPage == pagesDataSource.countPages - 2 {
            bottomViewConstraint.constant = -bottomViewHeight
            topSpaceHeaderView.constant = 0
            
            UIView.transition(with: appNameLabel, duration: 1.0, options: .transitionCrossDissolve, animations: {() -> Void in
                self.view.layoutIfNeeded()
                self.appNameLabel.textColor = .white
            })
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    @IBAction func skipTutorial(_ sender: Any) {
        pageControl.currentPage = pagesDataSource.countPages - 2
        nextPage(sender)
    }
}
