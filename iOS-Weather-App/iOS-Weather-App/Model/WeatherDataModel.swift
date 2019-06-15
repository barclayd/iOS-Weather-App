//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Daniel Barclay.
//  Copyright (c) 2019 Daniel Barclay. All rights reserved.
//

import UIKit

class WeatherDataModel {
    
    // setup
    var temperature: Int = 0
    var condition: String = ""
    var city: String = ""
    var weatherIconName: String = ""
    
    
    func determineWeatherIcon(condition: String) -> String {
        switch condition {
        case "clear-night":
            return "dunno"
        case "rain":
            return "shower3"
        case "snow":
            return "snow4"
        case "sleet":
            return "snow5"
        case "wind":
            return "tstorm1"
        case "fog":
            return "overcast"
        case "cloudy":
            return "cloudy2"
        case "partly cloudy":
            return "cloudy2"
        case "partly-cloudy-night":
            return "cloudy2"
        default:
            return "dunno"
        }
    }
    
}
