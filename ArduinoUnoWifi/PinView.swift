//
//  PinView.swift
//  ArduinoUnoWifi
//
//  Created by Sergey Didanov on 08.04.17.
//  Copyright © 2017 Sergey Didanov. All rights reserved.
//

import UIKit

class PinView: UIView {
    
    var arduino: ArduinoConnect?
    var dataReceiveTimer: Timer?
    var pinID: Int?
    var pinType: PinType?
    var pinSide: PinSide? {
        didSet {
            if pinSide == .left {
                pinTitleLabel.textAlignment = NSTextAlignment.left
            } else {
                pinTitleLabel.textAlignment = NSTextAlignment.right
            }
            setup()
        }
    }
    var pinState: PinState? {
        didSet {
            if pinState == nil {
                let image = UIImage(named: "ButtonAddAction")
                pinActionButton.setImage(image, for: UIControlState())
            }
        }
    }
    let pinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let pinActionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "ButtonAddAction")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(pinButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let readFromPinButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "ReadFrom")
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(readFromPinAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    let writeToPinButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "WriteTo")
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(writeToPinAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    let choseDigitalModeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "BinaryMode")
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(digitalButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    let choseAnalogModeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "PwmMode")
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(analogButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    let removeActionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "CancelButton")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        button.isHidden = true
        return button
    }()
    lazy var digitalActionSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.tintColor = UIColor(red: 0.0, green: 146.0/255.0, blue: 159.0/255.0, alpha: 1.0)
        uiSwitch.onTintColor = UIColor(red: 0.0, green: 146.0/255.0, blue: 159.0/255.0, alpha: 1.0)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    lazy var analogActionField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor(red: 0.0, green: 146.0/255.0, blue: 159.0/255.0, alpha: 1.0).cgColor
        textField.textAlignment = .center
        textField.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        textField.text = "0"
        textField.addTarget(nil, action:#selector(showAnalogKeyboard), for:.editingDidBegin)
        textField.addTarget(nil, action:#selector(setPwmData), for:.editingDidEnd)
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    
    // MARK: Init View
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
    }
    
    func showAnalogKeyboard() {
        CustomKeyboard.instance.textField = analogActionField
    }
    
    @objc func pinButtonAction() {
        if isConnectedToArduino {
            if arduino == nil && pinType != .service {
                // Show read and write buttons
                if readFromPinButton.isHidden && writeToPinButton.isHidden && choseAnalogModeButton.isHidden && choseDigitalModeButton.isHidden {
                    readFromPinButton.isHidden = false
                    writeToPinButton.isHidden = false
                } else {
                    hideReadWriteButtons()
                    hideDigitAnalogButtons()
                }
            } else {
                // Show remove action button
                if removeActionButton.isHidden {
                    removeActionButton.isHidden = false
                } else {
                    removeActionButton.isHidden = true
                }
            }
        }
    }
    
    @objc func readFromPinAction() {
        pinState = .read
        if pinType == .pwm {
            choseDigitalModeButton.isHidden = false
            choseAnalogModeButton.isHidden = false
        } else {
            setupAction(self.pinType!)
        }
        hideReadWriteButtons()
    }
    
    @objc func writeToPinAction() {
        pinState = .write
        if pinType == .pwm {
            choseDigitalModeButton.isHidden = false
            choseAnalogModeButton.isHidden = false
        } else {
            setupAction(self.pinType!)
        }
        hideReadWriteButtons()
    }
    
    @objc func removeAction() {
        if dataReceiveTimer != nil {
            dataReceiveTimer?.invalidate()
            dataReceiveTimer = nil
        }
        pinState = nil
        arduino = nil
        if digitalActionSwitch.superview != nil {
            digitalActionSwitch.removeFromSuperview()
        }
        if analogActionField.superview != nil {
            analogActionField.removeFromSuperview()
        }
        removeActionButton.isHidden = true
    }
    
    @objc func digitalButtonAction() {
        hideDigitAnalogButtons()
        setupAction(.digit)
    }
    @objc func analogButtonAction() {
        hideDigitAnalogButtons()
        setupAction(.analog)
    }
    
    // Setup pin action after PinType and PinState chosed
    func setupAction(_ pinType: PinType) {
        arduino = ArduinoConnect()
        if pinState == .read {
            let image = UIImage(named: "ReadFrom")
            pinActionButton.setImage(image, for: UIControlState())
            digitalActionSwitch.isUserInteractionEnabled = false
            analogActionField.isUserInteractionEnabled = false
            //digitalActionSwitch.isOn = true
        }
        if pinState == .write {
            let image = UIImage(named: "WriteTo")
            pinActionButton.setImage(image, for: UIControlState())
            digitalActionSwitch.isUserInteractionEnabled = true
            analogActionField.isUserInteractionEnabled = true
            digitalActionSwitch.isOn = false
        }
        switch pinType {
        case .digit:
            setupDigitalActionSwitch()
        case .analog:
            setupAnalogActionField()
        default:
            print("Setup all other actions")
        }
    }
    
    // Pin actions
    func getDigitalData() {
        arduino?.getDigital(pin: pinID!) { result in
            if let result = result {
                self.digitalActionSwitch.setOn(result, animated: true)
            }
        }
    }
    func digitalActionSwitchChanged(_ mySwitch: UISwitch) {
        arduino?.setDigital(pin: pinID!, toState: digitalActionSwitch.isOn) { result in
            if !result {
                self.digitalActionSwitch.setOn(!self.digitalActionSwitch.isOn, animated: true)
            }
        }
    }
    
    func getAnalogData() {
        arduino?.getAnalog(pin: pinID!) { result in
            if let result = result {
                self.analogActionField.text = String(result)
            }
        }
    }
    
    func setPwmData() {
        print("Try to set analog data")
        //arduino?.setAnalog(pin: pinID!, toValue: Int(analogActionField.text!)!) {_ in }
    }
    
    // Manage Constraints and PinView elements
    func setup() {
        setupPinButton()
        if pinType == .analog || pinType == .digit || pinType == .pwm {
            setupReadWriteButtons()
            setupRemoveActionButton()
            if pinType == .pwm {
                setupBinPvmButtons()
            }
        }
    }
    
    func setupAnalogActionField() {
        addSubview(analogActionField)
        if pinSide == .left {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(51)]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":analogActionField]))
        } else {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0(51)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":analogActionField]))
        }
        analogActionField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        if pinState == .write {
            digitalActionSwitch.addTarget(self, action: #selector(PinView.digitalActionSwitchChanged(_:)), for: UIControlEvents.valueChanged)
        } else if pinState == .read {
            dataReceiveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getAnalogData), userInfo: nil, repeats: true)
        }
        self.getAnalogData()
    }
    
    func setupDigitalActionSwitch() {
        addSubview(digitalActionSwitch)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":digitalActionSwitch]))
        digitalActionSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        if pinState == .write {
            digitalActionSwitch.addTarget(self, action: #selector(PinView.digitalActionSwitchChanged(_:)), for: UIControlEvents.valueChanged)
        } else if pinState == .read {
            dataReceiveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getDigitalData), userInfo: nil, repeats: true)
        }
        self.getDigitalData()
    }
    
    func setupRemoveActionButton() {
        addSubview(removeActionButton)
        
        if pinSide == .right {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":removeActionButton, "v1":pinTitleLabel]))
        } else {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel,"v1":removeActionButton]))
        }
        addConstraint(NSLayoutConstraint(item: removeActionButton, attribute: .width, relatedBy: .equal, toItem: removeActionButton, attribute: .height, multiplier: 1/1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":removeActionButton]))
    }
    
    func setupPinButton() {
        addSubview(pinTitleLabel)
        addSubview(pinActionButton)
        
        if pinSide == .right {
            // pinActionButton constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinActionButton]))
            // pinTitleLabel constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(28)][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel, "v1":pinActionButton]))
        } else {
            pinActionButton.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            // pinActionButton constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinActionButton]))
            // pinTitleLabel constraints
            if pinType == .service {
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1][v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel, "v1":pinActionButton]))
            } else {
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1][v0(28)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel, "v1":pinActionButton]))
            }
        }
        
        // pinTitleLabel constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel]))
        
        // Buttons size
        addConstraint(NSLayoutConstraint(item: pinActionButton, attribute: .width, relatedBy: .equal, toItem: pinActionButton, attribute: .height, multiplier: 1/1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinActionButton]))
    }
    
    func setupBinPvmButtons() {
        addSubview(choseAnalogModeButton)
        addSubview(choseDigitalModeButton)
        
        if pinSide == .right {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":choseDigitalModeButton]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":choseAnalogModeButton, "v1":pinTitleLabel]))
        }
        addConstraint(NSLayoutConstraint(item: choseAnalogModeButton, attribute: .width, relatedBy: .equal, toItem: choseAnalogModeButton, attribute: .height, multiplier: 1/1, constant: 0))
        addConstraint(NSLayoutConstraint(item: choseDigitalModeButton, attribute: .width, relatedBy: .equal, toItem: choseDigitalModeButton, attribute: .height, multiplier: 1/1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":choseAnalogModeButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":choseDigitalModeButton]))
    }
    
    func setupReadWriteButtons() {
        
        addSubview(readFromPinButton)
        addConstraint(NSLayoutConstraint(item: readFromPinButton, attribute: .width, relatedBy: .equal, toItem: readFromPinButton, attribute: .height, multiplier: 1/1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":readFromPinButton]))
        
        if pinType != .analog {
            addSubview(writeToPinButton)
            if pinSide == .right {
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":readFromPinButton]))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":writeToPinButton, "v1":pinTitleLabel]))
            } else {
                readFromPinButton.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                writeToPinButton.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":readFromPinButton]))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel,"v1":writeToPinButton]))
            }
            addConstraint(NSLayoutConstraint(item: writeToPinButton, attribute: .width, relatedBy: .equal, toItem: writeToPinButton, attribute: .height, multiplier: 1/1, constant: 0))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":writeToPinButton]))
        } else {
            readFromPinButton.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel,"v1":readFromPinButton]))
        }
    }
    
    func hideReadWriteButtons() {
        readFromPinButton.isHidden = true
        writeToPinButton.isHidden = true
    }
    func hideDigitAnalogButtons() {
        choseAnalogModeButton.isHidden = true
        choseDigitalModeButton.isHidden = true
    }
}

enum PinState {
    case read, write
}

enum PinType {
    case digit, pwm, analog, service
}

enum PinSide {
    case left, right
}
