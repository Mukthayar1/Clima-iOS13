import UIKit
import CoreLocation;

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager();
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization();
        locationManager.requestLocation();
        searchTextField.delegate = self;
        weatherManager.delegate = self;
    }
    
    
    @IBAction func searchByCords(_ sender: Any) {
        locationManager.requestLocation();
    }
    
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0];
            print("location: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
        weatherManager.fetchWeatherByCords(latitude : userLocation.coordinate.latitude,
                                           longitude : userLocation.coordinate.longitude);
        locationManager.stopUpdatingLocation()
        }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPress(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print("text filed just return===> "+searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Something ..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city);
        }
        searchTextField.text = ""
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ WeatherManager : WeatherManager, weather : WeatherModal) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString;
            self.conditionImageView.image = UIImage(systemName : weather.conditionTempIcon)
            self.cityLabel.text = weather.cityName;
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
