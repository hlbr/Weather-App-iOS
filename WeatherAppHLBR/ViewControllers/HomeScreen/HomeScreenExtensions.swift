//
//  HomeScreenExtensions.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
extension HomeScreen: CLLocationManagerDelegate {
    // Location Request
    func RequestAuthorization() {
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
}
extension HomeScreen: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let row = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        let indexPath = IndexPath(row: row, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.pagination.currentPage = row
    }
}


extension HomeScreen: UICollectionViewDataSource {
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
}

extension HomeScreen: WeatherRequestDelegate {
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

// Notification management and segue management
extension HomeScreen {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.destination.restorationIdentifier {
            if id == "History" {
                let nextView = segue.destination as! HistoryOfCityWeatherTableViewController
                nextView.latitude = GlobalData.CitiesWeather[pagination.currentPage]?.lat
                nextView.longitude = GlobalData.CitiesWeather[pagination.currentPage]?.lng
            }
        }
    }
    
    @objc func passed(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Int] {
            DispatchQueue.main.async {
                self.pagination.numberOfPages = GlobalData.CitiesWeather.count
                self.pagination.isUserInteractionEnabled = false
                self.collectionView.reloadData()
                self.pagination.currentPage = data["index"]!
                let indexPath = IndexPath(row: self.pagination.currentPage, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
         }
    }
    
    @objc func deleteObject(_ notification: Notification){
        if let customId = notification.userInfo as? [String: NSManagedObjectID] {
            let context = AppDelegate().managedObjectContext
            let getItem = context.object(with: customId["objectId"]!)
            context.delete(getItem)
            try? context.save()
        }
    }
    
    @objc func updateTalble(_ notification: Notification) {
        self.collectionView.reloadData()
    }
}
