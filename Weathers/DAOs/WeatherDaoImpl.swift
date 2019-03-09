//
//  WeatherDaoImpl.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import Foundation
import RealmSwift

struct WeatherDaoImpl: WeatherDao {
    
    let realm = try! Realm()
    
    func fetchWeathers() -> Results<Weather> {
        return fetchWeathers(orderedBy: "cityName")
    }
    
    func fetchWeathers(orderedBy keyPath: String) -> Results<Weather> {
        let result = realm.objects(Weather.self).sorted(byKeyPath: keyPath)
        return result
    }
    
    func add(weather: Weather) {
        try! realm.write {
            realm.add(weather)
        }
    }
    
    func add(weathers: [Weather]) {
        try! realm.write {
            realm.add(weathers)
        }
    }
    
    func update(weather: Weather) {
        try! realm.write {
            realm.add(weather, update: true)
        }
    }
    
    func delete(weather: Weather) {
        try! realm.write {
            realm.delete(weather)
        }
    }
    
    func deleteAll() {
        let weathers: Results<Weather> = realm.objects(Weather.self)
        
        try! realm.write {
            realm.delete(weathers)
        }
    }
}
