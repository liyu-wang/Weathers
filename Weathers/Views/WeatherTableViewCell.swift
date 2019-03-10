//
//  WeatherTableViewCell.swift
//  Weathers
//
//  Created by Liyu Wang on 10/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(_ model: Any) {
        if let w = model as? Weather {
            self.cityLabel.text = w.cityName
//            self.temperatureLabel.text = "\(w.tempMin) - \(w.tempMax)"
//            self.humidityLabel.text = "\(w.humidity)"
        }
    }
}
