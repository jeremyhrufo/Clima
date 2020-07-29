//
//  WeatherData.swift
//  Clima
//
//  Created by Jeremy Rufo on 7/25/20.
//

import Foundation

struct WeatherData: Codable {
    let coord: Coordinates?
    let weather: [Weather]?
    let base: String
    let main: Main?
    let visibility: Int
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int
    let sys: Sys?
    let timezone: Int
    let id: Int
    let name: String
    var cod: String = ""
    var message: String = ""
}

extension WeatherData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coord = (try? container.decodeIfPresent(Coordinates.self, forKey: .coord)) ?? nil
        weather = (try? container.decodeIfPresent([Weather].self, forKey: .weather)) ?? nil
        base = (try? container.decodeIfPresent(String.self, forKey: .base)) ?? ""
        main = (try? container.decodeIfPresent(Main.self, forKey: .main)) ?? nil
        visibility = (try? container.decodeIfPresent(Int.self, forKey: .visibility)) ?? 0
        wind = (try? container.decodeIfPresent(Wind.self, forKey: .wind)) ?? nil
        clouds = (try? container.decodeIfPresent(Clouds.self, forKey: .clouds)) ?? nil
        dt = (try? container.decodeIfPresent(Int.self, forKey: .dt)) ?? 0
        sys = (try? container.decodeIfPresent(Sys.self, forKey: .sys)) ?? nil
        timezone = (try? container.decodeIfPresent(Int.self, forKey: .timezone)) ?? 0
        id = (try? container.decodeIfPresent(Int.self, forKey: .id)) ?? 0
        name = (try? container.decodeIfPresent(String.self, forKey: .name)) ?? "No City"
        
        cod = decodeString(forKey: .cod, container: container)
        message = decodeString(forKey: .message, container: container)
    }
    
    private func decodeString(forKey: CodingKeys, container: KeyedDecodingContainer<CodingKeys>) -> String {
        var returnString: String = ""
        
        do {
            if let tempString = try container.decodeIfPresent(String.self, forKey: forKey) {
                returnString = tempString
            }
        } catch DecodingError.typeMismatch {
            do {
                let temp = try container.decodeIfPresent(Int.self, forKey: forKey)
                returnString = String(temp ?? 0)
            } catch { }
        } catch { }
        return returnString
    }
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let message: Double?
    let country: String
    let sunrise: Int
    let sunset: Int
}
