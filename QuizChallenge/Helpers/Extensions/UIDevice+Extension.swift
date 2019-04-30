//
//  UIDevice+Extension.swift
//  QuizChallenge
//
//  Created by A.Makarov on 30/04/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

extension UIDevice {
    
    enum ScreenType: String {
        case iPhoneSE
        case iPhone6_7_8
        case iPhone6_7_8Plus
        case iPhoneX
        case Unknown
    }
    
    var screenType: ScreenType {

        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhoneSE
        case 1334:
            return .iPhone6_7_8
        case 2208, 1920:
            return .iPhone6_7_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .Unknown
        }
    }
    
}
