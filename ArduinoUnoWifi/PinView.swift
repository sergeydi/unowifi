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
            setup()
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
    fileprivate var pinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(17)
        label.text = "Pin title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    fileprivate var pinActionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "ButtonAddAction")
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(pinButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    
    fileprivate func setup() {
        addSubview(pinTitleLabel)
        addSubview(pinActionButton)
        
        if pinSide == .right {
            // pinActionButton constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinActionButton]))
            // pinTitleLabel constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel, "v1":pinActionButton]))
        } else {
            // pinActionButton constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinActionButton]))
            // pinTitleLabel constraints
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1][v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel, "v1":pinActionButton]))
        }
        // pinActionButton constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinActionButton]))
        addConstraint(NSLayoutConstraint(item: pinActionButton, attribute: .width, relatedBy: .equal, toItem: pinActionButton, attribute: .height, multiplier: 1/1, constant: 0))
        // pinTitleLabel constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pinTitleLabel]))
    }
    
    func pinButtonAction() {
        print("Button touched")
    }
}

enum PinType {
    case none, digit, pwm, analog, reset, v5, v33
}

enum PinSide {
    case none, left, right
}
