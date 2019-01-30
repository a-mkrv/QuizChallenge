//
//  ConcreteTopicCell.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 29/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class ConcreteTopicCell: BaseSelectedCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var nameCell: UILabel!
    
    override func prepareForReuse() {
        nameCell.text = nil
        
        // FIXME: Add placeholder image
        imageCell.backgroundColor = .clear
        selectCell(selectState: false)
    }
}
