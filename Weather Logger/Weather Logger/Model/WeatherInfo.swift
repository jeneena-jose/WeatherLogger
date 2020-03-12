//
//  WeatherInfo.swift
//  Weather Logger
//
//  Created by Jeneena Jose on 05/03/20.
//  Copyright © 2020 Jeneena Jose. All rights reserved.
//

import Foundation

// MARK: - WeatherInfo
struct WeatherInfo: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: WeatherInfo convenience initializers and mutators

extension WeatherInfo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WeatherInfo.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        coord: Coord? = nil,
        weather: [Weather]? = nil,
        base: String? = nil,
        main: Main? = nil,
        visibility: Int? = nil,
        wind: Wind? = nil,
        clouds: Clouds? = nil,
        dt: Int? = nil,
        sys: Sys? = nil,
        timezone: Int? = nil,
        id: Int? = nil,
        name: String? = nil,
        cod: Int? = nil
    ) -> WeatherInfo {
        return WeatherInfo(
            coord: coord ?? self.coord,
            weather: weather ?? self.weather,
            base: base ?? self.base,
            main: main ?? self.main,
            visibility: visibility ?? self.visibility,
            wind: wind ?? self.wind,
            clouds: clouds ?? self.clouds,
            dt: dt ?? self.dt,
            sys: sys ?? self.sys,
            timezone: timezone ?? self.timezone,
            id: id ?? self.id,
            name: name ?? self.name,
            cod: cod ?? self.cod
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
//    if let sunset = weatherInfoCurrent?.sys.sunset {
//        lblSunset.text = Date.init(timeIntervalSince1970: Double(sunset)).UTCToLocal()
//    }
//    if let sunrise = weatherInfoCurrent?.sys.sunrise{
//        lblSunrise.text = Date.init(timeIntervalSince1970: Double(sunrise)).UTCToLocal()
//    }
//    if let wind = weatherInfoCurrent?.wind.speed{
//        lblWind.text = "\(wind.rounded(toPlaces : 1)) m/s"
//    }
//    if let humidity = weatherInfoCurrent?.main.humidity{
//        lblHumidity.text = "\(humidity) %"
//    }
//    if let presurre = weatherInfoCurrent?.main.pressure{
//        lblPressure.text = "\(presurre) hPa"
//    }
//    if let feelslike = weatherInfoCurrent?.main.feelsLike{
//        let celsius = feelslike.KelvinToCelsius
//        lblFeelsLike.text = "\(celsius().rounded(toPlaces : 2)) °C"
//    }
//
//    if let city = weatherInfoCurrent?.name {
//        lblCity.text = city
//    }
//
//    if let weatherInfo = weatherInfoCurrent?.weather.first?.weatherDescription {
//        lblWeatherInfo.text = weatherInfo.capitalized
//    }
//
//    if let temp = weatherInfoCurrent?.main.temp {
//        let celsius = temp.KelvinToCelsiussel
//        lblTemperature.text = "\(celsius().rounded(toPlaces : 2)) °C"
//    }

    
    func mapToDB() -> WeatherDBModel {
        return WeatherDBModel(city: self.name, desc: self.weather.first?.weatherDescription ?? "", temp: self.main.temp , sunrise: self.sys.sunrise, sunset: self.sys.sunset, humidity: self.main.humidity, pressure: self.main.pressure, windSpeed: self.wind.speed, feelsLike: self.main.feelsLike, logTimeStamp: Int(Date().timeIntervalSince1970))
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: Clouds convenience initializers and mutators

extension Clouds {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Clouds.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        all: Int? = nil
    ) -> Clouds {
        return Clouds(
            all: all ?? self.all
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: Coord convenience initializers and mutators

extension Coord {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Coord.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        lon: Double? = nil,
        lat: Double? = nil
    ) -> Coord {
        return Coord(
            lon: lon ?? self.lon,
            lat: lat ?? self.lat
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: Main convenience initializers and mutators

extension Main {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Main.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        temp: Double? = nil,
        feelsLike: Double? = nil,
        tempMin: Double? = nil,
        tempMax: Double? = nil,
        pressure: Int? = nil,
        humidity: Int? = nil
    ) -> Main {
        return Main(
            temp: temp ?? self.temp,
            feelsLike: feelsLike ?? self.feelsLike,
            tempMin: tempMin ?? self.tempMin,
            tempMax: tempMax ?? self.tempMax,
            pressure: pressure ?? self.pressure,
            humidity: humidity ?? self.humidity
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: Sys convenience initializers and mutators

extension Sys {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Sys.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: Int? = nil,
        id: Int? = nil,
        country: String? = nil,
        sunrise: Int? = nil,
        sunset: Int? = nil
    ) -> Sys {
        return Sys(
            type: type ?? self.type,
            id: id ?? self.id,
            country: country ?? self.country,
            sunrise: sunrise ?? self.sunrise,
            sunset: sunset ?? self.sunset
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: Weather convenience initializers and mutators

extension Weather {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Weather.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int? = nil,
        main: String? = nil,
        weatherDescription: String? = nil,
        icon: String? = nil
    ) -> Weather {
        return Weather(
            id: id ?? self.id,
            main: main ?? self.main,
            weatherDescription: weatherDescription ?? self.weatherDescription,
            icon: icon ?? self.icon
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

// MARK: Wind convenience initializers and mutators

extension Wind {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Wind.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        speed: Double? = nil,
        deg: Int? = nil
    ) -> Wind {
        return Wind(
            speed: speed ?? self.speed,
            deg: deg ?? self.deg
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
