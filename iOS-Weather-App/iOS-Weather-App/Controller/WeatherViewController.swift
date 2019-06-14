//
//  WeatherViewController.swift
//  iOS-Weather-App
//
//  Created by Daniel Barclay.
//  Copyright © 2019 Daniel Barclay. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    // example API call:" https://api.darksky.net/forecast/fce3d31ef66ca3d79371afec681e88c4/37.8267,-122.4233"
    
    let DARK_SKY_API = "https://api.darksky.net/forecast/fce3d31ef66ca3d79371afec681e88c4"
    let KEY = "fce3d31ef66ca3d79371afec681e88c4"
    
    let locationManager = CLLocationManager()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
    }
    //MARK: Get location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        if location.horizontalAccuracy > 0 {
            // valid result found
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let params: [String: String] = ["lat": String(location.coordinate.latitude), "long": String(location.coordinate.longitude)]
        
            let url = "\(DARK_SKY_API)/\(params["lat"]!),\(params["long"]!)"
            getWeatherData(url: url)
            print(url)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: Get Weather Data
    func getWeatherData(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
                response in
            if response.result.isSuccess {
                print("Success! We got that data")
                
                let weatherJSON: JSON = JSON(response.result.value!)
                
                let result = weatherJSON["currently"]["temperature"]
                
                let formattedResult = String(format:"%.0f", round(result.double!))
                
                    self.temperatureLabel.text = "\(formattedResult)°"
                
            } else {
                print("Error: \(response.result.error)")
                self.cityLabel.text = "Connection issues"
            }
        }
    }
}


