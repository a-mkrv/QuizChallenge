//
//  TypeQuizCell.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class TypeQuizCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: PrepareDelegate?
    var selectedCellIndex: Int?

    private let dataSource = [("4 Pic 1 Answer", "collage"),
                              ("Common Question", "3029241801_a7cd294df2"),
                              ("True / False", "TrueFalse"),
                              ("Other", "Other")]
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func goChooseCategory(_ sender: Any) {
        delegate?.scrollToCategories()
    }
}

extension TypeQuizCell: UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = String(describing: GameModeCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GameModeCell
        
        cell.nameLabel.text = dataSource[indexPath.row].0
        cell.image.image = UIImage(named: dataSource[indexPath.row].1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var cell: GameModeCell?
        
        if let index = selectedCellIndex, index < dataSource.count {
            cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? GameModeCell
            cell?.selectCell(selectState: false)
        }
        
        selectedCellIndex = indexPath.row
        cell = collectionView.cellForItem(at: indexPath) as? GameModeCell
        cell?.selectCell(selectState: true)
    }
}
