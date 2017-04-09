//
//  PinView.swift
//  ArduinoUnoWifi
//
//  Created by Sergey Didanov on 08.04.17.
//  Copyright © 2017 Sergey Didanov. All rights reserved.
//

import UIKit

class PinView: UIView {
    
    var pinID = 0
    var pinSide: PinSide = .none {
        didSet {
            switch pinSide {
            case .left:
                pinTitleLabel.textAlignment = NSTextAlignment.left
            default:
                pinTitleLabel.textAlignment = NSTextAlignment.right
            }
        }
    }
    var pinType: PinType = .none {
        didSet {
            switch pinType {
            case .none:
                pinTitleLabel.text = ""
            case .digit:
                pinTitleLabel.text = String(pinID)
            case .pwm:
                pinTitleLabel.text = "~\(String(pinID))"
            case .analog:
                pinTitleLabel.text = "A\(String(pinID))"
            case .reset:
                pinTitleLabel.text = "Reset"
            case .v33:
                pinTitleLabel.text = "3.3V"
            case .v5:
                pinTitleLabel.text = "5V"
            }
        }
    }
    fileprivate var pinState: PinState = .none {
        didSet {
            switch pinState {
            case .read:
                let image = UIImage(named: "ReadFrom")
                pinActionButton.setImage(image, for: UIControlState())
            case .write:
                let image = UIImage(named: "WriteTo")
                pinActionButton.setImage(image, for: UIControlState())
            case .none:
                let image = UIImage(named: "ButtonAddAction")
                pinActionButton.setImage(image, for: UIControlState())
            }
        }
    }
    fileprivate let pinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(17)
        label.text = "Pin title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    fileprivate let pinActionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "ButtonAddAction")
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(pinButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let readFromPinButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "ReadFrom")
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(readFromPinAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    fileprivate let writeToPinButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "WriteTo")
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(writeToPinAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    fileprivate let removeActionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "CancelButton")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        button.isHidden = true
        return button
    }()
    
    // MARK: Init View
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
    }
    
    func pinButtonAction() {
        print("Pin button touched")
        if isConnectedToArduino {
            if pinState == .none {
                // Show read and write buttons
                if readFromPinButton.isHidden && writeToPinButton.isHidden {
                    readFromPinButton.isHidden = false
                    writeToPinButton.isHidden = false
                } else {
                    hideReadWriteButtons()
                }
            } else {
                // Show remove action button
                if removeActionButton.isHidden {
                    removeActionButton.isHidden = false
                } else {
                    removeActionButton.isHidden = true
                }
            }
        } else {
            let alert = UIAlertController(title: "Connection alert", message: "Please connect to Arduino UNO FiWi!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    @objc fileprivate func readFromPinAction() {
        print("Read from button touched")
        pinState = .read
        hideReadWriteButtons()
    }
    
    @objc fileprivate func writeToPinAction() {
        print("Write to button touched")
        pinState = .write
        hideReadWriteButtons()
    }
    @objc fileprivate func removeAction() {
        print("Write to button touched")
        pinState = .none
        removeActionButton.isHidden = true
    }
    
    fileprivate func hideReadWriteButtons() {
        readFromPinButton.isHidden = true
        writeToPinButton.isHidden = true
    }
    
    // Setup Constraints
    func setup() {
        setupPinButton()
        if pinType == .analog || pinType == .digit || pinType == .pwm {
            setupReadWriteButtons()
            setupRemoveActionButton()
        }
    }
    
    fileprivate func setupRemoveActionButton() {
        addSubview(removeActionButton)
        
        if pinSide == .right {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":removeActionButton]))
        } else {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-30-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":removeActionButton]))
        }
        addConstraint(NSLayoutConstraint(item: removeActionButton, attribute: .width, relatedBy: .equal, toItem: removeActionButton, attribute: .height, multiplier: 1/1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":removeActionButton]))
    }

    fileprivate func setupPinButton() {
        addSubview(pinTitleLabel)
        addSubview(pinActionButton)
        
        if pinSide == .right {
            // pinActionButton constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinActionButton]))
            // pinTitleLabel constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel, "v1":pinActionButton]))
        } else {
            pinActionButton.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            // pinActionButton constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinActionButton]))
            // pinTitleLabel constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1][v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel, "v1":pinActionButton]))
        }
        
        // pinTitleLabel constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel]))
        
        // Buttons size
        addConstraint(NSLayoutConstraint(item: pinActionButton, attribute: .width, relatedBy: .equal, toItem: pinActionButton, attribute: .height, multiplier: 1/1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinActionButton]))
    }
    
    fileprivate func setupReadWriteButtons() {
        addSubview(readFromPinButton)
        addSubview(writeToPinButton)
        
        if pinSide == .right {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":readFromPinButton]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":readFromPinButton, "v1":writeToPinButton]))
        } else {
            readFromPinButton.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            writeToPinButton.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":readFromPinButton]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":readFromPinButton, "v1":writeToPinButton]))
        }
        addConstraint(NSLayoutConstraint(item: readFromPinButton, attribute: .width, relatedBy: .equal, toItem: readFromPinButton, attribute: .height, multiplier: 1/1, constant: 0))
        addConstraint(NSLayoutConstraint(item: writeToPinButton, attribute: .width, relatedBy: .equal, toItem: writeToPinButton, attribute: .height, multiplier: 1/1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":readFromPinButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":writeToPinButton]))
    }
}

enum PinState {
    case none, read, write
}

enum PinType {
    case none, digit, pwm, analog, reset, v5, v33
}

enum PinSide {
    case none, left, right
}
