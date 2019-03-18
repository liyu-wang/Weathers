//
//  WeatherDaoImpl.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

struct WeatherDaoImpl: WeatherDao {
    
    func fetchWeathers() -> Observable<[Weather]> {
        return fetchWeathers(orderedBy: "cityName")
    }
    
    func fetchWeathers(orderedBy keyPath: String) -> Observable<[Weather]> {
        guard let realm = RealmManager.realm else { return Observable.just([]) }
        
        let result = realm.objects(Weather.self).sorted(byKeyPath: keyPath)
        return Observable.array(from: result)
    }
    
    func add(weather: Weather) {
        RealmManager.write { realm in
            realm.add(weather)
        }
    }
    
    func add(weathers: [Weather]) {
        RealmManager.write { realm in
            realm.add(weathers)
        }
    }
    
    func update(weather: Weather) {
        RealmManager.write { realm in
            realm.add(weather, update: true)
        }
    }
    
    func delete(weather: Weather) {
        RealmManager.write { realm in
            realm.delete(weather)
        }
    }
    
    func deleteAll() {
        guard let realm = RealmManager.realm else { return }
        let weathers: Results<Weather> = realm.objects(Weather.self)
        
        RealmManager.write { realm in
            realm.delete(weathers)
        }
    }
}
