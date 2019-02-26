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
    @IBOutlet weak var chooseButton: IBButton!
    
    var delegate: PrepareDelegate?
    var selectedCellIndex: Int?

    private let dataSource = [(QuizType.GuessImage, "collage"),
                              (QuizType.TextQuiz, "wordcloud"),
                              (QuizType.TrueOrFalse, "TrueFalse"),
                              (QuizType.Other, "Other")]
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chooseButton.alpha = 0.5
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func goChooseCategory(_ sender: Any) {
        if selectedCellIndex == nil {
            chooseButton.shake()
        } else {
            PrepareGameSingleton.shared.typeQuestion = dataSource[selectedCellIndex!].0
            delegate?.scrollToCategories()
        }
    }
}

extension TypeQuizCell: UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = String(describing: GameModeCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GameModeCell
        
        cell.nameLabel.text = dataSource[indexPath.row].0.rawValue
        cell.image.image = UIImage(named: dataSource[indexPath.row].1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var cell: GameModeCell?
        
        if let index = selectedCellIndex, index < dataSource.count {
            cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? GameModeCell
            cell?.isSelected(false)
        }
        
        selectedCellIndex = indexPath.row
        chooseButton.alpha = 1
        cell = collectionView.cellForItem(at: indexPath) as? GameModeCell
        cell?.isSelected(true)
    }
    
}
