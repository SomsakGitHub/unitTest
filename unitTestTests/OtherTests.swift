//
//  OtherTests.swift
//  unitTestTests
//
//  Created by somsak on 28/5/2564 BE.
//

import XCTest

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

class OtherTests: XCTestCase {

}

class WeatherDataTest: XCTestCase {

    func testCanParseWeather1() throws {
        let json = """
         {
           "weather": [
             {
               "id": 804,
               "description": "overcast clouds",
             }
           ],
           "main": {
             "temp": 10.58,
           },
           "name": "Calgary"
         }
        """

        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)

        XCTAssertEqual(10.58, weatherData.main.temp)
        XCTAssertEqual("Calgary", weatherData.name)
    }
    
    func testCanParseWeatherNoCityName() throws {
        let json = """
         {
           "weather": [
             {
               "id": 804,
               "description": "overcast clouds",
             }
           ],
           "main": {
             "temp": 10.58,
           },
           "name": ""
         }
        """

        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)

        XCTAssertEqual(10.58, weatherData.main.temp)
        XCTAssertEqual("", weatherData.name)
    }
    
    func testCanParseWeatherViaJSONFile() throws {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "weather", ofType: "json") else {
            fatalError("json not found")
        }

        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert json to String")
        }

        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)
        
        XCTAssertEqual(25.65, weatherData.main.temp)
        XCTAssertEqual("Paris", weatherData.name)
    }

}
