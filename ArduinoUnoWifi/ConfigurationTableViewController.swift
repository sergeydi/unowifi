//
//  ConfigurationTableViewController.swift
//  ArduinoUnoWifi
//
//  Created by Sergey Didanov on 25.04.17.
//  Copyright © 2017 Sergey Didanov. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class ConfigurationTableViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func closeConfigurationView(_ sender: Any) { self.dismiss(animated: true, completion: nil) }
    @IBOutlet weak var autoConnectionSwitch: UISwitch!
    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var connectButton: UILabel!
    
    let arduino = ArduinoConnect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoConnectionSwitch.addTarget(self, action: #selector(ConfigurationTableViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        if let arduinoIP = UserDefaults.standard.object(forKey: "arduinoIP") as? String {
            ipAddressTextField.text = arduinoIP
            connectButton.text = "Disconnect"
            if UserDefaults.standard.object(forKey: "autoLogin") as? Bool == true {
                autoConnectionSwitch.setOn(true, animated: false)
            }
        }
    }
    
    func switchChanged(_ mySwitch: UISwitch) {
        if UserDefaults.standard.object(forKey: "arduinoIP") as? String != nil {
            UserDefaults.standard.set(self.autoConnectionSwitch.isOn, forKey: "autoLogin")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            connectButtonAction()
            
        case 2:
            guard MFMailComposeViewController.canSendMail() else { return }
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["support@didanov.com"])
            mailComposeVC.setSubject("UNO WiFi issue")
            present(mailComposeVC, animated: true, completion: nil)
            
        default:
            return
        }
    }
    
    func connectButtonAction() {
        if connectButton.text == "Connect" {
            if ((ipAddressTextField.text?.range(of: "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$", options: .regularExpression)) != nil) {
                activityIndicator.startAnimating()
                arduino.connect(to: ipAddressTextField.text!) { connected in
                    if connected {
                        isConnectedToArduino = true
                        UserDefaults.standard.set(self.ipAddressTextField.text!, forKey: "arduinoIP")
                        UserDefaults.standard.set(self.autoConnectionSwitch.isOn, forKey: "autoLogin")
                        self.ipAddressTextField.resignFirstResponder()
                        self.connectButton.text = "Disconnect"
                        self.showAlert(withMessage: "Connection to Arduino succeeded")
                    } else {
                        isConnectedToArduino = false
                        self.showAlert(withMessage: "Could not connect to Arduino")
                    }
                    self.activityIndicator.stopAnimating()
                }
            } else {
                self.showAlert(withMessage: "IP-address incorrect")
            }
        } else {
            isConnectedToArduino = false
            ipAddressTextField.text = ""
            autoConnectionSwitch.setOn(false, animated: true)
            UserDefaults.standard.removeObject(forKey: "arduinoIP")
            UserDefaults.standard.removeObject(forKey: "autoLogin")
            connectButton.text = "Connect"
        }
    }
    
    func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// Send mail extension
extension ConfigurationTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
