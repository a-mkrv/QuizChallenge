//
//  RandomOpponentViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 25/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class RandomOpponentViewController: UIViewController {

    @IBOutlet weak var activityIndicator: ActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //activityIndicator.animationDuration = 2
        //activityIndicator.rotationDuration = 5
        activityIndicator.numSegments = 12
        activityIndicator.lineWidth = 6
    }
    
    @IBAction func pressStartGame(_ sender: Any) {
        activityIndicator.startAnimating()

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
