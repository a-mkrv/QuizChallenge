//
//  UICollectionView+Extension.swift
//  QuizChallenge
//
//  Created by A.Makarov on 19/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

extension UICollectionView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }) { _ in completion() }
    }
}
