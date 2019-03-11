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
    
    override func awakeFromNib() {
        super.awakeFromNib()        
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
