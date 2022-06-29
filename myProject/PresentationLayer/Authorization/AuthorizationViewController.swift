//
//  AuthorizationViewController.swift
//  myProject
//
//  Created by Владимир Курганов on 27.06.2022.
//

import UIKit
import SnapKit
import WebKit

final class AuthorizationViewController: UIViewController {
    
    //MARK: - Properties
    private var token: TokenModel?
    
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let setup = WKWebViewConfiguration()
        setup.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: setup)
        return webView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupURL()
        setupWebView()
    }
    
    //MARK: - Methods
    private func setupURL() {
        if let url = URL(string:"https://unsplash.com/oauth/authorize?client_id=D5gI1GG0bygjJBskI6m-ddOYXNn5wF0JfIAO5Y6uXks&redirect_uri=https://yandex.ru&response_type=code&scope=public") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - Extensions
extension AuthorizationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let currentURL = webView.url?.absoluteString.components(separatedBy: "?"),
              currentURL[0] == "https://yandex.ru/" else { return }
        
        let keyAndCode = currentURL[1].components(separatedBy: "=")
        let code = keyAndCode[1]
        
        AuthorizationResponse.shared.setupToken(code: code) { [weak self] Data in
            self?.token = Data
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .fullScreen
            self?.present(tabBarController, animated: true)
        }
    }
}
