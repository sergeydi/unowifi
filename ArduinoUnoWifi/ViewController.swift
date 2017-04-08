//
//  ViewController.swift
//  ArduinoUnoWifi
//
//  Created by Sergey Didanov on 07.04.17.
//  Copyright © 2017 Sergey Didanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var pinResetview: PinView!
    @IBOutlet weak var pin33Vview: PinView!
    @IBOutlet weak var pin5Vview: PinView!
    @IBOutlet weak var pinA0view: PinView!
    @IBOutlet weak var pinA1view: PinView!
    @IBOutlet weak var pinA2view: PinView!
    @IBOutlet weak var pinA3view: PinView!
    @IBOutlet weak var pinA4view: PinView!
    @IBOutlet weak var pinA5view: PinView!
    @IBOutlet weak var pin0view: PinView!
    @IBOutlet weak var pin1view: PinView!
    @IBOutlet weak var pin2view: PinView!
    @IBOutlet weak var pin3view: PinView!
    @IBOutlet weak var pin4view: PinView!
    @IBOutlet weak var pin5view: PinView!
    @IBOutlet weak var pin6view: PinView!
    @IBOutlet weak var pin7view: PinView!
    @IBOutlet weak var pin8view: PinView!
    @IBOutlet weak var pin9view: PinView!
    @IBOutlet weak var pin10view: PinView!
    @IBOutlet weak var pin11view: PinView!
    @IBOutlet weak var pin12view: PinView!
    @IBOutlet weak var pin13view: PinView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initPinViews()
    }
    
    func initPinViews() {
        // Arduino left side pins
        pinResetview.pinID = 69; pinResetview.pinType = .reset; pinResetview.pinSide = .left
        pin33Vview.pinID = 33; pin33Vview.pinType = .v33; pin33Vview.pinSide = .left
        pin5Vview.pinID = 50; pin5Vview.pinType = .v5; pin5Vview.pinSide = .left
        pinA0view.pinID = 0; pinA0view.pinType = .analog; pinA0view.pinSide = .left
        pinA1view.pinID = 1; pinA1view.pinType = .analog; pinA1view.pinSide = .left
        pinA2view.pinID = 2; pinA2view.pinType = .analog; pinA2view.pinSide = .left
        pinA3view.pinID = 3; pinA3view.pinType = .analog; pinA3view.pinSide = .left
        pinA4view.pinID = 4; pinA4view.pinType = .analog; pinA4view.pinSide = .left
        pinA5view.pinID = 5; pinA5view.pinType = .analog; pinA5view.pinSide = .left
        
        // Arduino right side pins
        pin0view.pinID = 0; pin0view.pinType = .digit; pin0view.pinSide = .right
        pin1view.pinID = 1; pin1view.pinType = .digit; pin1view.pinSide = .right
        pin2view.pinID = 2; pin2view.pinType = .digit; pin2view.pinSide = .right
        pin3view.pinID = 3; pin3view.pinType = .pwm; pin3view.pinSide = .right
        pin4view.pinID = 4; pin4view.pinType = .digit; pin4view.pinSide = .right
        pin5view.pinID = 5; pin5view.pinType = .pwm; pin5view.pinSide = .right
        pin6view.pinID = 6; pin6view.pinType = .pwm; pin6view.pinSide = .right
        pin7view.pinID = 7; pin7view.pinType = .digit; pin7view.pinSide = .right
        pin8view.pinID = 8; pin8view.pinType = .digit; pin8view.pinSide = .right
        pin9view.pinID = 9; pin9view.pinType = .pwm; pin9view.pinSide = .right
        pin10view.pinID = 10; pin10view.pinType = .pwm; pin10view.pinSide = .right
        pin11view.pinID = 11; pin11view.pinType = .pwm; pin11view.pinSide = .right
        pin12view.pinID = 12; pin12view.pinType = .digit; pin12view.pinSide = .right
        pin13view.pinID = 13; pin13view.pinType = .digit; pin13view.pinSide = .right
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

