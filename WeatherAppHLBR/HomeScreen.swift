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
let deleteNotificationKey = "WeatherAppHLBR.delete.object"
let UpdateNotificationKey = "WeatherAppHLBR.update.object"
let selectNotificationKey = "WeatherAppHLBR.select.object"
struct GlobalData {
    static var CitiesWeather = [WeatherResponse?]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: selectNotificationKey),object: nil, userInfo: ["index": 0])
        }
    }
}


class HomeScreen: UIViewController, CLLocationManagerDelegate, WeatherRequestDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @objc private func passed(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Int] {
            DispatchQueue.main.async {
                self.pagination.numberOfPages = GlobalData.CitiesWeather.count
                self.collectionView.reloadData()
                self.pagination.currentPage = data["index"]!
                let indexPath = IndexPath(row: self.pagination.currentPage, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
         }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalData.CitiesWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityWeatherReportCollectionViewCell", for: indexPath) as! CityWeatherReportCollectionViewCell
        if let cellData = GlobalData.CitiesWeather[indexPath.row] {
            cell.cityName.text = cellData.cityName
            cell.cityName.adjustsFontSizeToFitWidth = true
            cell.current.text = "\(Int(truncating: cellData.current)) º"
            cell.range.text = cellData.range()
            cell.resumteLabel.text = cellData.resume
        }
        cell.sizeToFit()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let row = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        let indexPath = IndexPath(row: row, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.pagination.currentPage = row
    }
    
    @IBOutlet weak var pagination: UIPageControl!
    @IBOutlet weak var listCities: UIButton!
    private let locationManager = CLLocationManager()
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private let notificationName = Notification.Name(deleteNotificationKey)
    private var weatherHandler: WeatherRequest!
    @objc private func deleteObject(_ notification: Notification){
        if let customId = notification.userInfo as? [String: NSManagedObjectID] {
            let context = AppDelegate().managedObjectContext
            let getItem = context.object(with: customId["objectId"]!)
            context.delete(getItem)
            try? context.save()
        }
    }
    @IBOutlet weak var warningLabel: UILabel!
    @objc private func updateTalble(_ notification: Notification) {
        self.collectionView.reloadData()
    }
    private func RequestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
              locationManager.delegate = self
              locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
              locationManager.startUpdatingLocation()
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
                break
            case .restricted, .denied:
                warningLabel.isHidden = false
            
            @unknown default:
                break
            }
        }

    }
    private var fecthedCities: [AnyObject]?
    private var length = Int()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        warningLabel.isHidden = true
        collectionView.isHidden = false
        guard let coordinates: CLLocationCoordinate2D = manager.location?.coordinate else {
            // Warn user something went wrong
            return
        }
        let fectchRequest = Cities.getAllCities()
        fecthedCities = try? AppDelegate().managedObjectContext.fetch(fectchRequest)

        self.length = fecthedCities!.count
        GlobalData.CitiesWeather = Array(repeating: nil, count: self.length)
        var index = 0
        if length == 0 {
            length = 1
            let a = WeatherRequest(coordinates: coordinates, isDismissible: false, isNew: true, id: nil, index: nil)
                a?.RequestAnswerDelegate = self
                a?.prepareRequest()
                a?.request.resume()
        } else {
            for city in fecthedCities! {
                if city.isDismissable! == 0 {
                    let a = WeatherRequest(coordinates: coordinates, isDismissible: false, isNew: false, id: city.objectID, index: index)
                    a?.RequestAnswerDelegate = self
                    a?.prepareRequest()
                    a?.request.resume()
                } else {
                    let a = WeatherRequest(cityID:  city.cityId!, isNew: false, id: city.objectID, index: index)
                    a?.RequestAnswerDelegate = self
                    a?.prepareRequest()
                    a?.request.resume()
                }
                index += 1

            }
        }
        self.listCities.isHidden = false
        pagination.numberOfPages = length
    }
    
    // WeatherRequestDelegate
    func onResult(data: NSDictionary, canDismiss: Bool, isNew: Bool, id: NSManagedObjectID?, index: Int?) {
        var resposeObject = WeatherResponse(json: data, canDismiss: canDismiss, id: nil)
        if isNew {
            let id = try? resposeObject.saveData()
            resposeObject.id = id
            GlobalData.CitiesWeather.append(resposeObject)
        } else {
            resposeObject.id = id
            GlobalData.CitiesWeather[index!] = resposeObject
        }
    }
    
    func onError(msg: String) {
        let alert = UIAlertController(title: "Parece que algo no está bien", message: msg, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil ))
        present(alert, animated: true, completion: nil)
    }
}

