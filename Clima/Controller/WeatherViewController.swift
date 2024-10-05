import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager();
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate=self
        searchTextField.delegate=self
    }
    @IBAction func onLocationBasedWeatherPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    

}

//MARK: - UITextFieldDelegate


extension WeatherViewController:UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cityName = searchTextField.text!
        weatherManager.fetchWeather(cityName: cityName);
        searchTextField.text=""
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder="Type Something ..."
        }
        return false
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController:WeatherManagerDelegate{
     func didWeatherUpdate(_ weatherManager:WeatherManager,weather: WeatherModel) {
         DispatchQueue.main.async {
             self.temperatureLabel.text=weather.temperatureString;
             self.conditionImageView.image=UIImage(systemName: weather.conditionName);
             self.cityLabel.text=weather.cityName;
         }
     }
     
     func didFailWithError(error: any Error) {
         print(error);
     }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locations=locations.last{
            locationManager.stopUpdatingLocation()
            let lat=locations.coordinate.latitude;
            let lon=locations.coordinate.longitude;
            weatherManager.fetchWeatherWithCoordinates(lat: lat, lon: lon)
            
        }
       
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
