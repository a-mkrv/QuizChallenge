//
//  TopicQuizCell.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class TopicQuizCell: UICollectionViewCell, CellSelectable {
    
    func selectCell(index: Int) {
        
    }
    @IBOutlet weak var heightCategoryConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
    
    let dataSource = CommonHelper.loadJsonCategories(from: "Categories")
    var curSelectedCellIndex: Int?
    var delegate: PrepareDelegate?
    var isShowCatBlock = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        subcategoryCollectionView.delegate = self
        subcategoryCollectionView.dataSource = self
    }
    
    @IBAction func startGame(_ sender: Any) {
        delegate?.startGame()
    }
}

extension TopicQuizCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView {
            return dataSource?.typeQuestions.count ?? 0
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let cellColor = UIColor(named: "Color-\(indexPath.row)")
            cell.backColorView.startColor = cellColor
            cell.backColorView.shadowColor = cellColor
            cell.categoryNameLabel.text = dataSource?.typeQuestions[indexPath.row].name
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcategoryCell", for: indexPath) as! SubcategoryCell
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= 100 && !isShowCatBlock) {
            heightCategoryConstraints.constant = 0
            isShowCatBlock = true
            applyAnimation()
        } else if (scrollView.contentOffset.y < 100 && isShowCatBlock) {
            heightCategoryConstraints.constant = 100
            isShowCatBlock = false
            applyAnimation()
        }
    }
    
    func applyAnimation() {
        UIView.animate(withDuration: 0.50) {
            self.layoutIfNeeded()
        }
    }
}
