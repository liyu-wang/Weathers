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
    let weather: BehaviorRelay<Weather?>
    
    // In binding
    let cityName: BehaviorRelay<String>
    let tempMin: BehaviorRelay<String>
    let tempMax: BehaviorRelay<String>
    let humidity: BehaviorRelay<String>
    let condition: BehaviorRelay<String>
    
    var isUpdate: Bool
    
    init(with weather: Weather? = nil, weatherDao: WeatherDao = WeatherDaoImpl()) {
        self.weather = BehaviorRelay(value: weather)
        self.weatherDao = weatherDao
        self.isUpdate = weather != nil
        
        self.cityName = BehaviorRelay(value: "")
        self.tempMin = BehaviorRelay(value: "")
        self.tempMax = BehaviorRelay(value: "")
        self.humidity = BehaviorRelay(value: "")
        self.condition = BehaviorRelay(value: "")
    }
    
    func save() {
        let weather = Weather()
        if let w = self.weather.value {
            weather.id = w.id
        } else {
            weather.id = UUID().uuidString
        }
        
        weather.cityName = self.cityName.value
        weather.tempMin = Float(self.tempMin.value)!
        weather.tempMax = Float(self.tempMax.value)!
        weather.humidity = Int(self.humidity.value)!
        weather.condition = self.condition.value
        
        if isUpdate {
            self.weatherDao.update(weather: weather)
        } else {
            self.weatherDao.add(weather: weather)
        }
    }
    
    func validateFields() {
        
    }
}
