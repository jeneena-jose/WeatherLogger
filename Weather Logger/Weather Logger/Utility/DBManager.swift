//
//  DBManager.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 07/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class DBManager: NSObject {

    let field_City = "city"
    let field_Desc = "desc"
    let field_Temp = "temp"
    let field_Sunrise = "sunrise"
    let field_Sunset = "sunset"
    let field_Humidity = "humidity"
    let field_Pressure = "pressure"
    let field_Wind = "wind"
    let field_FeelsLike = "feelsLike"
    let field_LogTimeStamp = "logTimesStamp"

    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "WeatherDB.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createMoviesTableQuery = "create table weather  (\(field_LogTimeStamp) integer not null, \(field_City) text not null, \(field_Desc) text not null, \(field_Temp) integer not null, \(field_Sunrise) integer not null, \(field_Sunset) integer not null, \(field_Humidity) text, \(field_Pressure) integer not null, \(field_Wind) integer not null , \(field_FeelsLike) integer not null)"
                    
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }else{
            created = true
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    
    func insertWeatherData(weather : WeatherDBModel) {
        if openDatabase() {
                    let query = "insert into weather (\(field_LogTimeStamp), \(field_City), \(field_Desc), \(field_Temp), \(field_Sunrise), \(field_Sunset), \(field_Pressure), \(field_Wind), \(field_Humidity), \(field_FeelsLike)) values (  \(weather.logTimeStamp) , \(weather.city) , \(weather.desc), \(weather.temp), \(weather.sunrise),\(weather.sunset),\(weather.pressure),\(weather.windSpeed),\(weather.humidity),\(weather.feelsLike));"

                    if !database.executeStatements(query) {
                        print("Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
            
            database.close()
        }
    }
    
    
    func loadWeatherLogs() -> [WeatherDBModel] {
        var weatherLogs = [WeatherDBModel]()

        if openDatabase() {
            let query = "select * from weather order by \(field_LogTimeStamp) desc"

            do {
                print(database!)
                let results = try database.executeQuery(query, values: nil)

                while results.next() {
                    let weather =
                        WeatherDBModel(city: results.string(forColumn: field_City) ?? "",
                                    desc: results.string(forColumn: field_Desc) ?? "",
                                    temp: Double(results.int(forColumn: field_Temp)),
                                    sunrise: Int(results.int(forColumn: field_Sunrise)),
                                    sunset: Int(results.int(forColumn: field_Sunset)),
                                    humidity: Int(results.int(forColumn: field_Humidity)),
                                    pressure: Int(results.int(forColumn: field_Pressure)),
                                    windSpeed: Double(results.int(forColumn: field_Wind)),
                                    feelsLike: Double(results.int(forColumn: field_FeelsLike)),
                                    logTimeStamp: Int(results.int(forColumn: field_LogTimeStamp)) )
                        

                    weatherLogs.append(weather)
                }
            }
            catch {
                print(error.localizedDescription)
            }

            database.close()
        }

        return weatherLogs
    }

    
}
