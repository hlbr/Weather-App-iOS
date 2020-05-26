//
//  CityHistoryResponse.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//
import SwiftyJSON

struct CityHistoryHourlyResume {
    let resume: String
    let current: String
    let sensation: String
    let windSpeed: String
    let humidity: String
    let pressure: String
    let time: Date
    let date: Double
    init (singleData: JSON) {
        current = "\(singleData["temp"]) ºC"
        let weather = singleData["weather"]
        resume = "\(weather[0]["description"])"
        sensation = "\(singleData["feels_like"]) ºC"
        windSpeed = "\(singleData["wind_speed"]) m/s"
        humidity = "\(singleData["humidity"]) %"
        pressure = "\(singleData["pressure"]) hPa"
        let timestamp = singleData["dt"].double!
        time = Date(timeIntervalSince1970: timestamp)
        date =  timestamp
    }
}
