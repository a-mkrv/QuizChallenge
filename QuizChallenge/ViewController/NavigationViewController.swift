//
//  NavigationViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 13/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation

import UIKit

final class SwipeNavigationController: UINavigationController {
    
    // MARK: - Private Properties
    
    fileprivate var duringPushAnimation = false
    
    // MARK: - Lifecycle
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        Logger.info(msg: "Loading Custom Navigation Controller")
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
        Logger.info(msg: "Deinit Navigation Controller")
    }
    
    // MARK: - Overrides

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UINavigationControllerDelegate

extension SwipeNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        
        swipeNavigationController.duringPushAnimation = false
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SwipeNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }

        return viewControllers.count > 1 && duringPushAnimation == false
    }
}
