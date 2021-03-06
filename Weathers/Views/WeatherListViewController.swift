//
//  WeatherListViewController.swift
//  Weathers
//
//  Created by Liyu Wang on 9/3/19.
//  Copyright © 2019 Liyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherListViewController: UIViewController {

    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let bag = DisposeBag()
    
    private var viewModel = WeatherListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configViews()
        self.setupReactive()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: { context in
                    self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }) { context in
                    if context.isCancelled {
                        self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
                    }
                }
            } else {
                self.tableView.deselectRow(at: selectedIndexPath, animated: animated)
            }
        }
    }
}

// MARK: - UI Config

extension WeatherListViewController {
    private func configViews() {
        
        self.tableView.rx.setDelegate(self).disposed(by: bag)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
    }
}

// MARK: - RX

extension WeatherListViewController {
    private func setupReactive() {
        self.viewModel.weathers
            .bind(to: tableView.rx.items(cellIdentifier: "WeatherTableViewCell", cellType: WeatherTableViewCell.self)) { (row, weather, cell) in
                cell.cityLabel.text = weather.cityName
                cell.temperatureLabel.text = "\(weather.tempMin)°C to \(weather.tempMax)°C"
                cell.humidityLabel.text = "Humidity: \(weather.humidity)%"
                cell.conditionLabel.text = "\(weather.condition)"
                cell.conditionImageView.image = UIImage(named: WeatherCondition(rawValue: weather.condition)!.iconName)
            }
            .disposed(by: bag)
        
        self.tableView.rx.modelDeleted(Weather.self)
            .subscribe(onNext: { [weak self] w in
                self?.viewModel.delete(weather: w)
            })
            .disposed(by: bag)
        
        self.tableView.rx.modelSelected(Weather.self)
            .subscribe(onNext: { [weak self] w in
                let detailsVC = WeatherDetailsTableViewController.newInstance(with: w)
                self?.navigationController?.pushViewController(detailsVC, animated: true)
            })
            .disposed(by: bag)
        
        self.sortButton.rx.tap
            .subscribe(onNext: { [weak self] w in
                self?.showSortActionSheet()
            })
            .disposed(by: bag)
    }
}

// MARK: - UI

extension WeatherListViewController {
    private func showSortActionSheet() {
        let actionSheet = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        let nameAction = UIAlertAction(title: "Name", style: .default) { (action) in
            self.viewModel.orderBy(key: .name)
        }
        let maxTempAction = UIAlertAction(title: "Max Temperature", style: .default) { (action) in
            self.viewModel.orderBy(key: .tempMax)
        }
        let minTempAction = UIAlertAction(title: "Min Temperature", style: .default) { (action) in
            self.viewModel.orderBy(key: .tempMin)
        }
        actionSheet.addAction(nameAction)
        actionSheet.addAction(maxTempAction)
        actionSheet.addAction(minTempAction)
        
        actionSheet.popoverPresentationController?.barButtonItem = self.sortButton
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension WeatherListViewController: UITableViewDelegate {

}
