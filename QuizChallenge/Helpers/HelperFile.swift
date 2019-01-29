//
//  HelperFile.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 28/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

func loadViewController(from storyboard: String, named name: String) -> UIViewController? {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: name)
}
