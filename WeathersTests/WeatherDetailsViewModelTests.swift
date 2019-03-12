//
//  WeatherDetailsViewModelTests.swift
//  WeathersTests
//
//  Created by Liyu Wang on 11/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import XCTest
@testable import Weathers

class WeatherDetailsViewModelTests: XCTestCase {

    var weatherDao: WeatherDao!
    var viewModel: WeatherDetailsViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.weatherDao = MockWeatherDao()
        self.weatherDao.deleteAll()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.weatherDao.deleteAll()
        self.weatherDao = nil
        self.viewModel = nil
    }

    func testSaveWeatherSuccess() {
        self.viewModel = WeatherDetailsViewModel(with: nil, weatherDao: self.weatherDao)
        
        self.viewModel.cityName.accept("Brisbane")
        self.viewModel.tempMin.accept("23")
        self.viewModel.tempMax.accept("28")
        self.viewModel.humidity.accept("75")
        self.viewModel.condition.accept(WeatherCondition.sunny.rawValue)
        
        self.viewModel.save()
        
        let weatherListViewModel = WeatherListViewModel(weatherDao: self.weatherDao)
        
        _ = weatherListViewModel.weathers.subscribe(onNext: { (weathers) in
            XCTAssertEqual(weathers.count, 1, "Expected 1 weather from data source.")
        })
    }
    
    func testSaveWeatherUnsuccess() {
        self.viewModel = WeatherDetailsViewModel(with: nil, weatherDao: self.weatherDao)
        
        self.viewModel.cityName.accept("Brisbane")
        self.viewModel.tempMin.accept("abc")
        self.viewModel.tempMax.accept("def")
        self.viewModel.humidity.accept("ghi")
        self.viewModel.condition.accept(WeatherCondition.sunny.rawValue)
        
        self.viewModel.save()
        
        let weatherListViewModel = WeatherListViewModel(weatherDao: self.weatherDao)
        
        _ = weatherListViewModel.weathers.subscribe(onNext: { (weathers) in
            XCTAssertEqual(weathers.count, 0, "Expected 0 weather from data source.")
        })
    }
    
    func testValidateEmptyFields() {
        self.viewModel = WeatherDetailsViewModel(with: nil, weatherDao: self.weatherDao)
        
        self.viewModel.save()
        
        let errors = self.viewModel.validateFields()
        var flag = false
        for e in errors {
            if case .emptyFields = e {
                flag = true
                break
            }
        }
        XCTAssertTrue(flag, "Expected empty field error")
    }
    
    func testValidateMaxMinTemperatures() {
        self.viewModel = WeatherDetailsViewModel(with: nil, weatherDao: self.weatherDao)
        
        self.viewModel.cityName.accept("Brisbane")
        self.viewModel.tempMin.accept("30")
        self.viewModel.tempMax.accept("10")
        
        self.viewModel.save()
        
        let errors = self.viewModel.validateFields()
        var flag = false
        for e in errors {
            if case .invalidMaxTemperature = e {
                flag = true
                break
            }
        }
        XCTAssertTrue(flag, "Expected invalid max temperature error.")
    }
    
    func testValidateHumidity() {
        self.viewModel = WeatherDetailsViewModel(with: nil, weatherDao: self.weatherDao)
        
        self.viewModel.cityName.accept("Brisbane")
        self.viewModel.humidity.accept("10000")
        
        self.viewModel.save()
        
        let errors = self.viewModel.validateFields()
        var flag = false
        for e in errors {
            if case .invalidHumidity = e {
                flag = true
                break
            }
        }
        XCTAssertTrue(flag, "Expected invalid humidity error.")
    }

}
