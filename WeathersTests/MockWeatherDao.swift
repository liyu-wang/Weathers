//
//  MockWeatherDao.swift
//  WeathersTests
//
//  Created by Liyu Wang on 11/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import Foundation
@testable import Weathers
import RxSwift

class MockWeatherDao: WeatherDao {
    
    var weathers: [Weather] = []
    
    func fetchWeathers() -> Observable<[Weather]> {
        return Observable.from(optional: weathers)
    }
    
    func fetchWeathers(orderedBy keyPath: String) -> Observable<[Weather]> {
        let sorted = self.weathers.sorted { (w1, w2) -> Bool in
            switch keyPath {
            case "cityName":
                return w1.cityName < w2.cityName
            case "tempMin":
                return w1.tempMin < w2.tempMin
            case "tempMax":
                return w1.tempMax < w2.tempMax
            default:
                return true
            }
        }
        
        return Observable.from(optional: sorted)
    }
    
    func add(weather: Weather) {
        self.weathers.append(weather)
    }
    
    func add(weathers: [Weather]) {
        self.weathers.append(contentsOf: weathers)
    }
    
    func update(weather: Weather) {
        for w in self.weathers {
            if w.id == weather.id {
                w.cityName = weather.cityName
                w.tempMin = weather.tempMin
                w.tempMax = weather.tempMax
                w.humidity = weather.humidity
                w.condition = weather.condition
                return
            }
        }
    }
    
    func delete(weather: Weather) {
        if let index = self.weathers.index(of: weather) {
            self.weathers.remove(at: index)
        }
    }
    
    func deleteAll() {
        self.weathers.removeAll()
    }
    
}
