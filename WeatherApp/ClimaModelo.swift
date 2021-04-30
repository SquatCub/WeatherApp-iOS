//
//  ClimaModelo.swift
//  WeatherApp
//
//  Created by Brandon Rodriguez Molina on 27/04/21.
//

import Foundation

struct ClimaModelo {
    let temp: Double
    let nombreCiudad: String
    let id: Int
    let icon: String
    let desc: String
    let time: Character
    let feels: Double
    let humidity: Double
    
    // Propiedades calculadas
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var feelString: String {
        return String(format: "%.1f", feels)
    }
    var humidityString: String {
        return String(format: "%.1f", humidity)
    }
    
    var condicionClima: String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.hail"
        case 500...531:
            return "cloud.sleet"
        case 600...622:
            return "snow"
        case 701...781:
            return "sun.dust"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "clouds"
        }
    }
}
