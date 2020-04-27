//
//  AuthViewController.swift
//  Notes
//
//  Created by Igor Podolskiy on 22.04.2020.
//  Copyright © 2020 Igor Podolskiy. All rights reserved.
//

import UIKit
import WebKit

struct GithubToken: Decodable {
    let access_token: String
}

protocol AuthViewControllerDelegate: class {
    func tokenChanged(token: String)
}

class AuthViewController: UIViewController {

    weak var delegate: AuthViewControllerDelegate?

    private let webView = WKWebView()

    private let clientId = "800bfd6111fb241ec83c" // GitHub OAuth APP ID
    private let clientSecret = "24bcee28ea1004a10aabe40a1042ecc093b8d2e6" // GitHub OAuth APP SecredID

    private let scheme = "notes" // callback scheme

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        guard let request = codeGetRequest else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }

    private func setupViews() {
        view.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private var codeGetRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize") else { return nil }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "\(clientId)"),
            URLQueryItem(name: "scope", value: "gist")
        ]
        guard let url = urlComponents.url else { return nil }

        return URLRequest(url: url)
    }

    private func getTokenGetRequest(code: String) -> URLRequest? {
        var components = URLComponents(string: "https://github.com/login/oauth/access_token")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code", value: code)
        ]

        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        return URLRequest(url: url)
    }

}

extension AuthViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url, url.scheme == scheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {

                guard var request = getTokenGetRequest(code: code) else { return }
                request.setValue("application/json", forHTTPHeaderField: "Accept")

                URLSession.shared.dataTask(with: request) { (data, _, _) in
                    if let data = data {
                        guard let token =  try? JSONDecoder().decode(GithubToken.self, from: data) else { return }
                        self.delegate?.tokenChanged(token: token.access_token)
                    }
                }.resume()
            }

            dismiss(animated: true, completion: nil)
        }
        do {
            decisionHandler(.allow)
        }
    }
}
