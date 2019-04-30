//
//  HistoryGameCell.swift
//  QuizChallenge
//
//  Created by A.Makarov on 11/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import SkeletonView

class HistoryGameCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: IBImageView!
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var opponentImageView: IBImageView!
    @IBOutlet weak var opponentScoreLabel: UILabel!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.addShadowAndRadius(offset: CGSize(width: 2, height: 2), color: .gray, radius: 2, opacity: 0.18, cornerRadius: 3)
    }
    
    var statusGame: String! {
        didSet {
            if statusGame == "1" {
                gameStatusLabel.text = "Round: \(Int.random(in: 0...10))"
            } else {
                gameStatusLabel.text = "10 rounds"
            }
        }
    }
    
    var score: String! {
        didSet {
            
            //FIXME: Temporary solution (stub)
            var listScore = (0...1).map{ _ in Int.random(in: 1 ... 20) }
            var colors = [UIColor]()
            
            if listScore[0] > listScore[1] {
                colors.append(UIColor(named: "Color-5")!)
                statusGame == "0" ? colors.append(UIColor.lightGray) : colors.append(UIColor(named: "Color-8")!)
            } else {
                statusGame == "0" ? colors.append(UIColor.lightGray) : colors.append(UIColor(named: "Color-8")!)
                colors.append(UIColor(named: "Color-5")!)
            }
            
            let att1 = [NSAttributedString.Key.font : UIFont(name: "Futura-Bold", size: 35.0), NSAttributedString.Key.foregroundColor : colors[0]]
            let att2 = [NSAttributedString.Key.font : UIFont(name: "Futura-Bold", size: 30.0), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let att3 = [NSAttributedString.Key.font : UIFont(name: "Futura-Bold", size: 35.0), NSAttributedString.Key.foregroundColor : colors[1]]
            
            let attributedString1 = NSMutableAttributedString(string: String(listScore[0]), attributes: att1 as [NSAttributedString.Key : Any])
            let attributedString2 = NSMutableAttributedString(string:" / ", attributes: att2 as [NSAttributedString.Key : Any])
            let attributedString3 = NSMutableAttributedString(string: String(listScore[1]), attributes: att3 as [NSAttributedString.Key : Any])

            attributedString2.append(attributedString3)
            attributedString1.append (attributedString2)
            pointsLabel.attributedText = attributedString1
        }
    }
    
    func startSkeletonAnimate() {
        let animation = GradientDirection.topLeftBottomRight.slidingAnimation()
        let gradient = SkeletonGradient(baseColor: UIColor.lightRoyal.withAlphaComponent(0.10),
                                        secondaryColor: UIColor.royal.withAlphaComponent(0.25))
        
        [myImageView, opponentImageView, myScoreLabel, opponentScoreLabel, gameStatusLabel, pointsLabel].forEach(
            {   SkeletonAppearance.default.multilineHeight = $0?.frame.height ?? 20
                $0?.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation) }
        )
    }
    
    func endSkeletonAnimation() {
        [myImageView, opponentImageView, myScoreLabel, opponentScoreLabel, gameStatusLabel, pointsLabel].forEach(
            { $0?.hideSkeleton() })
    }
}
