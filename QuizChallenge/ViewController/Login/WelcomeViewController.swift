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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSpaceHeaderView: NSLayoutConstraint!
    let bottomViewHeight: CGFloat = 46

    
    // MARK: - Page data
    
    struct Page {
        let title: String
        let description: String
        let imageName: String
    }
    
    let pages: [Page] = [ Page(title: "First page", description: "First page", imageName: "nn"),
                          Page(title: "Second page", description: "Second page", imageName: "nn"),
                          Page(title: "Third page", description: "Third page", imageName: "nn"),
                          Page(title: "Good Game!", description: "Fourth page", imageName: "nn")]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topSpaceHeaderView.constant = -headerView.frame.height
        bottomViewConstraint.constant = 0
        
        // Collection View Config
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
    }
    
    // MARK: - Actions with Next/Skip buttons
    
    @IBAction func nextPage(_ sender: Any) {
        
        if pageControl.currentPage == pages.count - 1 { return }

        if pageControl.currentPage == pages.count - 2 {
            bottomViewConstraint.constant = -bottomViewHeight
            topSpaceHeaderView.constant = 0
            
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
            
            UIView.transition(with: appNameLabel, duration: 1.0, options: .transitionCrossDissolve, animations: {() -> Void in
                self.appNameLabel.textColor = .white
            })
        }
            
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    @IBAction func skipTutorial(_ sender: Any) {
        pageControl.currentPage = pages.count - 2
        nextPage(sender)
    }
}

// MARK: - Collection View
extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomePageCell", for: indexPath) as! WelcomePageCell
        
        if indexPath.row == pages.count - 1 {
            cell.configLastPage()
            cell.callback = {
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let mainController = storyboard.instantiateViewController(withIdentifier: "LoginSB") as? LoginViewController
                self.view.window?.switchRootViewController(mainController!)
            }
        }
        
        cell.titleLabel.text = pages[indexPath.row].title
        cell.descriptionLabel.text = pages[indexPath.row].description
        
        return cell
    }
}
