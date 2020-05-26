//
//  FindAndAddCityExtensions.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import CoreLocation

extension FindAndAddCityViewController: CityRequestDelegate, WeatherRequestDelegate{
    // WeatherRequestDelegate
    func onResult(data: NSDictionary, canDismiss: Bool, isNew: Bool, id: NSManagedObjectID?, index: Int?) {
        var resposeObject = WeatherResponse(json: data, canDismiss: canDismiss, id: nil)
        if isNew {
            let id = try? resposeObject.saveData()
            resposeObject.id = id
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
    
    // CityRequestDelegate
    func onResult(options: JSON) {
        citySuggestions = options
        DispatchQueue.main.sync {
            self.table.reloadData()
        }
    }
    
    // Shared Delegate
    func onError(msg: String) {
        let alert = UIAlertController(title: "Parece que algo no está bien", message: msg, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil ))
        present(alert, animated: true, completion: nil)
    }
}

extension FindAndAddCityViewController: UITableViewDataSource, UITableViewDelegate {
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
        cell.backgroundColor = .black
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
}
