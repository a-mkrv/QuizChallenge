//
//  UIView+Extension.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 04/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

extension UIView {
    
    private func flipViews(fromView: UIView, toView: UIView) {
       
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(from: fromView, to: toView, duration: 1, options: transitionOptions) { _ in
                            fromView.isUserInteractionEnabled = false
                            toView.isUserInteractionEnabled = true
        }
    }
    
    func flip(from: UIView? = nil, to: UIView) {
        flipViews(fromView: from ?? self, toView: to)
    }
}
