//
//  ViewController.swift
//  WeatherApp
//
//  Created by Brandon Rodriguez Molina on 24/04/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, ClimaManagerDelegado {

    var climaManager = ClimaManager()
     
    // Barra de busqueda
    @IBOutlet weak var ciudadTextField: UITextField!
    
    // Elementos modificables
    @IBOutlet weak var climaImageView: UIImageView!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        //Establecer esta clase como el delegado del ClimaManager
        climaManager.delegado = self
        
        ciudadTextField.delegate = self
    }
    // Funcion para localizacion
    @IBAction func gpsButton(_ sender: Any) {
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
            self.temperaturaLabel.text = clima.tempString+"º C"
            self.ciudadLabel.text = clima.nombreCiudad
            self.descripcionLabel.text = clima.desc.capitalizingFirstLetter()
            let imgURL = "https://openweathermap.org/img/wn/\(clima.icon)@4x.png"
            self.cargarImagen(urlString: imgURL)
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
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
