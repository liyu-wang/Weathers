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

enum WeatherCondition: String {
    case cloudy = "Cloudy"
    case snow = "Snow"
    case sunny = "Sunny"
    case rainy = "Rainy"
    case windy = "Windy"
    
    
    var iconName: String {
        switch self {
        case .cloudy:
            return "cloudy"
        case .snow:
            return "snow"
        case .sunny:
            return "sunny"
        case .rainy:
            return "rainy"
        case .windy:
            return "windy"
        }
    }
}



struct WeatherDetailsViewModel {
    static let conditions: [WeatherCondition] = [.cloudy, .snow, .sunny, .rainy, .windy]
    
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
        
        self.cityName = BehaviorRelay(value: "")
        self.tempMin = BehaviorRelay(value: "")
        self.tempMax = BehaviorRelay(value: "")
        self.humidity = BehaviorRelay(value: "")
        if let w = weather {
            self.condition = BehaviorRelay(value: w.condition)
            self.isUpdate = true
        } else {
            self.condition = BehaviorRelay(value: "n/a")
            self.isUpdate = false
        }
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
