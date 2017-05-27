//
//  ArduinoConnect.swift
//  ArduinoUnoWifi
//
//  Created by Sergey Didanov on 25.04.17.
//  Copyright © 2017 Sergey Didanov. All rights reserved.
//

import Foundation
import Alamofire

class ArduinoConnect {
    
    func connect(to host: String, completeHandler:@escaping (Bool) -> Void) {
        let url = "http://\(host)/arduino/digital/13"
        Alamofire.request(url).responseData { response in
            completeHandler(response.result.isSuccess ? true : false)
        }
    }
    
    func setDigital(pin: Int, toState: Bool, completeHandler:@escaping (Bool) -> Void ) {
        guard let arduinoIP = UserDefaults.standard.string(forKey: "arduinoIP") else { return completeHandler(false) }
        let url = "http://\(arduinoIP)/arduino/digital/\(pin)/\(toState ? 1 : 0)"
        Alamofire.request(url).responseData { response in
            if response.result.isSuccess {
                completeHandler(true)
            } else {
                completeHandler(false)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lostConnection"), object: nil)
            }
        }
    }
    
    func getDigital(pin: Int, completeHandler:@escaping (Bool?) -> Void ) {
        guard let arduinoIP = UserDefaults.standard.string(forKey: "arduinoIP") else { return completeHandler(nil) }
        let url = "http://\(arduinoIP)/arduino/digital/\(pin)"
        Alamofire.request(url).responseString { response in
            if let resultValue = response.result.value {
                let value = Int(String(resultValue.components(separatedBy: " ")[4].characters.filter { !"\r\n".characters.contains($0) }))
                completeHandler(value == 1 ? true : false)
            } else {
                completeHandler(nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lostConnection"), object: nil)
            }
        }
    }
    
    func setPvmAnalog(pin: Int, toValue: Int, completeHandler:@escaping (Bool) -> Void ) {
        guard let arduinoIP = UserDefaults.standard.string(forKey: "arduinoIP") else { return completeHandler(false) }
        let url = "http://\(arduinoIP)/arduino/analog/\(pin)/\(toValue)"
        Alamofire.request(url).responseData { response in
            if response.result.isSuccess {
                completeHandler(true)
            } else {
                completeHandler(false)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lostConnection"), object: nil)
            }
        }
    }
    
    func getAnalog(pin: Int, completeHandler:@escaping (Int?) -> Void ) {
        guard let arduinoIP = UserDefaults.standard.string(forKey: "arduinoIP") else { return completeHandler(nil) }
        let url = "http://\(arduinoIP)/arduino/analog/\(pin)"
        Alamofire.request(url).responseString { response in
            if let resultValue = response.result.value {
                let value = Int(String(resultValue.components(separatedBy: " ")[4].characters.filter { !"\r\n".characters.contains($0) }))
                completeHandler(value)
            } else {
                completeHandler(nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lostConnection"), object: nil)
            }
        }
    }
    
}
