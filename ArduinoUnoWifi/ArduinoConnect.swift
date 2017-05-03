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
    
    func connect(to: String, connectCompleteHandler:@escaping (Bool) -> Void) {
        connectCompleteHandler(!isConnectedToArduino)
    }
    
    func setDigital(pin: Int, toState: Bool, completeHandler:@escaping (Bool) -> Void ) {
        print("Try set Digital pin to \(toState)")
    }
    
    func getDigital(pin: Int, completeHandler:@escaping (Bool, Bool?) -> Void ) {
        print("Try to get Digital pin")
    }
    
    func setAnalog(pin: Int, toValue: Int, completeHandler:@escaping (Bool) -> Void ) {
        print("Try set Analog pin")
    }
    
    func getAnalog(pin: Int, completeHandler:@escaping (Bool, Int?) -> Void ) {
        print("Try to get Analog pin")
    }
    
}
