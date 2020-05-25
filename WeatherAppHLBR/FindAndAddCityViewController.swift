//
//  FindAndAddCityViewController.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 24/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import CoreLocation



class FindAndAddCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CityRequestDelegate, WeatherRequestDelegate {
    func onResult(options: JSON) {
        citySuggestions = options
        DispatchQueue.main.sync {
            self.table.reloadData()
        }
    }
    
    func onError(msg: String) {
        print(msg)
    }
    @IBOutlet weak var table: UITableView!
    
    var citySuggestions = JSON()
    @IBOutlet weak var queryLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
    }


    @IBAction func searchCity(_ sender: UITextField) {
        if !(self.queryLabel.text?.isEmpty ?? true) {
            let request = CityQueryRequest(query: self.queryLabel.text!)
            request.RequestAnswerDelegate = self
            request.getOptions()
        }
    }
    
    @IBAction func cancelInput(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citySuggestions.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let latitude = citySuggestions[indexPath.row]["lat"].stringValue
        let longitude = citySuggestions[indexPath.row]["lng"].stringValue
        let coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(Double(latitude)!), CLLocationDegrees(Double(longitude)!))
        let a = WeatherRequest(coordinates: coordinates, isDismissible: true, isNew: true, id: nil, index: nil)
        a?.RequestAnswerDelegate = self
        a?.prepareRequest()
        a?.request.resume()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.textLabel?.text = placeString(from: citySuggestions[indexPath.row])
        cell.textLabel?.textColor = .white
        return cell
    }
    func placeString(from: JSON) -> String {
        let country = from["countryName"]
        let state = from["adminName1"]
        let place = from["name"]
        return "\(place), \(state), \(country)"
    }
    
    // WeatherRequestDelegate
    func onResult(data: NSDictionary, canDismiss: Bool, isNew: Bool, id: NSManagedObjectID?, index: Int?) {
        var resposeObject = WeatherResponse(json: data, canDismiss: canDismiss, id: nil)
        if isNew {
            try? resposeObject.saveData()
            GlobalData.CitiesWeather.append(resposeObject)
            DispatchQueue.main.sync {
                NotificationCenter.default.post(name: Notification.Name(UpdateNotificationKey), object: nil)
                self.dismiss(animated: true, completion: nil)
            }

        } else {
            resposeObject.id = id
            if GlobalData.CitiesWeather.count > index!{
                GlobalData.CitiesWeather[index!] = resposeObject
            } else {
                GlobalData.CitiesWeather.append(resposeObject)
            }
        }
    }
    
}

