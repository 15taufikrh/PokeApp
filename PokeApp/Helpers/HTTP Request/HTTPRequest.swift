//
//  HTTPRequest.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol HTTPRequest {
    var method: HTTPMethods { get }
    var path: String { get }
    var parameters: [String: Any] { get }
}

extension HTTPRequest {
    func request(with baseUrl: URL) -> URLRequest {
        let url = "\(baseUrl.absoluteString)\(self.path)"
        let finalUrl = URL(string: url)!
        
        var request = finalUrl.setParameter(parameters: parameters, method: method)
        request.httpMethod = self.method.rawValue
        print("HEADER = \(String(describing: request.allHTTPHeaderFields))")
        print("BODY = \(String(describing: request.httpBody))")
        print("URL = \(String(describing: request.url?.absoluteString))")
        print("METHOD = \(request.httpMethod ?? "NONE")")
        return request
    }
}

extension URL {
    func setParameter(parameters: [String: Any], method: HTTPMethods) -> URLRequest {
        switch method {
        case .GET:
            var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
            var queryItems: [URLQueryItem] = []
            for key in parameters.keys {
                queryItems.append(URLQueryItem(name: key, value: "\(parameters[key]!)"))
            }
            urlComponents.queryItems = queryItems
            urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            return URLRequest(url: urlComponents.url!)
        default:
            var request = URLRequest(url: self)
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            return request
        }
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
