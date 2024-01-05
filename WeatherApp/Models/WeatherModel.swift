//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Akbar Khusanbaev on 05/01/24.
//

import Foundation

struct WeatherModel: Codable {
    let location: Location
    let current: Current

    enum CodingKeys: String, CodingKey {
        case location
        case current
    }
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tzId: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name
        case region
        case country
        case lat
        case lon
        case tzId = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

struct Current: Codable {
    let tempC: Double
    let tempF: Double
    let condition: Condition
    let windKph: Double
    let windMph: Double
    let humidity: Int
    let feelslikeC: Double
    let feelslikeF: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case tempF = "temp_f"
        case condition
        case windKph = "wind_kph"
        case windMph = "wind_mph"
        case humidity
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
    }
}

struct Condition: Codable {
    let text: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case text
        case icon
    }
}
