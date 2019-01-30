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

func loadJsonCategories(from file: String) -> TypeDecodable? {
   
    if let path = Bundle.main.path(forResource: file, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            guard let jsonResult = try? JSONDecoder().decode(TypeDecodable.self, from: data) else {
                print("Error parse json")
                return nil
            }
            
            return jsonResult
        } catch {
            print("Error load json: \(error.localizedDescription)")
        }
    }
    
    return nil
}
