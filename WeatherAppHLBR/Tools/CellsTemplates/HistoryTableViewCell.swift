//
//  HistoryTableViewCell.swift
//  WeatherAppHLBR
//
//  Created by Héctor Luis on 26/05/20.
//  Copyright © 2020 Héctor Luis. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    // IBOutlets
    @IBOutlet weak var CollectionView: UICollectionView!
    
    //Class attributes
    var rowData = [CityHistoryHourlyResume]()

    // View triggered methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.CollectionView?.delegate = self
        self.CollectionView?.dataSource = self
        CollectionView?.register(UINib(nibName: "HourResumeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourResumeCollectionViewCell")
    }
    
    //UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = collectionView.dequeueReusableCell(withReuseIdentifier: "HourResumeCollectionViewCell", for: indexPath) as! HourResumeCollectionViewCell
        let element = rowData[indexPath.row]
        let dateFormatter = DateFormatter()
        view.current.text = element.current
        view.current.font = .preferredFont(forTextStyle: .largeTitle)
        view.resume.text = element.resume
        view.resume.font = .preferredFont(forTextStyle: .caption1)
        view.presure.text = element.pressure
        view.presure.textColor = .systemGray
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale.current
        view.hour.text = dateFormatter.string(from: element.time)
        view.hour.textColor = .blue
        return view
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width / 2 - 5, height: collectionView.frame.height)
        return size
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

}
