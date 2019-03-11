//
//  WeatherDao.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherDao {
    func fetchWeathers() -> Observable<[Weather]>
    func fetchWeathers(orderedBy keyPath: String) -> Observable<[Weather]>
    
    func add(weather: Weather)
    func add(weathers: [Weather])
    
    func update(weather: Weather)
    
    func delete(weather: Weather)
    func deleteAll()
}
