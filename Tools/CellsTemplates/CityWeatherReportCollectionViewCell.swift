//
//  CityWeatherReportCollectionViewCell.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 25/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit

class CityWeatherReportCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var resumteLabel: UILabel!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var range: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
