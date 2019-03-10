//
//  Weather.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var cityName: String = ""
    @objc dynamic var tempMin: Float = 0.0
    @objc dynamic var tempMax: Float = 0.0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var condition: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override var description: String {
        return "\(super.description) :\(self.id) \(self.cityName)"
    }
}
