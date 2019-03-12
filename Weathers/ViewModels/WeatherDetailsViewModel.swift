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

enum ValidationError {
    case emptyFields(String)
    case invalidMinTemperature(String)
    case invalidMaxTemperature(String)
    case invalidHumidity(String)
}

fileprivate let notAvailableStr = "n/a"

struct WeatherDetailsViewModel {
    static let conditions: [WeatherCondition] = [.cloudy, .snow, .sunny, .rainy, .windy]
    
    // Out binding
    let weather: BehaviorRelay<Weather?>
    let validationErrors = BehaviorRelay<[ValidationError]>(value: [])
    
    // In binding
    let cityName: BehaviorRelay<String>
    let tempMin: BehaviorRelay<String>
    let tempMax: BehaviorRelay<String>
    let humidity: BehaviorRelay<String>
    let condition: BehaviorRelay<String>
    
    private let weatherDao: WeatherDao
    private var isUpdate: Bool
    
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
            self.condition = BehaviorRelay(value: notAvailableStr)
            self.isUpdate = false
        }
    }
    
    func save() {
        let errors = validateFields()
        if !errors.isEmpty {
            self.validationErrors.accept(errors)
            return
        }
        
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
    
    func validateFields() -> [ValidationError] {
        var fields:[String] = []
        var errors:[ValidationError] = []
        
        if self.cityName.value.isEmpty {
            fields.append("City")
        }
        
        if !self.tempMin.value.isEmpty {
            if let _ = Float(self.tempMin.value) {
                
            } else {
                errors.append(.invalidMinTemperature("Invalid min temperature."))
            }
        } else {
            fields.append("Min Temperature")
        }
        
        if !self.tempMax.value.isEmpty {
            if let tempMax = Float(self.tempMax.value) {
                if let tempMin = Float(self.tempMin.value) {
                    if (tempMax < tempMin) {
                        errors.append(.invalidMaxTemperature("Max temperature should be greater than min temperature."))
                    }
                }
            } else {
                errors.append(.invalidMaxTemperature("Invalid max temperature."))
            }
        } else {
            fields.append("Max Temperature")
        }
        
        if !self.humidity.value.isEmpty {
            var isValid = true
            if let humidity = Int(self.humidity.value) {
                if !(humidity >= 0 && humidity <= 100) {
                    isValid = false
                }
            } else {
                isValid = false
            }
            
            if !isValid {
                errors.append(ValidationError.invalidHumidity("Humidity should be between 0 and 100."))
            }
        } else {
            fields.append("Humidity")
        }
        
        if self.condition.value == notAvailableStr {
            fields.append("Weather Condition")
        }
        
        if !fields.isEmpty {
            let msg = "Please fill in empty fields:\n \(fields.joined(separator: "\n"))"
            errors.append(.emptyFields(msg))
        }
        
        return errors
    }
}
