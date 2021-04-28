//
//  ViewController.swift
//  WeatherApp
//
//  Created by Brandon Rodriguez Molina on 24/04/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, ClimaManagerDelegado, CLLocationManagerDelegate {

    var climaManager = ClimaManager()
    // Ayuda a obtener las coordenadas del usuario
    var climaLocationManager = CLLocationManager()
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    // Barra de busqueda
    @IBOutlet weak var ciudadTextField: UITextField!
    
    // Elementos modificables
    @IBOutlet weak var climaImageView: UIImageView!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        climaLocationManager.delegate = self
        //Solicitar ubicacion al usuario
        climaLocationManager.requestWhenInUseAuthorization()
        //Obtener ubicacion en todo momento
        climaLocationManager.requestLocation()
        //Establecer esta clase como el delegado del ClimaManager
        climaManager.delegado = self
        
        ciudadTextField.delegate = self
    }
    // Funcion para localizacion
    @IBAction func gpsButton(_ sender: Any) {
        climaManager.buscarClimaGps(lat: latitude!, lon: longitude!)
    }
    // Funcion para buscar ciudad
    @IBAction func buscarButton(_ sender: Any) {
        //Ocultar teclado
        ciudadTextField.endEditing(true)
        //ciudadLabel.text = ciudadTextField.text
        //ciudadTextField.text = ""
    }
    
    
    // Funcion del delegado, cuando se presiona el boton del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Ocultar teclado
        ciudadTextField.endEditing(true)
        // ciudadLabel.text = ciudadTextField.text
        //ciudadTextField.text = ""
        return true
    }
    
    // No avanzar si no hay texto. Esconder el teclado
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if ciudadTextField.text != "" {
            return true
        } else {
            ciudadTextField.placeholder = "Ingresa el nombre de una ciudad"
            return false
        }
    }
    
    // Ya se termino de ingresar texto
    func textFieldDidEndEditing(_ textField: UITextField) {
        climaManager.buscarClima(ciudad: ciudadTextField.text!)
        ciudadTextField.text = ""
    }
    
    // Recibo de datos desde el manager
    func actualizarClima(clima: ClimaModelo) {
        DispatchQueue.main.async {
            self.errorLabel.text = ""
            self.temperaturaLabel.text = clima.tempString+"º C"
            self.ciudadLabel.text = clima.nombreCiudad
            self.descripcionLabel.text = clima.desc.capitalizingFirstLetter()
            let imgURL = "https://openweathermap.org/img/wn/\(clima.icon)@4x.png"
            self.cargarImagen(urlString: imgURL)
            if clima.time == "n" {
                self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                self.view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
        }
    }
    
    //Imagenes del clima dinamicas
    func cargarImagen(urlString: String) {
            //1.- Obtener los datos
            guard let url = URL(string: urlString) else {
                return
            }
            let tareaObtenerDatos = URLSession.shared.dataTask(with: url) { (datos, _, error) in
                guard let datosSeguros = datos, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    //2.- Convertir los datos en imagen
                    let imagen = UIImage(data: datosSeguros)
                    //3.- Asignar la imagen a la imagen previamente creada
                    self.climaImageView.image = imagen
                }
            }
            tareaObtenerDatos.resume()
    }
    
    // En caso de error
    func errorClima() {
        DispatchQueue.main.async {
            self.errorLabel.text = "No se encontro la ciudad"
        }
    }
    
    // Metodos para la ubicacion
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let ubicacion = locations.last {
            let latitude = ubicacion.coordinate.latitude
            let longitude = ubicacion.coordinate.longitude
            self.latitude = latitude
            self.longitude = longitude
            climaManager.buscarClimaGps(lat: latitude, lon: longitude)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("Error al obtener ubicacion")
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
