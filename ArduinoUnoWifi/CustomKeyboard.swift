//
//  AnalogKeyboard.swift
//  ArduinoUnoWifi
//
//  Created by Sergey Didanov on 14.04.17.
//  Copyright © 2017 Sergey Didanov. All rights reserved.
//

import Foundation
import UIKit

class CustomKeyboard {
    static let instance = CustomKeyboard()
    
    var textField: UITextField? {
        didSet {
            CustomKeyboard.instance.showToolbarOnKeyboard()
            currentAnalogValue = Int((textField?.text)!)!
            actionSlider.value = Float(currentAnalogValue)
        }
    }
    fileprivate var currentAnalogValue = 0
    fileprivate let actionSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        return slider
    }()
    
    fileprivate func showToolbarOnKeyboard() {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        toolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        let cancel: UIBarButtonItem  = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelButtonAction))
        actionSlider.addTarget(self, action: #selector(sliderChangeTracking), for: .valueChanged)
        let slider: UIBarButtonItem = UIBarButtonItem(customView: actionSlider)
        slider.width = UIScreen.main.bounds.width / 2
        var items = [UIBarButtonItem]()
        items.append(cancel)
        items.append(flexSpace)
        items.append(slider)
        items.append(flexSpace)
        items.append(done)
        toolbar.items = items
        toolbar.sizeToFit()
        textField?.inputAccessoryView = toolbar
    }
    
    @objc fileprivate func doneButtonAction() {
        if isConnectedToArduino {
            guard let textFieldString = textField?.text,
                let textFieldInt = Int(textFieldString) else { return }
            if textFieldInt >= 0  && textFieldInt <= 255 {
                textField?.resignFirstResponder()
                // Here must be send Arduinop action
            } else {
                let alert = UIAlertController(title: "Incorrect value", message: "Analog value can be only between 0-255", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Connection alert", message: "Please connect to Arduino UNO FiWi!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @objc fileprivate func cancelButtonAction() {
        print("Touch cancel button")
        textField?.text = String(currentAnalogValue)
        textField?.resignFirstResponder()
    }
    
    @objc fileprivate func sliderChangeTracking() {
        //print(actionSlider.value)
        textField?.text = String(Int(actionSlider.value))
    }
}
