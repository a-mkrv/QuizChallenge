//
//  GameModeCell.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 29/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class GameModeCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedBackgroundImageView: UIImageView!
    
    override func layoutSubviews() {
        isSelected(false)
    }
    
    func isSelected(_ selected: Bool) {
        if selected {
            selectedBackgroundImageView.isHidden = false
            nameLabel.textColor = .white
        } else {
            selectedBackgroundImageView.isHidden = true
            nameLabel.textColor = .black
        }
    }
}
