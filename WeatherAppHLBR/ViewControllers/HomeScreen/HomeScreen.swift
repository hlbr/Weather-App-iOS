//
//  HomeScreen.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 22/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class HomeScreen: UIViewController {
    // IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pagination: UIPageControl!
    @IBOutlet weak var listCities: UIButton!
    @IBOutlet weak var warningLabel: UILabel!

    // Class attributes
    let locationManager = CLLocationManager()
    private let notificationName = Notification.Name(deleteNotificationKey)
    var fecthedCities: [AnyObject]?
    var length = Int()
    
    // View triggered methods
    override func viewDidLoad() {
       super.viewDidLoad()
       NotificationCenter.default.addObserver(self, selector: #selector(self.deleteObject(_:)), name: notificationName, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.updateTalble(_:)), name: Notification.Name(UpdateNotificationKey), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.passed(_:)), name: Notification.Name(selectNotificationKey), object: nil)
       collectionView.delegate = self
       collectionView.dataSource = self
       collectionView?.register(UINib(nibName: "CityWeatherReportCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CityWeatherReportCollectionViewCell")
       RequestAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       warningLabel.isHidden = false
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

