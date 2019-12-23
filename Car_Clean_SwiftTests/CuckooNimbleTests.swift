//
//  CuckooNimbleTests.swift
//  Car_Clean_SwiftTests
//
//  Created by Alvaro Vinicius do Nascimento Fernandes on 20/12/19.
//  Copyright © 2019 Alvaro Vinicius do Nascimento Fernandes. All rights reserved.
//

import Cuckoo
import Nimble
import XCTest
import PromiseKit

@testable import Car_Clean_Swift

class CuckooNimbleTests: XCTestCase {
    
    var subject: HomeInteractor!
    var mockPresenter: MockHomePresenter!
    var worker: MockHomeWorker!
    var lixo = MockHomeWorker()
        
    override func setUp() {
        PromiseKit.conf.Q.map = nil
        PromiseKit.conf.Q.return = nil
        worker = MockHomeWorker()
        let interactor = HomeInteractor(worker: worker)
        self.mockPresenter = MockHomePresenter()
        interactor.presenter = self.mockPresenter
        self.subject = interactor
    }
    
    func getCars() -> Home.CarModels.Response {
        let carro = Home.CarModels.Carro(nome: "GOL", desc: "QUADRADO BOLADAO")
        let carro1 = Home.CarModels.Carro(nome: "CELTA", desc: "QUADRADO BOLADAO")
        let carros = Home.CarModels.Carros(carro: [carro,carro1,carro])
        let response = Home.CarModels.Response(carros: carros)
        
        return response
    }
    
    func testGetCarsWhenIsLux() {
        expect(self.subject.getTypeCar(0)).to(equal(Home.Car.luxo))
    }
    
    func testGetCarsWhenIsClassic() {
        expect(self.subject.getTypeCar(1)).to(equal(Home.Car.classicos))
    }
    
    func testGetCarsWhenIsSport() {
        expect(self.subject.getTypeCar(2)).to(equal(Home.Car.esportivos))
    }
    
    func testGetCarsWhenIsDefault() {
        expect(self.subject.getTypeCar(20)).to(equal(Home.Car.luxo))
    }
    
    func testNumberOfRowsWhenIsNil() {
        expect(self.subject.numberOfRows).to(equal(0))
    }
    
    func testNumberOfRowsWhenHasResponse() {
        subject.response = getCars()
        expect(self.subject.numberOfRows).to(equal(3))
    }
    
    func testCellForRowWhenIsNil() {
        expect(self.subject.cellForRow(at: 0)).to(beNil())
    }
    
    func testCellForRowWhenHasResponse() {
        subject.response = getCars()
        expect(self.subject.cellForRow(at: 1)?.nome).to(equal("CELTA"))
    }

    func testLoadWhenIsPerfect() {
        
        stub(mockPresenter) { stub in
            when(stub.reloadCollection()).thenDoNothing()
        }
        
//        stub(worker) { stub in
//            when(stub.getCarList(car: Home.Car.luxo)).then { _ -> Promise<Home.CarModels.Response> in
//                return .value(getCars())
//                }
//        }
        
        subject.handleSuccess(getCars())
        verify(mockPresenter).reloadCollection()
    }
    
    func testLoadFailureRequest() {

        stub(mockPresenter) { stub in
            when(stub.presentRequestFailureAlert()).thenDoNothing()
        }
        
//        stub(worker) { stub in
//            when(stub.getCarList(car: .luxo)).then { _ -> Promise<Home.CarModels.Response> in
//                return Promise<Home.CarModels.Response> { seal in seal.reject(error) }
//            }
//        }
        
        let error: Error = NSError(domain: "", code: 404, userInfo: nil)

        subject.handleFailure(error)
        verify(mockPresenter).presentRequestFailureAlert()

    }
}
