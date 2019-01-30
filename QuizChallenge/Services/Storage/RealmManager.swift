//
//  RealmManager.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 25/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    // MARK: - Realm Configuration
    
    static let shared = RealmManager()
    
    init() {
        realmConfiguration()
    }

    func realmConfiguration() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                switch oldSchemaVersion {
                case 1:
                    break
                default:
                    break
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - Main methods (store, remove, get - Object)
    func storeObject<T: Object>(_ object: T, withUpdate: Bool = true) throws {
        try execute({ realm in
            try realm.write {
                realm.add(object, update: withUpdate)
            }
        })
    }
    
    func deleteObject<T: Object>(_ object: T) throws {
        try execute({ realm in
            try realm.write {
                realm.delete(object)
            }
        })
    }
    
    func getObjectByID<T: Object>(_ type: T.Type, id: Int) -> T? {
        if let obj = try? Realm().object(ofType: type, forPrimaryKey: id) {
            return obj
        }
        
        return nil
    }
    
    func getObjects<T: Object>(_ type: T.Type) -> [T]? {
        if let objs = try? Realm().objects(type).map{ $0 } {
            return Array(objs)
        }
       
        return nil
    }
    
    func clearAllData() throws {
        try execute({ realm in
            try realm.write {
                realm.deleteAll()
            }
        })
    }
    
    func updateSettings(sound: Bool, notify: Bool, saveQuestion: Bool, payButton: Bool) throws {
        try execute({ realm in
            try realm.write {
                let settings = RealmManager.shared.getObjects(SettingsModel.self)?.first
                settings?.backgroundSoud = sound
                settings?.notifications = notify
                settings?.saveQuestions = saveQuestion
                settings?.buyPremiumEnabled = payButton
            }
        })
    }

    // MARK: - Other supporting methods
    private func execute(_ completion: (_ realmObject: Realm) throws -> Void) throws {
        try completion(Realm())
    }
    
    func realmUrl() -> URL {
        return Realm.Configuration.defaultConfiguration.fileURL!
    }
}
