//
//  CitiesCell.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 23/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit

class CitiesCell: UITableViewCell {
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var resume: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
