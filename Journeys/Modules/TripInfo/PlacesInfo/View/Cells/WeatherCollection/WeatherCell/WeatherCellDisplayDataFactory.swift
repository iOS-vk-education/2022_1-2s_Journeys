//
//  WeatherCellDisplayDataFactory.swift
//  Journeys
//
//  Created by Сергей Адольевич on 14.12.2022.
//

import Foundation
import UIKit

protocol WeatherCellDisplayDataFactoryProtocol: AnyObject {
    func displayData(weather: Weather) -> WeatherCell.DisplayData
}

final class WeatherCellDisplayDataFactory: WeatherCellDisplayDataFactoryProtocol {
    func displayData(weather: Weather) -> WeatherCell.DisplayData {
        var icon: UIImage?
        var iconColor: UIColor?
        
        switch weather.weatherCode {
        case 0:
            icon = UIImage(systemName: "sun.max.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.sunny)
        case (1...3):
            icon = UIImage(systemName: "cloud.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.cloudy)
        case 45, 48:
            icon = UIImage(systemName: "cloud.fog.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.fog)
        case 51, 53, 55, 56, 57:
            icon = UIImage(systemName: "cloud.drizzle.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.drizzle)
        case 61, 63, 65:
            icon = UIImage(systemName: "cloud.rain.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.rain)
        case 66, 67:
            icon = UIImage(systemName: "cloud.sleet.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.freezingRain)
        case 71, 73, 75, 85, 86:
            icon = UIImage(systemName: "cloud.snow.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.snowy)
        case 77:
            icon = UIImage(systemName: "cloud.hail.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.grains)
        case 80, 81, 82:
            icon = UIImage(systemName: "cloud.heavyrain.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.heawyRain)
        case 95, 96, 99:
            icon = UIImage(systemName: "cloud.bolt.fill")
            iconColor = UIColor(asset: Asset.Colors.Weather.thunderstorm)
        default:
            break
        }
        
        var dateString: String?
        if let date = DateFormatter.fullDateWithDash.date(from: weather.date) {
            dateString = DateFormatter.dayAndWeekDay.string(from: date)
        }
        let midTemp = (weather.temperatureMax + weather.temperatureMin) / 2
        var tempString: String
        if midTemp.rounded() > 0 {
            tempString = "+\(Int(midTemp))"
        } else {
            tempString = String(Int(midTemp))
        }
        
        return WeatherCell.DisplayData(icon: icon ?? UIImage(),
                                       iconColor: iconColor ?? .white,
                                       date: dateString ?? "",
                                       temperature: tempString)
    }
}
