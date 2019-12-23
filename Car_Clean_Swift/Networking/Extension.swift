//
//  ENV.swift
//  Car_Clean_Swift
//
//  Created by Alvaro Vinicius do Nascimento Fernandes on 12/12/19.
//  Copyright © 2019 Alvaro Vinicius do Nascimento Fernandes. All rights reserved.
//

import Foundation

extension Bundle {
    
    var scheme: String {
        return self.object(forInfoDictionaryKey: "Scheme") as! String
    }
    
    var host: String {
        return self.object(forInfoDictionaryKey: "Host") as! String
    }
    
}

