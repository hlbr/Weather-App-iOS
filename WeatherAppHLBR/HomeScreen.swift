//
//  HomeScreen.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 22/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
let deleteNotificationKey = "WeatherAppHLBR.delete.object"
let UpdateNotificationKey = "WeatherAppHLBR.update.object"

struct GlobalData {
    static var CitiesWeather = [WeatherResponse]()
}


class HomeScreen: UIViewController, CLLocationManagerDelegate, WeatherRequestDelegate {
    @IBOutlet weak var pagination: UIPageControl!
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteObject(_:)), name: notificationName, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        // Request access to current location
        RequestAuthorization()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private let notificationName = Notification.Name(deleteNotificationKey)
    private var weatherHandler: WeatherRequest!
    @objc private func deleteObject(_ notification: Notification){
        if let customId = notification.userInfo as? [String: NSManagedObjectID] {
            for item in fecthedCities! {
                if item.objectID == customId["objectId"]! {
                    let context = AppDelegate().managedObjectContext
                    let getItem = context.object(with: item.objectID)
                    context.delete(getItem)
                    try? context.save()
                    break
                }
            }
        }
    }
    var cities = [WeatherResponse]()
    
    private func RequestAuthorization() {
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // Warn this app requires location
            
            //Request access to current location again
            RequestAuthorization()
        }

    }
    private var fecthedCities: [Cities]?
    private var length = Int()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let coordinates: CLLocationCoordinate2D = manager.location?.coordinate else {
            // Warn user something went wrong
            return
        }
        let fectchRequest = Cities.getAllCities()
        fecthedCities = try? AppDelegate().managedObjectContext.fetch(fectchRequest)
//        var deleteRequet = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Cities"))
//        try? AppDelegate().managedObjectContext.execute(deleteRequet)
//                try? AppDelegate().managedObjectContext.save()
        self.length = fecthedCities!.count
        var index = 0
        if length == 0 {
            let a = WeatherRequest(coordinates: coordinates, isDismissible: false, isNew: true, id: nil, index: nil)
                a?.RequestAnswerDelegate = self
                a?.prepareRequest()
                a?.request.resume()
        } else {
            for city in fecthedCities! {
                if city.isDismissable! == 0 {
                    let a = WeatherRequest(coordinates: coordinates, isDismissible: false, isNew: false, id: city.objectID, index: index)
                    a?.RequestAnswerDelegate = self
                    a?.prepareRequest()
                    a?.request.resume()
                } else {
                    let a = WeatherRequest(cityID:  city.cityId!, isNew: false, id: city.objectID, index: index)
                    a?.RequestAnswerDelegate = self
                    a?.prepareRequest()
                    a?.request.resume()
                }
                index += 1

            }
        }
    }
    
    // WeatherRequestDelegate
    func onResult(data: NSDictionary, canDismiss: Bool, isNew: Bool, id: NSManagedObjectID?, index: Int?) {
        var resposeObject = WeatherResponse(json: data, canDismiss: canDismiss, id: nil)
        if isNew {
            try? resposeObject.saveData()
            GlobalData.CitiesWeather.append(resposeObject)
        } else {
            resposeObject.id = id
            if GlobalData.CitiesWeather.count > index!{
                GlobalData.CitiesWeather[index!] = resposeObject
            } else {
                GlobalData.CitiesWeather.append(resposeObject)
            }
        }
    }
    
    func onError(msg: String) {
        print(msg)
    }
}

