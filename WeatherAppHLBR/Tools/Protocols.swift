//
//  Protocols.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import CoreData
import SwiftyJSON

protocol WeatherRequestDelegate {
    func onResult(data: NSDictionary, canDismiss: Bool, isNew: Bool, id: NSManagedObjectID?, index: Int?)
    func onError(msg: String)
}

protocol CityRequestDelegate {
    func onResult(options: JSON)
    func onError(msg: String)
}

protocol CityHistoryRequestDelegate {
    func onResult(history: [CityHistoryHourlyResume])
    func onError(msg: String)
}
