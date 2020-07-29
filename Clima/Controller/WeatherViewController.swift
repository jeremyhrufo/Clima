//
//  ViewController.swift
//  Clima
//
//  Created by Jeremy Rufo
//  Copyright © 2020 Jeremy H Rufo
//

import UIKit
import CoreLocation

//MARK: - WeatherViewController

class WeatherViewController: UIViewController {
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureStack: UIStackView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureUnits: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var canUseLocation: Bool = false
    var canAlwaysUseLocation: Bool = false
    var lastLocation: CLLocation?
    
    var weatherManager: WeatherManager?
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up delegates for this controller
        searchTextField.delegate = self
        
        // Hide UI labels and images until we need them
        self.hideUI()
        cityLabel.isHidden = true
        
        setUpWeatherManager()
        setUpLocationManager()
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        
        self.clearTextField()
        self.requestLocation()
    }
    
    func hideUI() {
        conditionImageView.isHidden = true
        temperatureStack.isHidden = true
        cityLabel.isHidden = true
        descriptionLabel.isHidden = true
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        // Dismiss keyboard
        searchTextField.endEditing(true)
    }
    
    // Action when user hits the 'Go' button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss keyboard
        searchTextField.endEditing(true)
        return true
    }
    
    // User has selected elsewhere, should they end editing?
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" { return true }
        textField.placeholder = "Please type something"
        return false
    }
    
    // The user has stopped editing (has hit 'Go' or search)
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use the text entered by user to find location for weather
        if let searchString = searchTextField.text {
            self.weatherManager?.fetchWeather(cityOrCityState: searchString)
        }
        
        self.clearTextField()
    }
    
    private func clearTextField() {
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func setUpWeatherManager() {
        self.weatherManager = WeatherManager()
        self.weatherManager?.delegate = self
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // Don't block the main queue, send our updating task to a background queue
        DispatchQueue.main.async {
            self.hideUI()

            if weather.cod == "404" {
                self.descriptionLabel.text = weather.message
                self.descriptionLabel.isHidden = false
                return
            }

            self.conditionImageView.image = UIImage(systemName: weather.conditionName.rawValue)
            if self.conditionImageView.image != nil {
                self.conditionImageView.isHidden = false
            }

            self.temperatureLabel.text = weather.temperatureString
            self.temperatureUnits.text = weather.temperatureUnitsString
            if !weather.temperatureString.isEmpty {
                self.temperatureStack.isHidden = false
            }

            self.cityLabel.text = weather.cityName
            // Add the country if it's not empty
            if !weather.countryName.isEmpty {
                self.cityLabel.text! += (", " + weather.countryName)
            }
            if !weather.cityName.isEmpty {
                self.cityLabel.isHidden = false
            }

            self.descriptionLabel.text = weather.description
            if !(weather.description?.isEmpty ?? false) {
                self.descriptionLabel.isHidden = false
            }
        }
    }

    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.hideUI()
            
            self.descriptionLabel.text = "Error"
            self.descriptionLabel.isHidden = false
            
            print(error)
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func setUpLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.lastLocation = nil
        self.canUseLocation = false
        self.canAlwaysUseLocation = false

        // Request to use location data
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager?.stopUpdatingLocation()
            weatherManager?.fetchWeather(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // TODO: Notify the user of any errors
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied: // disable location features
            disableMyLocationBasedFeatures()
            break
        case .authorizedWhenInUse: // enable location features
            enableMyLocationFeatures()
            break
        case .authorizedAlways: // enable always use location features.
            enableMyAlwaysFeatures()
            break
        case .notDetermined:
            break
        @unknown default:
            print("Error")
            break
        }
        
        self.locationButton.isEnabled = self.canUseLocation
    }
    
    func requestLocation() {
        if self.canUseLocation {
            self.locationManager?.requestLocation()
        }
    }
    
    //MARK: - Local Functions I'm not sure if I'll need
    
    func enableMyLocationFeatures() {
        self.canUseLocation = true
    }
    
    func disableMyLocationBasedFeatures() {
        self.canUseLocation = false
        self.canAlwaysUseLocation = false
    }
    
    func enableMyAlwaysFeatures() {
        self.canAlwaysUseLocation = true
    }
}
