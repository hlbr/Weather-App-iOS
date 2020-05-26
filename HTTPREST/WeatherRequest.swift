//
//  WeatherRequest.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 22/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import CoreLocation
import CoreData


class WeatherRequest {
    private let apiKey: String = "65e519a21a4b9daf5575b20800280d2b"
    private var stringURL: String!

    var RequestAnswerDelegate: WeatherRequestDelegate!
    var locationC: CLLocationCoordinate2D?
    var request: URLSessionDataTask!
    let canDismiss: Bool
    let storeValue: Bool
    let objectId: NSManagedObjectID?
    let i: Int?
    init?(coordinates: CLLocationCoordinate2D?,isDismissible: Bool, isNew: Bool, id: NSManagedObjectID?, index: Int?) {
        locationC = coordinates
        canDismiss = isDismissible
        storeValue = isNew
        objectId = id
        i = index
        stringURL = getURL(lat: locationC!.latitude, lon: locationC!.longitude, apiKey: apiKey)
    }
    init?(cityID: NSNumber, isNew: Bool, id: NSManagedObjectID?, index: Int?) {
        canDismiss = true
        storeValue = isNew
        objectId = id
        i = index
        stringURL = getURL(cityId: cityID)
    }
       
   private func getURL(cityId: NSNumber) -> String {
       return "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=\(apiKey)&units=metric&lang=es"
   }
    
    private func getURL(lat: Double, lon: Double, apiKey: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=es"
    }
    func prepareRequest() {
        let urlR = URL(string: stringURL!)!
        request = URLSession.shared.dataTask(with: urlR) { data, response, error in
            guard let data = data, error == nil else {
                self.RequestAnswerDelegate.onError(msg: "Error al obtener datos")
                return
            }
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                self.RequestAnswerDelegate.onResult(data: jsonObj as! NSDictionary, canDismiss: self.canDismiss, isNew: self.storeValue, id: self.objectId, index: self.i)
            } catch {
                self.RequestAnswerDelegate.onError(msg: "Error al serializar JSON")
            }
        }
    }
}
