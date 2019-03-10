//
//  WeatherListViewModel.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct WeatherListViewModel {
    public enum SortKey: String {
        case name = "cityName"
        case tempMin = "tempMin"
        case tempMax = "tempMax"
    }
    
    let weatherDao: WeatherDao
    
    // Out
    var result: Results<Weather>
    var weathers: Observable<[Weather]>
    
    init(weatherDao: WeatherDao = WeatherDaoImpl()) {
        self.weatherDao = weatherDao
        
        self.result = self.weatherDao.fetchWeathers()
        self.weathers = Observable.array(from: self.result)
    }
    
//    func deleteWeather(at index: Int) {
//        let weather = result[index]
//        self.weatherDao.delete(weather: weather)
//    }
    
    func delete(weather: Weather) {
        self.weatherDao.delete(weather: weather)
    }
    
    mutating func orderBy(key: SortKey) {
        self.result = self.result.sorted(byKeyPath: key.rawValue)
        self.weathers = Observable.array(from: self.result)
    }
}
