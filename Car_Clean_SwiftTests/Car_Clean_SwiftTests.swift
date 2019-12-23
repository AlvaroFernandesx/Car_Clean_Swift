//
//  Car_Clean_SwiftTests.swift
//  Car_Clean_SwiftTests
//
//  Created by Alvaro Vinicius do Nascimento Fernandes on 12/12/19.
//  Copyright © 2019 Alvaro Vinicius do Nascimento Fernandes. All rights reserved.
//

import XCTest
@testable import Car_Clean_Swift

class Car_Clean_SwiftTests: XCTestCase {

    class DummyHomePresenter: HomePresentationLogic {
        
        var hasCalledReloadCollection = false
        var hasCalledError = false
        
        func reloadCollection() { hasCalledReloadCollection = true }
        func presentRequestFailureAlert() { hasCalledError = true }
        
    }
    
    var subject: HomeInteractor!
    var dummyHomePresenter: DummyHomePresenter!
    var worker: HomeWorker!
    
    override func setUp() {
        let interactor = HomeInteractor()
        self.dummyHomePresenter = DummyHomePresenter()
        interactor.presenter = self.dummyHomePresenter
        self.subject = interactor
    }
    
    func getCars() -> Home.CarModels.Response {
        let carro = Home.CarModels.Carro(nome: "GOL", desc: "QUADRADO BOLADAO")
        let carro1 = Home.CarModels.Carro(nome: "CELTA", desc: "QUADRADO BOLADAO")
        let carros = Home.CarModels.Carros(carro: [carro,carro1,carro])
        let response = Home.CarModels.Response(carros: carros)
        
        return response
    }
    
    func test_get_type_car_when_is_lux() {
        XCTAssertEqual(subject.getTypeCar(0), Home.Car.luxo)
    }
    
    func test_get_type_car_when_is_classic() {
        XCTAssertEqual(subject.getTypeCar(1), Home.Car.classicos)
    }
    
    func test_get_type_car_when_is_sportive() {
        XCTAssertEqual(subject.getTypeCar(2), Home.Car.esportivos)
    }
    
    func test_get_type_car_when_is_default() {
        XCTAssertEqual(subject.getTypeCar(15), Home.Car.luxo)
    }
    
    func test_number_of_rows_when_is_nil() {
        XCTAssertEqual(subject.numberOfRows, 0)
    }
    
    func test_number_of_rows() {
        subject.response = getCars()
        XCTAssertEqual(subject.numberOfRows , 3)
    }
    
    func test_cell_for_row_when_is_nill() {
        let selectedCar = subject.cellForRow(at: 0)
        XCTAssertEqual(selectedCar?.nome, nil)
    }
    
    func test_cell_for_row() {
        subject.response = getCars()
        let selectedCar = subject.cellForRow(at: 1)
        XCTAssertEqual(selectedCar?.nome, "CELTA")
    }
    
    func test_load_when_is_success() {
        subject.handleSuccess(getCars())
        XCTAssertTrue(dummyHomePresenter.hasCalledReloadCollection)
    }
    
    func test_load_when_is_error() {
        let error: Error = NSError(domain: "", code: 404, userInfo: nil)
        subject.handleFailure(error)
        XCTAssertTrue(dummyHomePresenter.hasCalledError)
    }
    
}
