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
    let weatherDao: WeatherDao
    
    // Out
    let weatherListObservable: Observable<(Array<Weather>, RealmChangeset?)>
    
    init(weatherDao: WeatherDao = WeatherDaoImpl()) {
        self.weatherDao = weatherDao
        
        let result = self.weatherDao.fetchWeathers()
        self.weatherListObservable = Observable.arrayWithChangeset(from: result)
    }
    
    func delete(_ weather: Weather) {
        self.weatherDao.delete(weather: weather)
    }
}
