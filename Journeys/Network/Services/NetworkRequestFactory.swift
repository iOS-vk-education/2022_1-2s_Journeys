//
//  NetworkRequestFactory.swift
//  ArchitecureDemo
//
//  Created by Yury Bogdanov on 26.03.2022.
//

import Foundation

protocol NetworkRequestFactoryProtocol {
    func getLocationData(city: String, country: String) -> URLRequest
    func getWeatherRequestForCoordinates(_ coordinates: Coordinates,
                                         timezone: Timezone,
                                         startDate: String,
                                         endDate: String) -> URLRequest
    func getCoordinatesTimezone(_ coordinates: Coordinates) -> URLRequest
    func getCurrencyRate(from currentCurrency: String,
                         to localCurrency: String,
                         amount: Float) -> URLRequest
}

final class NetworkRequestFactory: NetworkRequestFactoryProtocol {
    private enum Constants {
        enum ApiNinjas {
            static let apiKey = "I//IsgmpQrbjs0vapG6ffg==3lc6InAZejkjUGbe"
            static let baseURL = URL(string: "https://api.api-ninjas.com/v1/")!
        }
        enum Weather {
            static let baseURL = URL(string: "https://api.open-meteo.com/v1/")!
            static let dailySettings = "weathercode,temperature_2m_max,temperature_2m_min"
        }
    }
    
    func getLocationData(city: String, country: String) -> URLRequest {
        let requestURL = Constants.ApiNinjas.baseURL.appendingPathComponent("geocoding")
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "city", value: city),
            URLQueryItem(name: "country", value: country)
        ]
        guard let url = urlComponents?.url else {
            assertionFailure("Something has gone wrong and URL could not be constructed!")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.setValue(Constants.ApiNinjas.apiKey, forHTTPHeaderField: "X-Api-Key")
        return request
    }
    
    func getCoordinatesTimezone(_ coordinates: Coordinates) -> URLRequest {
        let requestURL = Constants.ApiNinjas.baseURL.appendingPathComponent("timezone")
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinates.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinates.longitude)")
        ]
        guard let url = urlComponents?.url else {
            assertionFailure("Something has gone wrong and URL could not be constructed!")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.setValue(Constants.ApiNinjas.apiKey, forHTTPHeaderField: "X-Api-Key")
        return request
    }
    
    func getCurrencyRate(from currentCurrency: String,
                         to localCurrency: String,
                         amount: Float) -> URLRequest {
        let requestURL = Constants.ApiNinjas.baseURL.appendingPathComponent("convertcurrency")
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "have", value: "\(currentCurrency)"),
            URLQueryItem(name: "want", value: "\(localCurrency)"),
            URLQueryItem(name: "amount", value: "\(amount)")
        ]
        guard let url = urlComponents?.url else {
            assertionFailure("Something has gone wrong and URL could not be constructed!")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.setValue(Constants.ApiNinjas.apiKey, forHTTPHeaderField: "X-Api-Key")
        return request
    }
    
    func getWeatherRequestForCoordinates(_ coordinates: Coordinates,
                                         timezone: Timezone,
                                         startDate: String,
                                         endDate: String) -> URLRequest {
        let requestURL = Constants.Weather.baseURL.appendingPathComponent("forecast")
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: "\(coordinates.latitude)"),
            URLQueryItem(name: "longitude", value: "\(coordinates.longitude)"),
            URLQueryItem(name: "daily", value: Constants.Weather.dailySettings),
            URLQueryItem(name: "timezone", value: timezone.timezone),
            URLQueryItem(name: "start_date", value: startDate),
            URLQueryItem(name: "end_date", value: endDate)
        ]
        guard let url = urlComponents?.url else {
            assertionFailure("Something has gone wrong and URL could not be constructed!")
            return URLRequest(url: URL(string: "")!)
        }
        return URLRequest(url: url)
    }
    
}
