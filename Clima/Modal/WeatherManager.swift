import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModal)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=f16244fab54a1b6250ba738d91b92929&units=metric";
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather (cityName:String){
        let urlString = "\(weatherUrl)&q=\(cityName)";
        perfomRequest(urlString: urlString)
    }
    
    func perfomRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData:Data) -> WeatherModal? {
        let decoder = JSONDecoder();
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData);
            let cloudId = decodedData.weather[0].id;
            let temp = decodedData.main.temp;
            let name = decodedData.name;
            
            let wearher = WeatherModal(conditionId: cloudId, cityName: name, temperature: temp)
            return wearher
        }
        catch{
            print(error);
            return nil
        }
    }
}
