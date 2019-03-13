//
//  PrepareGameViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 23/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class PrepareGameViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var heightCategoryConstraints: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
    @IBOutlet weak var previewView: UIView!

    // MARK: - Properties for showing subcategories
    private var selectedCategory = -1
    private var selectedSubCategory = -1
    private var isChooseCategory = false
    private var isShowCatBlock = false

    // MARK: - Data properties
    private var dataSource: TypeDecodable?
    private var dataCount = 0
    var gameInfo = PrepareGameInfo()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = CommonHelper.loadJsonCategories(from: "Categories") ?? nil

        previewView.isHidden = false
        previewView.alpha = 1
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        subcategoryCollectionView.delegate = self
        subcategoryCollectionView.dataSource = self
    }
    
    //MARK: - IBActions
    
    @IBAction func startGame(_ sender: Any) {
        findOpponent()
    }
    
    func findOpponent() {
        let gameVC = CommonHelper.loadViewController(from: "Main", named: "FindUserScreen") as! FindUserViewController
        gameVC.gameInfo = gameInfo
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}

// MARK: - Extension for Collection View
extension PrepareGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoryCollectionView {
            return dataSource?.typeQuestions.count ?? 0
        }
        
        if collectionView == subcategoryCollectionView {
            // If user selected something category (index >= 0)
            if selectedCategory != -1,  let dataCount = dataSource?.typeQuestions[selectedCategory].types.count {
                self.dataCount = dataCount
                return dataCount
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let cellColor = UIColor(named: "Color-\(indexPath.row)")
            cell.backColorView.startColor = cellColor
            cell.categoryNameLabel.text = dataSource?.typeQuestions[indexPath.row].name
            
            if indexPath.row == selectedCategory {
                cell.backColorView.shadowColor = cellColor
                cell.backColorView.shadowOpacity = 1
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcategoryCell", for: indexPath) as! SubcategoryCell
            let dataCell = dataSource?.typeQuestions[selectedCategory].types[indexPath.row]
            cell.imageView.image = UIImage(named: (dataCell?.image)!)
            cell.nameLabel.text = dataCell?.name
            if indexPath.row == selectedSubCategory {
                cell.gameButtonView.isHidden = false
            }
            cell.callback = {
                self.findOpponent()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == subcategoryCollectionView {
            let offsetBorder: CGFloat = 20 // 10x2
            let collectionViewWidth = collectionView.bounds.width
            let cellWidth = (collectionViewWidth / 2) - offsetBorder
            
            // +20 for label height
            return CGSize(width: cellWidth, height: cellWidth + 20)
        }
        
        let offsetBorder: CGFloat = 40
        let collectionViewWidth = collectionView.bounds.width - offsetBorder
        return CGSize(width: collectionViewWidth / 3, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView {
            if !isChooseCategory {
                isChooseCategory = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.previewView.alpha = 0
                }) { _ in
                    self.previewView.isHidden = true
                }
            }
            
            gameInfo.selectCategory = dataSource?.typeQuestions[indexPath.row].name
            selectedCategory = indexPath.row
            selectedSubCategory = -1
            subcategoryCollectionView.reloadData()
            categoryCollectionView.scrollToItem(at: IndexPath(row: selectedCategory, section: 0), at: .centeredHorizontally, animated: true)
            categoryCollectionView.reloadData()
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! SubcategoryCell
            cell.gameButtonView.isHidden = false
            gameInfo.selectSubCategory = dataSource?.typeQuestions[selectedCategory].types[indexPath.row].name
            selectedSubCategory = indexPath.row
            subcategoryCollectionView.scrollToItem(at: IndexPath(row: selectedSubCategory, section: 0), at: .centeredVertically, animated: true)
            subcategoryCollectionView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard dataCount > 4 else { return }
        
        // FIXME: Magic number (100 - height top collection view, 95)?
        if (scrollView.contentOffset.y >= 100 && !isShowCatBlock) {
            heightCategoryConstraints.constant = 0
            isShowCatBlock = true
            applyAnimation()
        } else if (scrollView.contentOffset.y < 95 && isShowCatBlock) {
            heightCategoryConstraints.constant = 100
            isShowCatBlock = false
            applyAnimation()
        }
    }
    
    func applyAnimation() {
        UIView.animate(withDuration: 0.50) {
            self.view.layoutIfNeeded()
        }
    }
}
