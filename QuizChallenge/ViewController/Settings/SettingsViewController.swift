//
//  SettingsViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 26/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var profileImage: IBImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var backgroundSoundSwitch: UISwitch!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var saveQuestionsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
    }
    
    @IBAction func resetGameProgress(_ sender: Any) {
    
    }
    
    @IBAction func logOut(_ sender: Any) {
        
    }
}
