//
//  CityHistoryRequest.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import CoreData
import SwiftyJSON
import UIKit

class CityHistoryRequest {
    private let apiKey: String = "65e519a21a4b9daf5575b20800280d2b"
    let latitude: NSNumber
    let longitude: NSNumber
    var RequestAnswerDelegate: CityHistoryRequestDelegate!

    init (lat: NSNumber, lon: NSNumber){
        latitude = lat
        longitude = lon
    }
    
    private func getURL(date: Int) -> String {
        return "https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric&lang=es&dt=\(date)"
    }
    
    // Recursively get each day
    func getHistory(_ day: Double = 1, _ results: [JSON] = [] ){
        let daySeconds: Double = 24 * 60 * 60
        let requestDate = NSDate().timeIntervalSince1970 - daySeconds * day
        let urlR = URL(string: getURL(date: Int(requestDate)))!
        let request = URLSession.shared.dataTask(with: urlR) { data, response, error in
            guard let data = data, error == nil else {
                self.RequestAnswerDelegate.onError(msg: "Error al obtener datos")
                return
            }
            let jsonObj = JSON(data)
            var arrCopy = results
            arrCopy.append(jsonObj)
            if day == 5 {
                var CityHistoryResponse = self.CityHistoryResponse(objectToConvert: arrCopy)
                CityHistoryResponse.sort(by: {$0.date < $1.date})
                self.RequestAnswerDelegate.onResult(history: CityHistoryResponse)
            } else {

                self.getHistory(day + 1, arrCopy)
            }
        }
        request.resume()
    }
    
    private func CityHistoryResponse(objectToConvert: [JSON]) -> [CityHistoryHourlyResume] {
        var result: [CityHistoryHourlyResume] = []
        for item in objectToConvert {
            for hourlyItem in item["hourly"] {
                let (_, data) = hourlyItem
                result.append(CityHistoryHourlyResume(singleData: data))

            }
            
        }
        return result
    }
     
}
