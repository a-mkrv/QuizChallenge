//
//  EmptyActiveGameView.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 02/05/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class EmptyActiveGameView: UIView {
    
    // MARK: - Setup view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviewFromNib()
    }

}
