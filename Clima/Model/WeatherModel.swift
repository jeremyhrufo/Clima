//
//  WeatherModel.swift
//  Clima
//
//  Created by Jeremy Rufo on 7/25/20.
//

import Foundation

struct WeatherModel {
    let conditionId: Int?
    let temperature: Double
    let units: TemperatureUnits
    let cityName: String
    let countryName: String
    let description: String?
    let message: String?
    let cod: String?

    var temperatureString: String {
        return String(format: "%0.1f", self.temperature)
    }
    
    var temperatureUnitsString: String {
        return units == .Imperial ? "F" : "C"
    }
    
    init(data: WeatherData, units: TemperatureUnits, weatherIndex: Int) {
        self.cod = data.cod
        self.message = data.message
        
        self.conditionId = data.weather?[weatherIndex].id
        self.temperature = data.main?.temp ?? 0.0
        self.units = units
        self.cityName = data.name
        self.countryName = data.sys?.country ?? ""
        self.description = data.weather?[weatherIndex].description
    }
    
    var conditionName: WeatherSymbols {
        // If there is no valid conditionId, we will set it to 100 to get a question mark
        switch self.conditionId ?? 100 {
        case 200...202,
             222...232: return .cloudBoltRain
        case 203...221: return .cloudBolt
        case 300...321: return .cloudDrizzle
        case 500...531: return .cloudRain
        case 600...602: return .cloudSnow
        case 603...616: return .cloudSleet
        case 617...622: return .snow
        case 711:       return .smoke
        case 721:       return .sunHaze
        case 781:       return .tornado
        case 701...741: return .cloudFog
        case 742...781: return .sunDust
        case 800:       return .sunMax
        case 801:       return .cloudSun
        case 801...804: return .cloud
        default:        return .questionMark
        }
    }
}

enum WeatherSymbols: String {
    case sunMin     = "sun.min"
    case sunMinFill = "sun.min.fill"
    case sunMax     = "sun.max"
    case sunMaxFill = "sun.max.fill"
    case sunrise    = "sunrise"
    case sunriseFill = "sunrise.fill"
    case sunset = "sunset"
    case sunsetFill = "sunset.fill"
    case sunDust = "sun.dust"
    case sunDustFill = "sun.dust.fill"
    case sunHaze = "sun.haze"
    case sunHazeFill = "sun.haze.fill"
    case moon = "moon"
    case moonFill = "moon.fill"
    case moonCircle = "moon.circle"
    case moonCircleFill = "moon.circle.fill"
    case zzz = "zzz"
    case moonZzz = "moon.zzz"
    case moonZzzFill = "moon.zzz.fill"
    case sparkle = "sparkle"
    case sparkles = "sparkles"
    case moonStars = "moon.stars"
    case moonStarsFill = "moon.stars.fill"
    case cloud = "cloud"
    case cloudFill = "cloud.fill"
    case cloudDrizzle = "cloud.drizzle"
    case cloudDrizzleFill = "cloud.drizzle.fill"
    case cloudRain = "cloud.rain"
    case cloudRainFill = "cloud.rain.fill"
    case cloudHeavyrain = "cloud.heavyrain"
    case cloudHeavyrainFill = "cloud.heavyrain.fill"
    case cloudFog = "cloud.fog"
    case cloudFogFill = "cloud.fog.fill"
    case cloudHail = "cloud.hail"
    case cloudHailFill = "cloud.hail.fill"
    case cloudSnow = "cloud.snow"
    case cloudSnowFill = "cloud.snow.fill"
    case cloudSleet = "cloud.sleet"
    case cloudSleetFill = "cloud.sleet.fill"
    case cloudBolt = "cloud.bolt"
    case cloudBoltFill = "cloud.bolt.fill"
    case cloudBoltRain = "cloud.bolt.rain"
    case cloudBoltRainFill = "cloud.bolt.rain.fill"
    case cloudSun = "cloud.sun"
    case cloudSunFill = "cloud.sun.fill"
    case cloudSunRain = "cloud.sun.rain"
    case cloudSunRainFill = "cloud.sun.rain.fill"
    case cloudSunBolt = "cloud.sun.bolt"
    case cloudSunBoltFill = "cloud.sun.bolt.fill"
    case cloudMoon = "cloud.moon"
    case cloudMoonFill = "cloud.moon.fill"
    case cloudMoonRain = "cloud.moon.rain"
    case cloudMoonRainFill = "cloud.moon.rain.fill"
    case cloudMoonBolt = "cloud.moon.bolt"
    case cloudMoonBoltFill = "cloud.moon.bolt.fill"
    case smoke = "smoke"
    case smokeFill = "smoke.fill"
    case wind = "wind"
    case windSnow = "wind.snow"
    case snow = "snow"
    case tornado = "tornado"
    case tropicalStorm = "tropicalstorm"
    case hurricane = "hurricane"
    case thermometerSun = "thermometer.sun"
    case thermometerSunFill = "thermometer.sun.fill"
    case thermometerSnowflake = "thermometer.snowflake"
    case thermometer = "thermometer"
    case questionMark = "questionmark"
}
