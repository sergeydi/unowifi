//
//  ViewController.swift
//  ArduinoUnoWifi
//
//  Created by Sergey Didanov on 07.04.17.
//  Copyright © 2017 Sergey Didanov. All rights reserved.
//

import UIKit

public var isConnectedToArduino = true
class ViewController: UIViewController {
   
    @IBOutlet weak var scrollView: UIScrollView!
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
        initPinViews()
        // Fix issue with scrollview and navigation controller offset
        self.automaticallyAdjustsScrollViewInsets = false
        // Scroll view with all pins if keyboard pop up
        registerForKeyboardNotifications()
    }
    
    // Methods used for offset scrollView if keyboard pop up
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    // Configure all Arduino UNO pins 
    func initPinViews() {
        // Arduino left side pins
        pinResetview.pinID = 69; pinResetview.pinType = .service; pinResetview.pinTitleLabel.text = "Reset"; pinResetview.pinSide = .left
        pin33Vview.pinID = 33; pin33Vview.pinType = .service; pin33Vview.pinTitleLabel.text = "3.3V"; pin33Vview.pinSide = .left
        pin5Vview.pinID = 50; pin5Vview.pinType = .service; pin5Vview.pinTitleLabel.text = "5V"; pin5Vview.pinSide = .left
        pinA0view.pinID = 0; pinA0view.pinType = .analog; pinA0view.pinTitleLabel.text = "A0"; pinA0view.pinSide = .left
        pinA1view.pinID = 1; pinA1view.pinType = .analog; pinA1view.pinTitleLabel.text = "A1"; pinA1view.pinSide = .left
        pinA2view.pinID = 2; pinA2view.pinType = .analog; pinA2view.pinTitleLabel.text = "A2"; pinA2view.pinSide = .left
        pinA3view.pinID = 3; pinA3view.pinType = .analog; pinA3view.pinTitleLabel.text = "A3"; pinA3view.pinSide = .left
        pinA4view.pinID = 4; pinA4view.pinType = .analog; pinA4view.pinTitleLabel.text = "A4"; pinA4view.pinSide = .left
        pinA5view.pinID = 5; pinA5view.pinType = .analog; pinA5view.pinTitleLabel.text = "A5"; pinA5view.pinSide = .left
        
        // Arduino right side pins
        pin0view.pinID = 0; pin0view.pinType = .digit; pin0view.pinTitleLabel.text = "0"; pin0view.pinSide = .right
        pin1view.pinID = 1; pin1view.pinType = .digit; pin1view.pinTitleLabel.text = "1"; pin1view.pinSide = .right
        pin2view.pinID = 2; pin2view.pinType = .digit; pin2view.pinTitleLabel.text = "2"; pin2view.pinSide = .right
        pin3view.pinID = 3; pin3view.pinType = .pwm; pin3view.pinTitleLabel.text = "~3"; pin3view.pinSide = .right
        pin4view.pinID = 4; pin4view.pinType = .digit; pin4view.pinTitleLabel.text = "4"; pin4view.pinSide = .right
        pin5view.pinID = 5; pin5view.pinType = .pwm; pin5view.pinTitleLabel.text = "~5"; pin5view.pinSide = .right
        pin6view.pinID = 6; pin6view.pinType = .pwm; pin6view.pinTitleLabel.text = "~6"; pin6view.pinSide = .right
        pin7view.pinID = 7; pin7view.pinType = .digit; pin7view.pinTitleLabel.text = "7"; pin7view.pinSide = .right
        pin8view.pinID = 8; pin8view.pinType = .digit; pin8view.pinTitleLabel.text = "8"; pin8view.pinSide = .right
        pin9view.pinID = 9; pin9view.pinType = .pwm; pin9view.pinTitleLabel.text = "~9"; pin9view.pinSide = .right
        pin10view.pinID = 10; pin10view.pinType = .pwm; pin10view.pinTitleLabel.text = "~10"; pin10view.pinSide = .right
        pin11view.pinID = 11; pin11view.pinType = .pwm; pin11view.pinTitleLabel.text = "~11"; pin11view.pinSide = .right
        pin12view.pinID = 12; pin12view.pinType = .digit; pin12view.pinTitleLabel.text = "12"; pin12view.pinSide = .right
        pin13view.pinID = 13; pin13view.pinType = .digit; pin13view.pinTitleLabel.text = "13"; pin13view.pinSide = .right
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }


}

