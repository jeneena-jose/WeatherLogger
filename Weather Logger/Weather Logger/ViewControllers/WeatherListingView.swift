//
//  WeatherListingView.swift
//  Weather Logger
//
//  Created by Jeneena Jose on 02/03/20.
//  Copyright © 2020 Jeneena Jose. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import MapKit

class WeatherListingView: UIViewController {
    
    let reuseIdentifier = "ColListCell"
    let locationManager = CLLocationManager()
    var lastLocationSaved : CLLocation?
    var weatherInfoCurrent :  WeatherDBModel?
    var weatherLogs = [WeatherDBModel]()

    @IBOutlet weak var colViewListing: UICollectionView!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblFeelsLike: UILabel!

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblWeatherInfo: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    
    @IBOutlet weak var viewWeatherInfo: UIView!
    @IBOutlet weak var viewNoLocation: UIView!
    @IBOutlet weak var lblErrorMsg: UILabel!

    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        registerNibsForCollectionView()
        checkLocationServicesPermission()
        fetchAllWeatherLogs()
        
    }
    
    func  setUpView(){
        
        self.title = "Weather Logger"
        
        viewNoLocation.isHidden = false
        viewWeatherInfo.isHidden = true
        
        btnSave.layer.borderColor = UIColor.white.cgColor
        btnSave.layer.borderWidth = 1
        btnSave.layer.cornerRadius = 5
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {

        if DBManager.shared.createDatabase() {
            DBManager.shared.insertWeatherData(weather: self.weatherInfoCurrent!)
            
            fetchAllWeatherLogs()
        }
    }
    
}

extension WeatherListingView : UICollectionViewDataSource {
    
    func registerNibsForCollectionView(){
        let cellNib = UINib(nibName: String(describing: "WeatherCell"), bundle: nil)
        colViewListing.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherLogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! WeatherCell
        
          let weatherInfo = weatherLogs[indexPath.row]
        
         let sunset = weatherInfo.sunset
        cell.lblSunset.text = Date.init(timeIntervalSince1970: Double(sunset)).UTCToLocal()
        
             let sunrise = weatherInfo.sunrise
        cell.lblSunrise.text = Date.init(timeIntervalSince1970: Double(sunrise)).UTCToLocal()

        cell.lblDate.text = Date.init(timeIntervalSince1970: Double(weatherInfo.logTimeStamp)).UTCToLocalCaps()

        let wind = weatherInfo.windSpeed
        cell.lblWind.text = "\(wind.rounded(toPlaces : 1)) m/s"
         let humidity = weatherInfo.humidity
        cell.lblHumidity.text = "\(humidity) %"
        let presurre = weatherInfo.pressure
        cell.lblPressure.text = "\(presurre) hPa"
         let feelslike = weatherInfo.feelsLike
            let celsius = feelslike.KelvinToCelsius
        cell.lblFeelsLike.text = "\(celsius().rounded(toPlaces : 2)) °C"
        let city = weatherInfo.city
        cell.lblCity.text = city

        let temp = weatherInfo.temp
            let celsiusTemp = temp.KelvinToCelsius
        cell.lblTemperature.text = "\(celsiusTemp().rounded(toPlaces : 2)) °C"
                
        return cell
        
    }
    
}


extension WeatherListingView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.bounds.width,height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


extension WeatherListingView : UICollectionViewDelegate {
    
}


// Location Services
extension WeatherListingView : CLLocationManagerDelegate  {
    
    func checkLocationServicesPermission(){
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
            
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
            //        case .authorizedAlways, .authorizedWhenInUse , .authorized:
            //            break
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.viewWeatherInfo.isHidden = false
            self.viewNoLocation.isHidden = true
            break
        @unknown default:
            break
        }
        
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
    
        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse   :
            print("authorizedWhenInUse");
            self.viewWeatherInfo.isHidden = false
            self.viewNoLocation.isHidden = true

            fetchWeatherDetails()// location authorized
        case .authorizedAlways      :
            print("authorizedAlways");
            self.viewWeatherInfo.isHidden = false
            self.viewNoLocation.isHidden = true
            fetchWeatherDetails()   // location authorized
        case .restricted, .denied   :
            self.viewWeatherInfo.isHidden = true
            self.viewNoLocation.isHidden = false

        let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        return

        @unknown default:
            break
        }
    }

    // Below method will provide you current location.
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.count > 0{
                lastLocationSaved = locations.last
                locationManager.stopUpdatingLocation()
                fetchWeatherDetails()
            }
        }

    // Below Mehtod will print error if not able to update location.
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error")
            self.viewWeatherInfo.isHidden = true
            self.viewNoLocation.isHidden = false
            lblErrorMsg.text = "Error fetching the location details."
        }

    
    
}


extension WeatherListingView {
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    
//    public var exposedLocation: CLLocation? {
//        return self.locationManager.location
//    }
//
//
//
    func fetchWeatherDetails(){
        

        if let locationCoordinate = lastLocationSaved {
            
            self.viewWeatherInfo.isHidden = false
            self.viewNoLocation.isHidden = true

            self.getPlace(for: locationCoordinate) { (placeMark) in
                
                var city = (placeMark?.administrativeArea ?? "") + "," + (placeMark?.subAdministrativeArea ?? "")
                city = city + "," + (placeMark?.country ?? "")

                var weatherURL = "http://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=62c8c9753b4124b2ecf64bae351514b7"
                weatherURL = weatherURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

                guard let url = URL(string: weatherURL) else {
                    return
                }
                
                
                AF.request(url, method: .get)
                    .validate()
                    .response { response in

                        do {

                        debugPrint(response)

                        switch response.result {

                        case .success(let json):
                            print(json!)
                            
                            if let JSON = String(data: json!, encoding: .utf8) {
                                print("json: \(JSON)")
                                let weatherInfo = try WeatherInfo(JSON)
                                self.weatherInfoCurrent = weatherInfo.mapToDB()
                            }


                            DispatchQueue.main.async {
                             print("setWeatherDetails2")
                                self.setWeatherDetails()
                           }

                        case .failure(let error):
                            print("Response failed : " + error.localizedDescription)
                        }
                            } catch let parseError as NSError {
                                print("JSON Error \(parseError.localizedDescription)")
                            }

                }

            }
        }
    }
    
    func setWeatherDetails(){
        
        print("setWeatherDetails")
        
        if weatherInfoCurrent != nil {
            self.viewWeatherInfo.isHidden = false
            self.viewNoLocation.isHidden = true
            
            if let sunset = weatherInfoCurrent?.sunset {
                lblSunset.text = Date.init(timeIntervalSince1970: Double(sunset)).UTCToLocal()
            }
            if let sunrise = weatherInfoCurrent?.sunrise{
                lblSunrise.text = Date.init(timeIntervalSince1970: Double(sunrise)).UTCToLocal()
            }
            if let wind = weatherInfoCurrent?.windSpeed{
                lblWind.text = "\(wind.rounded(toPlaces : 1)) m/s"
            }
            if let humidity = weatherInfoCurrent?.humidity{
                lblHumidity.text = "\(humidity) %"
            }
            if let presurre = weatherInfoCurrent?.pressure{
                lblPressure.text = "\(presurre) hPa"
            }
            if let feelslike = weatherInfoCurrent?.feelsLike{
                let celsius = feelslike.KelvinToCelsius
                lblFeelsLike.text = "\(celsius().rounded(toPlaces : 2)) °C"
            }
            
            if let city = weatherInfoCurrent?.city {
                lblCity.text = city
            }
            
            if let weatherInfo = weatherInfoCurrent?.desc {
                lblWeatherInfo.text = weatherInfo.capitalized
            }
            
            if let temp = weatherInfoCurrent?.temp {
                let celsius = temp.KelvinToCelsius
                lblTemperature.text = "\(celsius().rounded(toPlaces : 2)) °C"
            }

        }
    }
    
    func fetchAllWeatherLogs(){
    
        if DBManager.shared.createDatabase() {
            weatherLogs =  DBManager.shared.loadWeatherLogs()
            colViewListing.reloadData()
        }

    }
    
}
