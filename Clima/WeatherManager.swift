import Foundation


protocol WeatherManagerDelegate{
    func didWeatherUpdate(_ weatherManager:WeatherManager,weather: WeatherModel)
    func didFailWithError(error:Error)
}
struct WeatherManager {
    var weatherURL: URL {
        URL(string: "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=b061df5a57fc9c5c4a3fa48ce8b9429c")!
    }
    
    var delegate:WeatherManagerDelegate?
    func fetchWeather(cityName:String){
        let urlString="\(weatherURL)&q=\(cityName)"
        performReq(with:urlString)
    }
    func fetchWeatherWithCoordinates(lat:Double,lon:Double){
        let urlString="\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performReq(with:urlString)
    }
    func performReq(with urlString:String){
        if let url=URL(string:urlString){
            let session=URLSession(configuration: .default);
            let task=session.dataTask(with: url,completionHandler: {(data,response,error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return ;
                }
                if let safeData=data{
                    if let weather=self.parseJSON(safeData){
                        self.delegate?.didWeatherUpdate(self,weather:weather)
                    }
                }
            });
            task.resume();
        }
    }
    
    func parseJSON(_ weatherData:Data)->WeatherModel?{
        let decoder=JSONDecoder();
        do{
            let decodedData=try decoder.decode(WeatherData.self,from:weatherData)
            let id=decodedData.weather[0].id;
            let temp=decodedData.main.temp;
            let name=decodedData.name;
            
            let weather=WeatherModel(conditionId:id,cityName:name, temperature:temp);
            
           
            return weather;
        }catch{
            delegate?.didFailWithError(error: error)
            return nil;
            
        }
    }

}
