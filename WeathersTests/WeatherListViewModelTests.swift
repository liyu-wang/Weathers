//
//  WeatherListViewModelTests.swift
//  WeathersTests
//
//  Created by Liyu Wang on 11/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import XCTest
@testable import Weathers
import RxSwift

class WeatherListViewModelTests: XCTestCase {

    var weatherDao: WeatherDao!
    var viewModel: WeatherListViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.weatherDao = MockWeatherDao()
        self.weatherDao.deleteAll()
        self.weatherDao.add(weathers: getTestWeathers())
        
        self.viewModel = WeatherListViewModel(weatherDao: self.weatherDao)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.weatherDao.deleteAll()
        self.weatherDao = nil
        self.viewModel = nil
    }

    func testFetchWeathers() {
        _ = self.viewModel.weathers.subscribe(onNext: { (weathers) in
            XCTAssertEqual(weathers.count, 3, "Expected 3 weathers from data source.")
        })
    }
    
    func testDeleteWeather() {
        if let w = self.viewModel.weathers.value.first {
            self.viewModel.delete(weather: w)
        } else {
            XCTAssert(false, "Can't get any weather from the data source.")
        }
        
        _ = self.viewModel.weathers.skip(1).subscribe(onNext: { (weathers) in
            XCTAssertEqual(self.viewModel.weathers.value.count, 2, "Expected 3 weathers from data source after deletion.")
        })
    }
    
    func testOrderbyMaxTemperature() {
        self.viewModel.orderBy(key: .tempMax)
        
        _ = self.viewModel.weathers.skip(1).subscribe(onNext: { (weathers) in
            XCTAssertLessThanOrEqual(weathers[0].tempMax, weathers[1].tempMax)
            XCTAssertLessThanOrEqual(weathers[1].tempMax, weathers[2].tempMax)
        })
    }

}

extension WeatherListViewModelTests {
    func getTestWeathers() -> [Weather] {
        var array: [Weather] = []
        
        let w1 = Weather()
        w1.id = UUID().uuidString
        w1.cityName = "Brisbane"
        w1.tempMin = 23
        w1.tempMax = 28
        w1.humidity = 75
        w1.condition = WeatherCondition.sunny.rawValue
        array.append(w1)
        
        let w2 = Weather()
        w2.id = UUID().uuidString
        w2.cityName = "Melbourne"
        w2.tempMin = 15
        w2.tempMax = 23
        w2.humidity = 88
        w2.condition = WeatherCondition.windy.rawValue
        array.append(w2)
        
        let w3 = Weather()
        w3.id = UUID().uuidString
        w3.cityName = "Sydney"
        w3.tempMin = 19
        w3.tempMax = 25
        w3.humidity = 80
        w3.condition = WeatherCondition.windy.rawValue
        array.append(w3)
        
        return array
    }
}
