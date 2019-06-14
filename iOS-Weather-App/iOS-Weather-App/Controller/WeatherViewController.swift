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
    
    let DARK_SKY_API = "https://api.darksky.net/forecast/fce3d31ef66ca3d79371afec681e88c4"
    let KEY = "fce3d31ef66ca3d79371afec681e88c4"
    
    // example API call: https://geocode.xyz/51.50354,-0.12768?geoit=json
    
    let GEO_CODE_API =
    "https://geocode.xyz"
    
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
            
            let weatherUrl = "\(DARK_SKY_API)/\(params["lat"]!),\(params["long"]!)"
            
            let locationUrl = "\(GEO_CODE_API)/\(params["lat"]!),\(params["long"]!)?geoit=json"
            getWeatherData(weatherUrl: weatherUrl, locationUrl: locationUrl)
            print(locationUrl)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: Get Weather Data
    func getWeatherData(weatherUrl: String, locationUrl: String) {
        Alamofire.request(weatherUrl, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! We got that data")
                
                let weatherJSON: JSON = JSON(response.result.value!)
                
                let result = weatherJSON["currently"]["temperature"]
                
                let calculatedResult = self.fahrenheitToCelsius(temp: result.double!)
                
                let formattedResult = String(format:"%.0f", round(calculatedResult))
                
                self.temperatureLabel.text = "\(formattedResult)°"
                
            } else {
                print("Error: \(response.result.error)")
                self.cityLabel.text = "Connection issues"
            }
        }
        
        Alamofire.request(locationUrl, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! We got that data")
                
                let locationJSON: JSON = JSON(response.result.value!)
                
                let result = locationJSON["city"]
                
                self.cityLabel.text = result.stringValue.capitalized
            }
            else {
                print("Error: \(response.result.error)")
                self.cityLabel.text = "Connection issues"
            }
        }
        
    }
    
    func fahrenheitToCelsius (temp: Double) -> Double {
        return (temp - 32) * (5/9)
    }
}


