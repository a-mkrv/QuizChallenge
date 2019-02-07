//
//  SubcategoryCell.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 05/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class SubcategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: IBImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gameButtonView: UIView!
    
    var callback: EmptyClosure?
    
    @IBAction func playGame(_ sender: Any) {
        callback?()
    }
    
    override func prepareForReuse() {
        gameButtonView.isHidden = true
    }
}
