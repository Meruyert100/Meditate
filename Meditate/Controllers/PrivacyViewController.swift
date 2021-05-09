//
//  PrivacyViewController.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 5/9/21.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWebsite(websiteUrl: "https://www.swift.com/ru/node/239486")
    }
    
    private func fetchWebsite(websiteUrl: String?) {
        let url = URL(string: websiteUrl!)
        webView?.load(URLRequest(url: url!))
    }
}
