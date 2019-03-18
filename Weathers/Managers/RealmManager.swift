//
//  RealmManager.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import Foundation
import RealmSwift

typealias RealmWriteBlock = (_ realm: Realm) -> Void

struct RealmManager {
    static let sharedInstance = RealmManager()
    
    // Inside your application(application:didFinishLaunchingWithOptions:)
    
    let config = Realm.Configuration(
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        schemaVersion: 1,
        
        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above
        migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
    })
    
    func configRealm() {
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}

// https://stackoverflow.com/questions/35376584/why-does-realm-use-try-in-swift
extension RealmManager {
    public static var realm: Realm? {
        do {
            return try Realm()
        } catch {
            debugPrint("Could not access database: %@", error)
            return nil
        }
    }
    
    public static func write(with realm: Realm? = RealmManager.realm, _ block: RealmWriteBlock) {
        do {
            try realm?.write {
                // self.realm is not nil, so can `!`
                block(realm!)
            }
        } catch {
            debugPrint("Could not write to database: %@", error)
        }
    }
}
