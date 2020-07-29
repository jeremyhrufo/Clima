//
//  Constants.swift
//  Clima
//
//  Created by Jeremy Rufo on 7/27/20.
//

import Foundation

enum TemperatureUnits: String {
    case Imperial = "units=imperial"
    case Metric = "units=metric"
}

struct Constants {
    
    // Make sure URL is secure (https)
    // Example: https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={your api key}
    static let openMapWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
    //static let openMapWeatherURL = "https://api.openweathermap.org/data/2.5/onecall"
    static let cityNameParam = "q="
    static let latitudeParam = "lat="
    static let longitudeParam = "lon="
    static let apiKeyParam = "appid="
    static let developerApiKey = ""
}
