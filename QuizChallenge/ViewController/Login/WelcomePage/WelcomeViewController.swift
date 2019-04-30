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
    @IBOutlet weak var gradientNameView: GradientView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSpaceHeaderView: NSLayoutConstraint!
    
    var bottomViewHeight: CGFloat = 46
    var pagesDataSource = WelcomeDataSource()
    var leftSwipe = UISwipeGestureRecognizer()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(_:)))
        leftSwipe.direction = .left
        collectionView.addGestureRecognizer(leftSwipe)
        
        topSpaceHeaderView.constant = -headerView.frame.height
        bottomViewConstraint.constant = 0
        pageControl.numberOfPages = pagesDataSource.countPages - 1
        gradientNameView.mask = appNameLabel
        bottomViewHeight = bottomView.frame.height
        
        // Collection View Config
        collectionView.dataSource = pagesDataSource
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
        collectionView.layoutIfNeeded()
        
        var height = collectionView.frame.height
        if UIDevice().screenType == .iPhoneX {
            height -= 60
            topSpaceHeaderView.constant -= 50
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width:collectionView.frame.width, height: height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView!.collectionViewLayout = layout
    }
    
    // MARK: - Actions with Next/Skip buttons
    
    @IBAction func nextPage(_ sender: Any) {
        
        // Opening the last page
        if pageControl.currentPage == pagesDataSource.countPages - 2 {
            bottomViewConstraint.constant = -bottomViewHeight * 2
            topSpaceHeaderView.constant = 0
            collectionView.removeGestureRecognizer(leftSwipe)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                self.gradientNameView.isAnimate = false
            }
            
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
        pageControl.currentPage = pagesDataSource.countPages - 1
        nextPage(sender)
    }
    
    @objc func leftSwipe(_ gesture: UIGestureRecognizer) {
        nextPage(gesture)
    }
}
