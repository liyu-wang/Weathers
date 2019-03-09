//
//  WeatherDetailsViewModel.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherDetailsViewModel {
    let weatherDao: WeatherDao
    
    // Out binding
    let weather: BehaviorRelay<Weather>
    
    // In binding
    let cityName: BehaviorRelay<String>
    let temperature: BehaviorRelay<Int>
    let tempMin: BehaviorRelay<Int>
    let tempMax: BehaviorRelay<Int>
    let humidity: BehaviorRelay<Int>
    let condition: BehaviorRelay<String>
    
    var isUpdate: Bool
    
    init(with weather: Weather?, weatherDao: WeatherDao = WeatherDaoImpl()) {
        self.weatherDao = weatherDao
        
        if let w = weather {
            self.weather = BehaviorRelay(value: w)
            self.isUpdate = true
        } else {
            let w = Weather()
            self.weather = BehaviorRelay(value: w)
            self.isUpdate = false
        }
        
        self.cityName = BehaviorRelay(value: "")
        self.temperature = BehaviorRelay(value: 0)
        self.tempMin = BehaviorRelay(value: 0)
        self.tempMax = BehaviorRelay(value: 0)
        self.humidity = BehaviorRelay(value: 0)
        self.condition = BehaviorRelay(value: "")
    }
    
    func save() {
        if self.isUpdate {
            self.weatherDao.update(weather: self.weather.value)
        } else {
            self.weatherDao.add(weather: self.weather.value)
        }
    }
}
