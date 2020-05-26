//
//  HistoryOfCityWeatherExtensions.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import SwiftyJSON

extension HistoryOfCityWeatherTableViewController: CityHistoryRequestDelegate {
    
    func onError(msg: String) {
        let alert = UIAlertController(title: "Parece que algo no está bien", message: msg, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil ))
        present(alert, animated: true, completion: nil)
    }
    
    func onResult(history: [CityHistoryHourlyResume]) {
        DispatchQueue.main.sync {
            self.reportOfCity = history
            self.loader.isHidden = true
            self.tableView.reloadData()
        }
    }
}
