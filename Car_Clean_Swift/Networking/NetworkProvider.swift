//
//  NetworkProvider.swift
//  Car_Clean_Swift
//
//  Created by Alvaro Vinicius do Nascimento Fernandes on 12/12/19.
//  Copyright © 2019 Alvaro Vinicius do Nascimento Fernandes. All rights reserved.
//

import Foundation
import PromiseKit

class NetworkProvider {
    
    func execute<T: Decodable>(request: RequestProvider, parser: T.Type) -> Promise<T> {
        return Promise<T> { seal in
            URLSession.shared.dataTask(with: request.asURLRequest) { (data, response, _) in
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                if 200...299 ~= statusCode {
                    let data = data ?? Data()
                    do {
                        let model = try JSONDecoder().decode(T.self, from: data)
                        seal.fulfill(model)
                        print(model)
                    } catch {
                        seal.reject(error)
                    }
                } else {
                    seal.reject(NSError(domain: "Aconteceu um erro", code: 0, userInfo: nil))
                }
            }.resume()
        }
    }
    
}
