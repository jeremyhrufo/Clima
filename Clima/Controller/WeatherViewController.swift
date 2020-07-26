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
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureStack: UIStackView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureUnits: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        // Hide UI labels and images until we need them
        showUI(shouldShow: false)
        
        // Set up text field delegate for this view controller to be
        // notified of events
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    private func showUI(shouldShow: Bool) {
        conditionImageView.isHidden = !shouldShow
        temperatureStack.isHidden = !shouldShow
        cityLabel.isHidden = !shouldShow
        descriptionLabel.isHidden = !shouldShow
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
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city: city)
        }
        
        // Clear our text field text
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // Don't block the main queue, send our updating task to a background queue
        DispatchQueue.main.async {
            self.conditionImageView.image =
                UIImage(systemName: weather.conditionName.rawValue)
            if self.conditionImageView.image != nil {
                self.conditionImageView.isHidden = false
            }
            
            self.temperatureLabel.text = weather.temperatureString
            self.temperatureUnits.text = weather.temperatureUnitsString
            if !weather.temperatureString.isEmpty {
                self.temperatureStack.isHidden = false
            }
            
            self.cityLabel.text = weather.cityName
            if !weather.cityName.isEmpty {
                self.cityLabel.isHidden = false
            }
            
            self.descriptionLabel.text = weather.description
            if !weather.description.isEmpty {
                self.descriptionLabel.isHidden = false
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
