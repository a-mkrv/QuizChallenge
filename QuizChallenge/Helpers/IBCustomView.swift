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
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) { didSet { setShadow() }}
    @IBInspectable var shadowOpacity: Float = 0 { didSet { setShadow() }}
    @IBInspectable var shadowColor: UIColor? { didSet { setShadow() }}
    @IBInspectable var shadowRadius: CGFloat = 0 { didSet { setShadow() }}
    
    func setShadow() {
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
}

@IBDesignable class GradientView: IBView {
    
    @IBInspectable var startColor:   UIColor?  { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor?  { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    @IBInspectable var isAnimate:       Bool =  false { didSet { addAnimate() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    var currentGradient: Int = 0
    var gradientSet: [[CGColor]] = [[CGColor]]()
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors() {
        gradientLayer.colors = [startColor?.cgColor ?? UIColor.clear.cgColor, endColor?.cgColor ?? UIColor.clear.cgColor]
    }
    
    func animateGradient() {
      
        guard isAnimate else {
            stopAnimate()
            return
        }
        
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradientLayer.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    func startBackgroundAnimation() {
        gradientLayer.colors = gradientSet[currentGradient]
        gradientLayer.startPoint = CGPoint(x:0, y:0)
        gradientLayer.endPoint = CGPoint(x:1, y:1)
        gradientLayer.drawsAsynchronously = true
        
        animateGradient()
    }
    
    func addAnimate() {
        
        guard isAnimate else {
            stopAnimate()
            return
        }
        
        gradientSet.append([startColor!.cgColor, endColor!.cgColor])
        gradientSet.append([endColor!.cgColor, startColor!.cgColor])

        startBackgroundAnimation()
    }
    
    func stopAnimate() {
        gradientLayer.removeAllAnimations()
        gradientSet = [[UIColor.white.cgColor]]
        gradientLayer.colors = [UIColor.white.cgColor]
        currentGradient = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}

extension GradientView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradientLayer.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}

//MARK: UIButton
@IBDesignable class IBButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 { didSet { sharedInit() }}
    @IBInspectable var borderWidth: CGFloat = 0 { didSet { sharedInit() }}
    @IBInspectable var borderColor: UIColor = .clear { didSet { sharedInit() }}
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) { didSet { sharedInit() }}
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
    @IBInspectable var shadowOffset = CGSize(width: 0, height: 0) { didSet { layer.shadowOffset = shadowOffset }}
    @IBInspectable var shadowOpacity: Float = 0 { didSet { layer.shadowOpacity = shadowOpacity }}
    @IBInspectable var shadowColor: UIColor = .clear { didSet { layer.shadowColor = shadowColor.cgColor }}
    @IBInspectable var shadowRadius: CGFloat = 0 { didSet { layer.shadowRadius = shadowRadius }}
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

@IBDesignable class IBProgressView: UIProgressView {
    
    @IBInspectable var barHeight : CGFloat = 1 {
        didSet {
            self.transform = self.transform.scaledBy(x: 1, y: barHeight)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
            
        }
    }
}
