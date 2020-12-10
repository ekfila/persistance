//
//  Weather.swift
//  persistance
//
//  Created by Ekaterina Stepanova on 10.12.20.
//

import Foundation
import RealmSwift

class CurrentWeather: Object {
    @objc dynamic var temperature: Double
    @objc dynamic var descript: String
    
    init(temperature: Double, description: String) {
        self.temperature = temperature
        self.descript = description
    }
    
    required init() {
        self.temperature = 0
        self.descript = ""
    }
}

class DayWeather: Object {
    @objc dynamic var day: NSDate
    @objc dynamic var minTemperature: Int
    @objc dynamic var maxTemperature: Int
    @objc dynamic var descript: String
    
    init(day: NSDate, minTemp: Int, maxTemp: Int, description: String) {
        self.day = day
        self.minTemperature = minTemp
        self.maxTemperature = maxTemp
        self.descript = description
    }
    
    required init() {
        self.day = NSDate(timeIntervalSince1970: Double(truncating: NSNumber(0)))
        self.minTemperature = 0
        self.maxTemperature = 0
        self.descript = ""
    }
}

class WeekWeather: Object {
   let weathers = RealmSwift.List<DayWeather>()
}


class Weather {
    
    static let shared = Weather()
    
    let https = "https://api.openweathermap.org/data/2.5/onecall?lat=55.752&lon=37.616&exclude=minutely,hourly&units=metric&lang=ru&APPID=3f5dea1fda4419e7e13febc32cf98b9b"
    
    func parseWeather(_ jsonDict: NSDictionary) -> (CurrentWeather, WeekWeather)? {
        
        let currentWeather = CurrentWeather()
        let weekWeather = WeekWeather()
                
        if let current = jsonDict["current"] as? NSDictionary,
            let curTemp = current["temp"] as? NSNumber,
            let weatherArr = current["weather"] as? NSArray,
            let weatherDict = weatherArr[0] as? NSDictionary,
            let currentDescription = weatherDict["description"] as? String {
            
                let currentTemp = curTemp.doubleValue
                currentWeather.temperature = currentTemp
                currentWeather.descript = currentDescription

        } else {
            return nil
        }
                
        if let daily = jsonDict["daily"] as? NSArray {
            
            for dayWeather in daily where dayWeather is NSDictionary {
                
                if let dayWeatherDict = dayWeather as? NSDictionary,
                    let dt = dayWeatherDict["dt"] as? NSNumber,
                    let tempDict = dayWeatherDict["temp"] as? NSDictionary,
                    let weatherArr = dayWeatherDict["weather"] as? NSArray,
                    let temperMin = tempDict["min"] as? NSNumber,
                    let temperMax = tempDict["max"] as? NSNumber,
                    let weatherDict = weatherArr[0] as? NSDictionary,
                    let description = weatherDict["description"] as? String {
                    
                        let date = NSDate(timeIntervalSince1970: Double(truncating: dt))
                        let tempMin = Int(temperMin.doubleValue)
                        let tempMax = Int(temperMax.doubleValue)
                    weekWeather.weathers.append(DayWeather(day: date, minTemp: tempMin, maxTemp: tempMax, description: description))
                }
            }
        } else {
            return nil
        }
        return (currentWeather, weekWeather)
    }
    
    func loadWeather(completion: @escaping (CurrentWeather, WeekWeather, String) -> Void) {
        let url = URL(string: https)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let jsonDict = json as? NSDictionary {
                
                if let (currentWeather, weekWeather) = self.parseWeather(jsonDict) {
                    DispatchQueue.main.async {
                        completion(currentWeather, weekWeather, "")
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(CurrentWeather(), WeekWeather(), "cannot parse weather")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(CurrentWeather(), WeekWeather(), "cannot get response without Alamofire")
                }
            }
        }
        task.resume()
    }

    let realm = try! Realm()

    func saveCurrentWeather(currentWeather: CurrentWeather, weekWeather: WeekWeather) {
        try! realm.write {
            self.realm.add(currentWeather)
            self.realm.add(weekWeather)
        }
    }
}

