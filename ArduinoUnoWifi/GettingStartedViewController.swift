//
//  GettingStartedViewController.swift
//  ArduinoUnoWifi
//
//  Created by Sergey Didanov on 27.05.17.
//  Copyright © 2017 Sergey Didanov. All rights reserved.
//

import UIKit

class GettingStartedViewController: UIViewController, UIWebViewDelegate {
    
    lazy var shareButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(GettingStartedViewController.shareLink))
    let activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var webView: UIWebView!
    let gettingStartedURL = "https://unowifi.didanov.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barActivityIndicator = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        self.navigationItem.setRightBarButtonItems([shareButton, barActivityIndicator], animated: true)
        
        self.automaticallyAdjustsScrollViewInsets = false
        webView.delegate = self
        let url = URL(string: gettingStartedURL)
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shareLink(_ sender:UIButton) {
        let activityViewController = UIActivityViewController(activityItems: [URL(string: gettingStartedURL)! as URL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
