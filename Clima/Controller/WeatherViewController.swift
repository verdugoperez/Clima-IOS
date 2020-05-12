//
//  ViewController.swift
//  Clima
//
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // el textfield se tiene que reportar al ViewController
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        // pedir permiso para obtener la ubicacion del usuario
        locationManager.requestWhenInUseAuthorization()
        
        // obtener la ubicación del usuario una vez
        locationManager.requestLocation()
        
        // Obtener la ubicación del usuario constantemente
        // locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        // print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
         locationManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // locations.last: es el ultimo elemento en el array, por lo tanto es el más accurate
        if let safeLocation = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = safeLocation.coordinate.latitude
            let lon = safeLocation.coordinate.longitude
           weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    // se ejecuta cuando el usuario presiona la tecla de "return" o "go"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // print("textFieldShouldEndEditing")
        
        //usar el parametro textField para afectar a todos los del WeatherViewController
        
        if textField.text != "" {
            return true
        }
        
        textField.placeholder = "Type something"
        return false
    }
    
    // se ejecuta cuando el usuario termina de editar el textfield
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureOneDecimal
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}

