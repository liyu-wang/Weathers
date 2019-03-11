//
//  WeatherDetailsTableViewController.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ActionSheetPicker_3_0

class WeatherDetailsTableViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var minTempField: UITextField!
    @IBOutlet weak var maxTempField: UITextField!
    @IBOutlet weak var humidityField: UITextField!
    @IBOutlet weak var conditionLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    var viewModel = WeatherDetailsViewModel()
    
    var temperaturePickerView: UIPickerView!
    var humidityPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.configViews()
        self.setupReactive()
    }

}

extension WeatherDetailsTableViewController {
    static func newInstance(with weather: Weather) -> WeatherDetailsTableViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let weatherDetailsVC = storyBoard.instantiateViewController(withIdentifier: "WeatherDetailsTableViewController") as! WeatherDetailsTableViewController
        weatherDetailsVC.viewModel = WeatherDetailsViewModel(with: weather)
        return weatherDetailsVC
    }
}

// MARK: - UI

extension WeatherDetailsTableViewController {
    func configViews() {
        
    }
    
    func configsTextFields() {
//        self.minTempField.inputView
    }
    
    func showWeatherConditionPicker(sender: Any) {
        let rows = WeatherDetailsViewModel.conditions.map{ $0.rawValue }
        ActionSheetStringPicker.show(withTitle: "Weather Condition", rows: rows,
                                     initialSelection: 0,
                                     doneBlock: { (picker, index, value) in
                                        if let text = value as? String {
                                            self.conditionLabel.text = text
                                            self.viewModel.condition.accept(text)
                                        }
                                        self.deselectSelectedCell()
                                     },
                                     cancel: { picker in
                                        self.deselectSelectedCell()
                                     },
                                     origin: sender)
    }
    
    func deselectSelectedCell() {
        if let cells = self.tableView.indexPathsForSelectedRows {
            self.tableView.deselectRow(at: cells.first!, animated: true)
        }
    }
}

// MARK: - RX

extension WeatherDetailsTableViewController {
    func setupReactive() {
        self.viewModel.weather
            .asDriver()
            .drive(onNext: { weather in
                
                guard let w = weather else { return }
                
                self.cityField.text = w.cityName
                self.minTempField.text = "\(w.tempMin)"
                self.maxTempField.text = "\(w.tempMax)"
                self.humidityField.text = "\(w.humidity)"
                self.conditionLabel.text = w.condition
            })
            .disposed(by: disposeBag)
        
        self.saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.save()
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        self.cityField.rx.text.orEmpty
            .bind(to: self.viewModel.cityName)
            .disposed(by: disposeBag)
        
        self.minTempField.rx.text.orEmpty
            .bind(to: self.viewModel.tempMin)
            .disposed(by: disposeBag)

        self.maxTempField.rx.text.orEmpty
            .bind(to: self.viewModel.tempMax)
            .disposed(by: disposeBag)

        self.humidityField.rx.text.orEmpty
            .bind(to: self.viewModel.humidity)
            .disposed(by: disposeBag)
        
        self.viewModel.condition.bind(to: self.conditionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - Table view data source

extension WeatherDetailsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

// MARK: - Table view Delegate

extension WeatherDetailsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 4) {
            let cell = tableView.cellForRow(at: indexPath)
            self.showWeatherConditionPicker(sender: cell!)
        }
    }
}
