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
    var selectedCategory = 0
    var dataCount = 0
    
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
            let dataCount = dataSource?.typeQuestions[selectedCategory].types.count ?? 0
            self.dataCount = dataCount
            return dataCount
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
            let dataCell = dataSource?.typeQuestions[selectedCategory].types[indexPath.row]
            cell.imageView.image = UIImage(named: (dataCell?.image)!)
            cell.nameLabel.text = dataCell?.name
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
            selectedCategory = indexPath.row
            subcategoryCollectionView.reloadData()
            categoryCollectionView.scrollToItem(at: IndexPath(row: selectedCategory, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard dataCount > 4 else { return }
        
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
