//
//  ClimaManager.swift
//  WeatherApp
//
//  Created by Brandon Rodriguez Molina on 27/04/21.
//

import Foundation

struct ClimaManager {
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?appid=43c02b88939bc65afefdef7ff3b31822"
    
    func buscarClima(ciudad: String) {
        let urlString = "\(climaURL)&q=\(ciudad)"
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString:String) {
        // 1. Crear url
        if let url = URL(string: urlString) {
            // 2. Crear url sesion
            let session = URLSession(configuration: .default)
            // 3. Asignarle una tarea a la url session
            let tarea = session.dataTask(with: url, completionHandler: manejador(datos:respuesta:error:))
            
            // 4. Iniciar la tarea
            tarea.resume()
        }
    }
    
    func manejador(datos: Data?, respuesta: URLResponse?, error: Error?) -> Void {
        if error != nil {
            print("Error al obtener datos: \(error! )")
            return
        }
        if let datosSeguros = datos {
            let datosString = String(data: datosSeguros, encoding: .utf8)
            print(datosString!)
        }
        if let respuestaServidor = respuesta {
            print("Respuesta del server: \(respuestaServidor)")
        }
    }
}
