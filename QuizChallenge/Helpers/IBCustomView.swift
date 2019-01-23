//
//  IBCustomView.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

//MARK: UIView
@IBDesignable class IBView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = cornerRadius }}
    @IBInspectable var borderWidth: CGFloat = 0 { didSet { layer.borderWidth = borderWidth }}
    @IBInspectable var borderColor: UIColor = .clear { didSet { layer.borderColor = borderColor.cgColor }}
}

//MARK: UIButton
@IBDesignable class IBButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 { didSet { sharedInit() }}
    @IBInspectable var borderWidth: CGFloat = 0 { didSet { sharedInit() }}
    @IBInspectable var borderColor: UIColor = .clear { didSet { sharedInit() }}
    
    @IBInspectable var shadowOffset = CGSize(width: 0, height: 0) { didSet { sharedInit() }}
    @IBInspectable var shadowOpacity: Float = 0 { didSet { sharedInit() }}
    @IBInspectable var shadowColor: UIColor = .clear { didSet { sharedInit() }}
    @IBInspectable var shadowRadius: CGFloat = 0 { didSet { sharedInit() }}

    func sharedInit() {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.clipsToBounds = true
    }
}

//MARK: UIImageView
@IBDesignable class IBImageView: UIImageView {
    
    @IBInspectable var isCircle: Bool = false {
        didSet {
            if (!isCircle && cornerRadius > 0) {
                return
            }
            layer.cornerRadius = isCircle ? frame.width / 2 : 0
            clipsToBounds = isCircle
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
            
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 { didSet { layer.borderWidth = borderWidth }}
    @IBInspectable var borderColor: UIColor = .clear { didSet { layer.borderColor = borderColor.cgColor }}
}

//MARK: UITextField
@IBDesignable class IBTextField: UITextField {
    
    @IBInspectable var lineWidth: CGFloat = 1.0 { didSet{ drawLines() } }
    @IBInspectable var lineColor: UIColor = .black { didSet{ drawLines() } }
    
    func drawLines() {
        add(line: CGRect(x: 0.0, y: frame.size.height - lineWidth, width: frame.size.width, height: lineWidth))
    }
    
    private func add(line: CGRect) {
        let border = CALayer()
        border.frame = line
        border.backgroundColor = lineColor.cgColor
        layer.addSublayer(border)
    }
}
