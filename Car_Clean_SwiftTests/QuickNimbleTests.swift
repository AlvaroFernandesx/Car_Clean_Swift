//
//  QuickNimbleTests.swift
//  Car_Clean_SwiftTests
//
//  Created by Alvaro Vinicius do Nascimento Fernandes on 20/12/19.
//  Copyright © 2019 Alvaro Vinicius do Nascimento Fernandes. All rights reserved.
//

import Quick
import Nimble
import PromiseKit

@testable import Car_Clean_Swift




class QuickNimbleTests: QuickSpec {
    
    class DummyHomePresenter: HomePresentationLogic {
        
        var hasCalledReloadCollection = false
        var hasCalledError = false
        
        func reloadCollection() { hasCalledReloadCollection = true }
        func presentRequestFailureAlert() { hasCalledError = true }
        
    }
    
    class MockWorker: HomeWorker {
        var isSucesss = true
        
        override func getCarList(car: Home.Car) -> Promise<Home.CarModels.Response> {
            if isSucesss {
                let carro = Home.CarModels.Carro(nome: "GOL", desc: "QUADRADO BOLADAO")
                let carro1 = Home.CarModels.Carro(nome: "CELTA", desc: "QUADRADO BOLADAO")
                let carros = Home.CarModels.Carros(carro: [carro,carro1,carro])
                let response = Home.CarModels.Response(carros: carros)
                
                return Promise {seal in
                    seal.fulfill(response)
                }
            } else {
                let error: Error = NSError(domain: "", code: 404, userInfo: nil)
                return Promise {seal in
                    seal.reject(error)
                }
            }
        }
    }

    var subject: HomeInteractor!
    var dummyHomePresenter: DummyHomePresenter!
    var mockWorker = MockWorker()
    
    override func spec() {
        super.spec()
        
        describe("HomeInteractor") {
            beforeEach {
                let interactor = HomeInteractor(worker: self.mockWorker)
                self.dummyHomePresenter = DummyHomePresenter()
                interactor.presenter = self.dummyHomePresenter
                self.subject = interactor
            }
            
            describe("#getCars") {
                context("when is lux") {
                    it("return luxo") {
                        expect(self.subject.getTypeCar(0)).to(equal(Home.Car.luxo))
                    }
                }
                context("when is classic") {
                    it("return classicos"){
                        expect(self.subject.getTypeCar(1)).to(equal(Home.Car.classicos))
                    }
                }
                context("when is sport") {
                    it("return esportivos"){
                        expect(self.subject.getTypeCar(2)).to(equal(Home.Car.esportivos))
                    }
                }
                context("when is default") {
                    it("return luxo"){
                        expect(self.subject.getTypeCar(35)).to(equal(Home.Car.luxo))
                    }
                }
            }
            
            describe("#numberOfRows") {
                context("when is nil") {
                    it("return 0") {
                        expect(self.subject.numberOfRows).to(equal(0))
                    }
                }
                context("when is nil") {
                    it("return 3") {
                        self.subject.response = self.mockWorker.getCarList(car: .luxo).value
                        expect(self.subject.numberOfRows).to(equal(3))
                    }
                }
            }
            describe("#cellForRow") {
                context("when is nil") {
                    it("returns nil") {
                        let selectedCar = self.subject.cellForRow(at: 0)
                        expect(selectedCar?.nome).to(beNil())
                    }
                }
                context("when is not nil") {
                    it("return nil") {
                        self.subject.response = self.mockWorker.getCarList(car: .luxo).value
                        let selectedCar = self.subject.cellForRow(at:1)
                        expect(selectedCar?.nome).to(equal("CELTA"))
                    }
                }
            }
            describe("#load") {
                context("when is success") {
                    it("return cars") {
                        self.mockWorker.isSucesss = true
                        self.subject.handleSuccess(self.mockWorker.getCarList(car: Home.Car.luxo).value!)
                        expect(self.dummyHomePresenter.hasCalledReloadCollection).to(beTrue())
                    }
                }
                context("when is failed") {
                    it("return error") {
                        self.mockWorker.isSucesss = false
                        self.subject.handleFailure(self.mockWorker.getCarList(car: Home.Car.luxo).error!)
                        expect(self.dummyHomePresenter.hasCalledError).to(beTrue())
                    }
                }
            }
        }
    }
}
