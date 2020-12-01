//
//  WebViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/20.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var backButton: UIButton!

    // MARK: - Properties

    var url: String = ""
    var titleText: String = ""
    private var progressView = UIProgressView()
    private var disposeBag = DisposeBag()
    

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        // ボタンの出し分け
        if let _ = self.navigationController {
            backButton.setImage(R.image.back_button(), for: .normal)
        } else {
            backButton.setImage(R.image.close_button(), for: .normal)
        }

        navigationController?.navigationBar.tintColor = R.color.textBlue()
        navigationItem.title = titleText
        navigationController?.setNavigationBarHidden(true, animated: true)

        if let url = NSURL(string: url) {
            let request = NSURLRequest(url: url as URL)
            webView.load(request as URLRequest)
        }

        // インジケータとプログレスバーのKVO
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        // プログレスバー
        progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = R.color.textDarkGray()
        view.addSubview(progressView)

        subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.setProgress(0.0, animated: false)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        } else if keyPath == "loading"{
            if webView.isLoading {
                progressView.setProgress(0.1, animated: true)
            } else {
                progressView.setProgress(0.0, animated: false)
            }
        }
    }

    private func subscribe() {
        // 戻るボタンタップ
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            if let nc = self?.navigationController {
                nc.popViewController(animated: true)
            } else {
                self?.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
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
