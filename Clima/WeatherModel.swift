import Foundation

struct WeatherModel{
    let conditionId: Int;
    let cityName: String;
    let temperature: Double;
   
    
    var temperatureString:String{
        return String(Int(round(temperature)))
    }
    
    var conditionName:String{
        switch conditionId{
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.sleet"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "cloud.sun"
        case 801...804:
            return "cloud.fill"
        default:
            return "cloud"
        }
    }
   
}
