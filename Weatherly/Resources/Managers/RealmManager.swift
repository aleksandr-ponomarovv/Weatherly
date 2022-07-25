//
//  RealmManager.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import RealmSwift
import Realm

final class RealmManager {
    
    static let shared = RealmManager()
    
    private var schemaVersion: UInt64 = 1
    
    private init() {
        prepareRealmDatabase()
    }
    
    func write(_ block: @escaping ((_ realm: Realm) -> Void)) {
        guard let realm = try? Realm() else { return }
        try? realm.write {
            block(realm)
        }
    }
    
    func addOrUpdate(object: Object) {
        write { (realm) in
            realm.add(object, update: .all)
        }
    }
    
    func getObject<T: Object>(primaryKey: String) -> T? {
        let realm = try? Realm()
        return realm?.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
}

// MARK: - Private methods
private extension RealmManager {
    func prepareRealmDatabase() {
        let config = Realm.Configuration(schemaVersion: schemaVersion)
        Realm.Configuration.defaultConfiguration = config
    }
}
