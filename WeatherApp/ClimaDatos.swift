//
//  ClimaDatos.swift
//  WeatherApp
//
//  Created by Brandon Rodriguez Molina on 27/04/21.
//

import Foundation

struct ClimaDatos: Decodable {
    let name: String
    let id: Int
    let cod: Int
    
    let main: Main
    let weather: [Weather]
    
    struct Main: Decodable {
        let temp: Double
    }
    struct Weather: Decodable {
        let description: String
    }
    
}
