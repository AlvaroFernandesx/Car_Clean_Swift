//
//  RequestProvider.swift
//  Car_Clean_Swift
//
//  Created by Alvaro Vinicius do Nascimento Fernandes on 12/12/19.
//  Copyright © 2019 Alvaro Vinicius do Nascimento Fernandes. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol RequestProvider {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpVerb: HTTPMethod { get }
    var asURLRequest: URLRequest { get }
}

extension RequestProvider {
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "livroiphone.com.br"
    }
    
    var asURLRequest: URLRequest {
        
        var components = URLComponents()
        
        components.scheme = scheme
        components.host = host
        components.path = path
        
        print(components.url!.absoluteString)
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = httpVerb.rawValue

        return request
    }
    
}
