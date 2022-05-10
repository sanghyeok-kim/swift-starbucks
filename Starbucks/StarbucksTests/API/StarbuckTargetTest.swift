//
//  StarbuckTargetTest.swift
//  StarbucksTests
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation
import Nimble
import Quick
import XCTest

@testable import Starbucks

class BroadcastTargetTests: XCTestCase {

    var sut: StarbucksTarget!

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_requestHome() {
        sut = .requestHome
        expect(self.sut.path).to(beNil())
        expect(self.sut.parameter).to(beNil())
        expect(self.sut.method).to(equal(.get))
    }
}
