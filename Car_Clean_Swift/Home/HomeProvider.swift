//
//  HomeProvider.swift
//  Car_Clean_Swift
//
//  Created by Alvaro Vinicius do Nascimento Fernandes on 12/12/19.
//  Copyright © 2019 Alvaro Vinicius do Nascimento Fernandes. All rights reserved.
//

import Foundation

class HomeProvider: RequestProvider {
    var queryParameters: [URLQueryItem]?
    

    var car: Home.Car
    
    var path: String {
        return "/carros/carros_\(car.rawValue).json"
    }
    
    var httpVerb: HTTPMethod {
        return .get
    }
    
    var bodyParameters: Encodable? {
        return ["carros_": car.rawValue]
    }
    
    init(car: Home.Car) {
        self.car = car
    }
    
}
