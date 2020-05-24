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

class HomeScreen: UIViewController, CLLocationManagerDelegate, WeatherRequestDelegate {
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Request access to current location
        RequestAuthorization()

    }
    private var weatherHandler: WeatherRequest!
    var cities = [WeatherResponse]()
    private func RequestAuthorization() {
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
//
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let coordinates: CLLocationCoordinate2D = manager.location?.coordinate else {
            // Warn user something went wrong
            return
        }
        let myCities = Cities.getAllCities()
        var fecthedCities = try? AppDelegate().managedObjectContext.fetch(myCities)
//        var deleteRequet = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Cities"))
//        try? AppDelegate().managedObjectContext.execute(deleteRequet)
        //        try? AppDelegate().managedObjectContext.save()
        let length = fecthedCities!.count
        cities.removeAll()
        if length == 0 {
            let a = WeatherRequest(coordinates: coordinates, isNew: true, id: nil)
                a?.RequestAnswerDelegate = self
                a?.prepareRequest()
                a?.request.resume()
        } else {
            for city in fecthedCities! {
                if city.isDismissable == 0 {
                    let a = WeatherRequest(cityID:  city.cityId!, isNew: false, id: city.id)
                    a?.RequestAnswerDelegate = self
                    a?.prepareRequest()
                    a?.request.resume()
                } else {
                    let a = WeatherRequest(coordinates: coordinates, isNew: false, id: city.id)
                    a?.RequestAnswerDelegate = self
                    a?.prepareRequest()
                    a?.request.resume()
                }

            }
        }
    }
    // WeatherRequestDelegate
    func onResult(data: NSDictionary, canDismiss: Bool, isNew: Bool, id: ObjectIdentifier?) {
        var resposeObject = WeatherResponse(json: data, canDismiss: canDismiss, id: nil)
        if isNew {
            try? resposeObject.saveData()
        } else {
            resposeObject.id = id
        }
        cities.append(resposeObject)
    }
    
    func onError(msg: String) {
        print(msg)
    }
}

