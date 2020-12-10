//
//  WeatherViewController.swift
//  persistance
//
//  Created by Ekaterina Stepanova on 07.12.20.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var currentTempLable: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    @IBOutlet weak var TableView: UITableView!
    
    var currentWeather = CurrentWeather()
    var weekWeather = WeekWeather()
    
    override func viewWillAppear(_ animated: Bool) {
        currentTempLable.text = "\(self.currentWeather.temperature)\u{00B0}"
        currentDescriptionLabel.text = self.currentWeather.descript
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Weather.shared.loadWeather {
            currentWeather, weekWeather, error in
            
            if error == "" {
                
                self.currentWeather = currentWeather
                self.weekWeather = weekWeather
                
                self.currentTempLable.text = "\(self.currentWeather.temperature)\u{00B0}"
                self.currentDescriptionLabel.text = self.currentWeather.descript
                self.TableView.reloadData()
            } else {
                self.currentTempLable.text = error
                self.currentDescriptionLabel.text = error
            }
        }
        
        Weather.shared.saveCurrentWeather(currentWeather: self.currentWeather, weekWeather: self.weekWeather)
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekWeather.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.setLocalizedDateFormatFromTemplate("dMM")

        cell.dayLabel.text = dateFormatter.string(from: weekWeather.weathers[indexPath.row].day as Date)
        cell.minTempLabel.text = "\(weekWeather.weathers[indexPath.row].minTemperature)\u{00B0} / \(weekWeather.weathers[indexPath.row].maxTemperature)\u{00B0}"
        cell.descriptionLabel.text = "\(weekWeather.weathers[indexPath.row].descript)"
        return cell
    }
}

