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
    
}
