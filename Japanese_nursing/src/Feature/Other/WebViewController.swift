//
//  WebViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/20.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import RxSwift
import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var webView: WKWebView!

    // MARK: - Properties

    var url: String = ""
    var titleText: String = ""

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = R.color.textBlue()
        navigationItem.title = titleText

        if let url = NSURL(string: url) {
            let request = NSURLRequest(url: url as URL)
            webView.load(request as URLRequest)
        }
    }
    
}

// MARK: - MakeInstance

extension WebViewController {

    static func makeInstance(url: String, titleText: String) -> UIViewController {
        guard let vc = R.storyboard.webView.webViewController() else {
            assertionFailure("Can't make instance 'WebViewController'.")
            return UIViewController()
        }
        vc.url = url
        vc.titleText = titleText
        return vc
    }

}
