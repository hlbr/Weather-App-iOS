//
//  FindAndAddCityViewController.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 24/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import CoreLocation

class FindAndAddCityViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var queryLabel: UITextField!
    
    // IBOulets Actions
    @IBAction func searchCity(_ sender: UITextField) {
        if !(self.queryLabel.text?.isEmpty ?? true) {
            let request = CityQueryRequest(query: self.queryLabel.text!)
            request.RequestAnswerDelegate = self
            request.getOptions()
        }
    }
    @IBAction func cancelInput(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Class Attributes
    var citySuggestions = JSON()

    // View trigered methods
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = .black
    }
}

