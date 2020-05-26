//
//  GlobalVarsAndConsts.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//
import UIKit


// Constants
let deleteNotificationKey = "WeatherAppHLBR.delete.object"
let UpdateNotificationKey = "WeatherAppHLBR.update.object"
let selectNotificationKey = "WeatherAppHLBR.select.object"



// GlobalVar
struct GlobalData {
    static var CitiesWeather = [WeatherResponse?]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: selectNotificationKey),object: nil, userInfo: ["index": 0])
        }
    }
}
