//
//  WeatherListViewModel.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherListViewModel {
    public enum SortKey: String {
        case name = "cityName"
        case tempMin = "tempMin"
        case tempMax = "tempMax"
    }
    
    // Out
    let weathers: BehaviorRelay<[Weather]>
    
    private let bag = DisposeBag()
    private let weatherDao: WeatherDao
    
    private var weathersObservable: Observable<[Weather]>
    private var weathersDisposable: Disposable?
    
    init(weatherDao: WeatherDao = WeatherDaoImpl()) {
        self.weathers = BehaviorRelay(value: [])
        self.weatherDao = weatherDao
        
        self.weathersObservable = self.weatherDao.fetchWeathers()
        self.weathersDisposable = self.weathersObservable.bind(to: self.weathers)
        self.weathersDisposable?.disposed(by: bag)
    }
    
    func delete(weather: Weather) {
        self.weatherDao.delete(weather: weather)
    }
    
    mutating func orderBy(key: SortKey) {
        self.weathersDisposable?.dispose()
        self.weathersObservable = self.weatherDao.fetchWeathers(orderedBy: key.rawValue)
        self.weathersDisposable = self.weathersObservable.bind(to: self.weathers)
        self.weathersDisposable?.disposed(by: bag)
    }
}
