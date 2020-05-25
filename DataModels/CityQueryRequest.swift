//
//  CityQueryRequest.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 24/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import SwiftyJSON
protocol CityRequestDelegate {
    func onResult(options: JSON)
    func onError(msg: String)
}

class CityQueryRequest {
    let Query: String?
    var RequestAnswerDelegate: CityRequestDelegate!
    
    init(query: String) {
        Query = query
    }
    
    func getOptions() {
        let stringURL = getURL(query: Query!)
        let urlR = URL(string: stringURL)!
        let request = URLSession.shared.dataTask(with: urlR) { data, response, error in
            guard let data = data, error == nil else {
                self.RequestAnswerDelegate.onError(msg: "Error al obtener datos")
                return
            }
            let jsonObj = JSON(data)
            self.RequestAnswerDelegate.onResult(options: jsonObj["geonames"])
        }
        request.resume()
    }
    private func getURL(query: String) -> String {
        return "http://api.geonames.org/searchJSON?maxRows=5&username=hectorlbr956&q=\(encodeString(query: query))"
    }
    private func encodeString(query: String) -> String {
        return query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
