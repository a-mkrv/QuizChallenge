//
//  BaseView.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 04/05/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewFromNib()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviewFromNib()
        setupUI()
    }
    
    func setupUI() { }
}
