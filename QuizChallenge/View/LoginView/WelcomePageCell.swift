//
//  WelcomePageCell.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 04/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class WelcomePageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var callback: EmptyClosure?
    
    func configLastPage() {
        descriptionLabel.isHidden = true
        startButton.isHidden = false
    }
    
    @IBAction func pressStart(_ sender: Any) {
        self.callback?()
    }
}
