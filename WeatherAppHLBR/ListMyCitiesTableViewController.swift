//
//  AddCityTableViewController.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 23/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit

class ListMyCitiesTableViewController: UITableViewController {
    var citiesToDisplay = [WeatherResponse]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CitiesCell", bundle: nil), forCellReuseIdentifier: "CitiesCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesToDisplay.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesCell", for: indexPath) as! CitiesCell
        cell.cityName.text = citiesToDisplay[indexPath.row].cityName
        cell.current.text = "\(citiesToDisplay[indexPath.row].current) ºC"
        cell.resume.text = citiesToDisplay[indexPath.row].resume
        return cell
    }
}

