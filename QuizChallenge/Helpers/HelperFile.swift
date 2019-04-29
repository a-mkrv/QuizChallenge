//
//  HelperFile.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 28/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - Closure typealias

public typealias EmptyClosure = () -> Void
public typealias BoolClosure = (Bool) -> ()
public typealias IntClosure = (Int) -> ()
public typealias StringClosure = (String) -> ()

// MARK: - PopUp Alert Helper

class PopUpHelper {
    
    // Question Alert
    static func showConfirmView(from VC: UIViewController, title: String?, descript: String, negativeButton: String, positiveButton: String, completion: @escaping EmptyClosure, secondCompletion: @escaping EmptyClosure) {
        
        let popUpView = CommonHelper.getPopUpView()
        popUpView.showConfirmAlert(title: title, descript: descript, negativeButton: negativeButton, positiveButton: positiveButton, negativeCompletion: completion, positiveCompletion: secondCompletion)
        
        VC.present(popUpView, animated: true, completion: nil)
    }
    
    // Success simple Alert
    static func showSimpleAlert(from VC: UIViewController, type: ModalSimpleType, title: String? = nil, descript: String, buttonText: String, isAutoHide: Bool = true, completion: EmptyClosure? = nil) {
        
        let popUpView = CommonHelper.getPopUpView()
        popUpView.showSimpleAlert(type: type, title: title, descript: descript, buttonText: buttonText, isAutoHide: isAutoHide, completion: completion)
        
        VC.present(popUpView, animated: true, completion: nil)
    }
    
    // Success error Alert
    static func showErrorAlert(from VC: UIViewController, type: ModalErrorType, title: String? = nil, descript: String? = nil, buttonText: String? = nil, isAutoHide: Bool = true, completion: EmptyClosure? = nil) {
        
        let popUpView = CommonHelper.getPopUpView()
        popUpView.showErrorAlert(type: type, title: title, descript: descript, buttonText: buttonText, isAutoHide: isAutoHide, completion: completion)
        
        VC.present(popUpView, animated: true, completion: nil)
    }
}

// MARK: - Common Helper Class

class CommonHelper {
    
    static let networkStateManager = NetworkReachabilityManager()

    // Check Internet connection
    static func checkNetworkStatus() -> Bool {
        return networkStateManager?.isReachable ?? false
    }
    
    // Load view controller from storyboard
    static func loadViewController(from storyboard: String = "Main", named name: String, isModal: Bool = false) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: name)
        if isModal {
            viewController.modalPresentationStyle = .overCurrentContext
        }
        return viewController
    }
    
    // Load test file with questions
    static func loadJsonCategories(from file: String) -> TypeDecodable? {
        
        if let path = Bundle.main.path(forResource: file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                guard let jsonResult = try? JSONDecoder().decode(TypeDecodable.self, from: data) else {
                    Logger.error(msg: "Error parse json")
                    return nil
                }
                
                return jsonResult
            } catch {
                Logger.error(msg: "Error load json: " + error.localizedDescription)
            }
        }
        return nil
    }
    
    // Current UTC time
    static func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd/HH:mm:ss.SSS"
        return dateFormatter.string(from: Date())
    }
    
    static func getPopUpView() -> UniversalModalViewController {
        return CommonHelper.loadViewController(from: "Modals", named: "UniversalModal", isModal: true) as! UniversalModalViewController
    }
}
