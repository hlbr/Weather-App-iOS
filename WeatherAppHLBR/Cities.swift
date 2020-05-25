//
//  CityWeather.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 23/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import Foundation
import CoreData
public class Cities: NSManagedObject, Identifiable {
    @NSManaged public var cityId: NSNumber?
    @NSManaged public var cityName: String?
    @NSManaged public var current: NSNumber?
    @NSManaged public var isDismissable: NSNumber?
    @NSManaged public var customId: NSNumber?
}

extension Cities {
    static func getAllCities() -> NSFetchRequest<Cities> {
        let request =  NSFetchRequest<Cities>(entityName: "Cities")
        let sortDescriptor = NSSortDescriptor(key: "isDismissable", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.returnsObjectsAsFaults = false
        return request
    }
}
