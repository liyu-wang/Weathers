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
import RxCocoa

class MockWeatherDao: WeatherDao {
    
    private var weatherArray: [Weather] = []
    private var weathers: BehaviorRelay<[Weather]>
    
    init() {
        self.weathers = BehaviorRelay(value: weatherArray)
    }
    
    func fetchWeathers() -> Observable<[Weather]> {
        defer {
            self.weathers.accept(self.weatherArray)
        }
        
        return self.weathers.asObservable()
    }
    
    func fetchWeathers(orderedBy keyPath: String) -> Observable<[Weather]> {
        let sorted = self.weatherArray.sorted { (w1, w2) -> Bool in
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
        
        defer {
            self.weatherArray = sorted
            self.weathers.accept(self.weatherArray)
        }
        
        return self.weathers.asObservable()
    }
    
    func add(weather: Weather) {
        self.weatherArray.append(weather)
        self.weathers.accept(self.weatherArray)
    }
    
    func add(weathers: [Weather]) {
        self.weatherArray.append(contentsOf: weathers)
        self.weathers.accept(self.weatherArray)
    }
    
    func update(weather: Weather) {
        for w in self.weatherArray {
            if w.id == weather.id {
                w.cityName = weather.cityName
                w.tempMin = weather.tempMin
                w.tempMax = weather.tempMax
                w.humidity = weather.humidity
                w.condition = weather.condition
                
                self.weathers.accept(self.weatherArray)
                
                return
            }
        }
    }
    
    func delete(weather: Weather) {
        if let index = self.weatherArray.index(of: weather) {
            self.weatherArray.remove(at: index)
            self.weathers.accept(self.weatherArray)
        }
    }
    
    func deleteAll() {
        self.weatherArray.removeAll()
        self.weathers.accept(self.weatherArray)
    }
    
}
