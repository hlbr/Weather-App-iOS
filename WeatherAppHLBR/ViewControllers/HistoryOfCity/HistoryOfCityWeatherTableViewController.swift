//
//  HistoryOfCityWeatherTableViewController.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import CoreData

class HistoryOfCityWeatherTableViewController: UITableViewController {
    //IBOutlets
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    //Class attributes
    var latitude: NSNumber!
    var longitude: NSNumber!
    var reportOfCity =  [CityHistoryHourlyResume]()
    @objc private func closeView() {
        dismiss(animated:true, completion:nil)
    }
    
    // View triggered methods
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        let getData = CityHistoryRequest(lat: self.latitude!, lon: self.longitude!)
        getData.RequestAnswerDelegate = self
        getData.getHistory()
    }

    // Table View Display
    override func numberOfSections(in tableView: UITableView) -> Int {
        return reportOfCity.count / 24
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        let textView = UITextView()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        textView.text =  dateFormatter.string(from: reportOfCity[section * 24].time)
        textView.font = .preferredFont(forTextStyle: .title1)
        textView.textColor = .systemTeal
        return textView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let start = indexPath.section * 24
        let end = start + 24
        let data = reportOfCity[start..<end]
        cell.rowData = Array(data)
        cell.sizeToFit()
        cell.CollectionView.reloadData()
        return cell
    }
}
