//
//  WeatherResponse.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 22/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import CoreData

struct WeatherResponse {
    private let maxTemp: NSNumber
    private let minTemp: NSNumber
    let cityName: String
    let current: NSNumber
    let isDismissible: Bool
    let cityId: NSNumber
    let resume: String
    var id: ObjectIdentifier?
    init(json: NSDictionary, canDismiss: Bool, id: ObjectIdentifier?) {
        guard let main: NSDictionary = json["main"] as? NSDictionary else {
            self.current = NSNumber(integerLiteral: 0)
            self.maxTemp = NSNumber(integerLiteral: 0)
            self.minTemp = NSNumber(integerLiteral: 0)
            self.cityName = " "
            self.cityId = NSNumber(integerLiteral: 0)
            self.isDismissible = true
            self.resume = ""
            self.id = id
            return
        }
        self.current = main["temp"] as! NSNumber
        self.maxTemp = main["temp_max"] as! NSNumber
        self.minTemp = main["temp_min"] as! NSNumber
        self.cityName = json["name"] as! String
        self.isDismissible = canDismiss
        self.cityId = json["id"] as! NSNumber
        let weather = json["weather"] as! NSArray
        let descriptionObject = weather[0] as! NSDictionary
        self.id = id
        self.resume = descriptionObject["description"] as! String
    }
    
    func range () -> String {
        return "\(Int(truncating: self.maxTemp))ºC - \(Int(truncating: self.minTemp))ºC"
    }
    
    func saveData() throws{
        let context = AppDelegate().managedObjectContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Cities", into: context)
        entity.setValue(Int64(truncating: self.current), forKey: "current")
        entity.setValue(Float(truncating: self.cityId), forKey: "cityId")
        entity.setValue(self.cityName, forKey: "cityName")
        if self.isDismissible {
            entity.setValue(1.0, forKey: "isDismissable")
        }   else {
            entity.setValue(0.0, forKey: "isDismissable")
        }
        try? context.save()
    }
}
