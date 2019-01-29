//
//  BaseSelectedCell.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 29/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class BaseSelectedCell: UICollectionViewCell {
    
    func selectCell(selectState: Bool) {
        if selectState {
            backgroundColor = .red
        } else  {
            backgroundColor = .clear
        }
    }
    
    func unSelect() {
        backgroundColor = .clear
    }
    
}
