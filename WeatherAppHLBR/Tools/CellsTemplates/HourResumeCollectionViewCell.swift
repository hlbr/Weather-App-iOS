//
//  HourResumeCollectionViewCell.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit

class HourResumeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var resume: UILabel!
    @IBOutlet weak var presure: UILabel!
    @IBOutlet weak var hour: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
