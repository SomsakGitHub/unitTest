//
//  unitTestTests.swift
//  unitTestTests
//
//  Created by somsak on 27/5/2564 BE.
//

import XCTest
@testable import unitTest

class unitTestTests: XCTestCase {

    func testAddStuff(){
        
        let math = MathStuff()
        
        let result = math.addNumbers(x: 1, y: 2)
        XCTAssertEqual(result, 3)
        
    }
    
    func testMultiplyStuff(){
        
        let math = MathStuff()
        
        let result = math.multipleNumbers(x: 2, y: 1)
        XCTAssertEqual(result, 2)
        
    }
    
    func testDivideStuff(){
        
        let math = MathStuff()
        
        let result = math.divideNumbers(x: 10, y: 2)
        XCTAssertEqual(result, 5)
        
    }

}
