//
//  ClimaManager.swift
//  WeatherApp
//
//  Created by Brandon Rodriguez Molina on 27/04/21.
//

import Foundation

struct ClimaManager {
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?appid=43c02b88939bc65afefdef7ff3b31822&units=metric&lang=es"
    
    //Funcion padre, ejecuta la sentencia y llama a los demas metodos
    func buscarClima(ciudad: String) {
        let urlString = "\(climaURL)&q=\(ciudad)"
        realizarSolicitud(urlString: urlString)
    }
    
    //Solicitud a la API
    func realizarSolicitud(urlString:String) {
        // 1. Crear url
        if let url = URL(string: urlString) {
            // 2. Crear url sesion
            let session = URLSession(configuration: .default)
            // 3. Asignarle una tarea a la url session
            let tarea = session.dataTask(with: url) { (datos, respuesta, error) in
                if error != nil {
                    print("Error al obtener datos: \(error! )")
                    return
                }
                if let datosSeguros = datos {
                    self.parsearJSON(datosClima: datosSeguros)
                }
            }
            // 4. Iniciar la tarea
            tarea.resume()
        }
    }
    
    //Decodificador JSON
    func parsearJSON(datosClima: Data) {
        let decodificador = JSONDecoder()
        
        do {
            let datosDecodificados = try decodificador.decode(ClimaDatos.self, from: datosClima)
            print("La ciudad que elegiste es: \(datosDecodificados.name)")
            print("La temperatura es: \(datosDecodificados.main.temp)")
            print("La temperatura es: \(datosDecodificados.weather[0].description)")
        } catch {
                print("Error al decodificar datos: \(error.localizedDescription)")
            }
        }
}
