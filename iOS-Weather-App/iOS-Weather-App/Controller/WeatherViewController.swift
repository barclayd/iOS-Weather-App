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

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //MARK: API Setup
    
    let DARK_SKY_API = "https://api.darksky.net/forecast/fce3d31ef66ca3d79371afec681e88c4"
    
    let GEO_CODE_API =
    "https://geocode.xyz"
    
    
    //MARK: Instances
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
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
                
                let weatherJSON: JSON = JSON(response.result.value!)
                
                let result = weatherJSON["currently"]["temperature"]
                
                if let tempResult = result.double {
                    
                    let calculatedResult = self.fahrenheitToCelsius(temp: tempResult)
                    
                    self.weatherDataModel.temperature = Int(round(calculatedResult))
                    
                    self.weatherDataModel.condition = weatherJSON["currently"]["summary"].stringValue
                    
                    print(weatherJSON["currently"]["icon"].stringValue)
                    
                    self.weatherDataModel.weatherIconName = self.weatherDataModel.determineWeatherIcon(condition: weatherJSON["currently"]["icon"].stringValue)
                    
                    self.updateUI()
                    
                } else {
                    print("Error: \(response.result.error)")
                    self.cityLabel.text = "Weather Unavailable"
                }
                
                
            } else {
                print("Error: \(response.result.error)")
                self.cityLabel.text = "Connection issues"
            }
        }
        //MARK: Get Location Data
        Alamofire.request(locationUrl, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                
                let locationJSON: JSON = JSON(response.result.value!)
                
                let result = locationJSON["city"]
                
                self.weatherDataModel.city = result.stringValue.capitalized
                
                self.updateUI()
                
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
    
    //MARK: Update UI
    func updateUI() {
        if weatherDataModel.city != "" && weatherDataModel.weatherIconName != "" {
            cityLabel.text = weatherDataModel.city
            temperatureLabel.text = "\(weatherDataModel.temperature)°"
            weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        }
    }
    
    //MARK: Protocol handling of ChangeCityDelegate
    
    func userEnteredANewCityName(city: String) {
        
        let weatherURL = "\(GEO_CODE_API)/\(city.lowercased())?geoit=json"
        
        
        getWeatherCoordinates(url: weatherURL, finished: {lat, long in
            
            let weatherUrl = "\(self.DARK_SKY_API)/\(lat),\(long)"
            
            let locationUrl = "\(self.GEO_CODE_API)/\(lat),\(long)?geoit=json"
            self.getWeatherData(weatherUrl: weatherUrl, locationUrl: locationUrl)
            
        })
        
    }
    
    func getWeatherCoordinates(url: String, finished: @escaping (String, String) -> Void) {
        
        var lat : String?
        var long: String?
        
        Alamofire.request(url).responseJSON {
            response in
            if response.result.isSuccess {
                
                let locationJSON: JSON = JSON(response.result.value!)
                
                lat = locationJSON["latt"].stringValue
                
                long = locationJSON["longt"].stringValue
                
            }
            else {
                print("Error: \(response.result.error)")
                self.cityLabel.text = "Connection issues"
            }
            if (lat != nil) && (long != nil) {
                finished(lat!, long!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
            
        }
    }
    
}


