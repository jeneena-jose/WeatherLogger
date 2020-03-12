//
//  WeatherCell.swift
//  Weather Logger
//
//  Created by Jeneena Jose on 02/03/20.
//  Copyright © 2020 Jeneena Jose. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
  
    @IBOutlet weak var viewBase: UIView!

    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblFeelsLike: UILabel!

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!

    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
