//
//  ListMyCitiesTableViewController.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 23/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import CoreData


class ListMyCitiesTableViewController: UITableViewController {
    // View trigered methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CitiesCell", bundle: nil), forCellReuseIdentifier: "CitiesCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTable(_:)), name: Notification.Name(UpdateNotificationKey), object: nil)

    }
    
    // Notification management
    @objc private func updateTable(_ notification: Notification){
        tableView.reloadData()
     }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // Table View Controller Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        NotificationCenter.default.post(name: Notification.Name(rawValue: selectNotificationKey),object: nil, userInfo: ["index": index])
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if !GlobalData.CitiesWeather[indexPath.row]!.isDismissible {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let name = Notification.Name(rawValue: deleteNotificationKey)
            let id = GlobalData.CitiesWeather[indexPath.row]!.id
            let info = ["objectId": id!]
            NotificationCenter.default.post(name: name, object: nil, userInfo: info)
            GlobalData.CitiesWeather.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.CitiesWeather.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesCell", for: indexPath) as! CitiesCell
        cell.cityName.text = GlobalData.CitiesWeather[indexPath.row]!.cityName
        cell.current.text = "\(Int(truncating:GlobalData.CitiesWeather[indexPath.row]!.current)) ºC"
        cell.resume.text = GlobalData.CitiesWeather[indexPath.row]!.resume
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let button = UIButton(type: .contactAdd)
        button.tintColor = .systemBlue
        button.frame = CGRect(x: view.bounds.width - 40, y: 20, width: 30, height: 30)
        button.addTarget(self, action: #selector(self.lookForCity), for: .touchDown)
        footerView.addSubview(button)
        return footerView
    }
    
    @objc func lookForCity () {
        let vc = storyboard?.instantiateViewController(identifier: "FindCity")
        vc?.modalPresentationStyle = .pageSheet
        present(vc!, animated: true, completion: nil)
    }
    
}

