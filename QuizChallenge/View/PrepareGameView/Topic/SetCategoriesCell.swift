//
//  SetCategoriesCell.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 29/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

protocol CellSelectable {
    func selectCell(index: Int)
}

class SetCategoriesCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var typeLabel: UILabel!
    
    var categories = [String]()
    var curTableCellIndex: Int?
    var curSelectCellIndex: Int?
    var delegate: CellSelectable!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func prepareForReuse() {
        print("Test")
        reloadSelectedCell()
    }
    
    func reloadSelectedCell() {
        if let index = curSelectCellIndex {
            collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = String(describing: ConcreteTopicCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ConcreteTopicCell
        cell.imageCell.backgroundColor = UIColor.random
        cell.nameCell.text = categories[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: ConcreteTopicCell = collectionView.cellForItem(at: indexPath) as! ConcreteTopicCell
        cell.selectCell(selectState: true)
        curSelectCellIndex = indexPath.row
        delegate?.selectCell(index: curTableCellIndex!)
    }
}

