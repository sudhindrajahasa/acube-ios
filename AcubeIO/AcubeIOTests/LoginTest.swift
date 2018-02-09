//
//  LoginTest.swift
//  AcubeIOTests
//
//  Created by Sudhindra on 07/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import XCTest
@testable import AcubeIO

class LoginTest: XCTestCase {
    var testUser : UserModel!
    
    override func setUp() {
        super.setUp()
        testUser = UserModel(_userId: "manjudg" , _authToken :"123" , _refreshToken : "456")
    }
    
    override func tearDown() {
        super.tearDown()
        testUser = nil
    }
    
    func testSaveUser(){
        testUser.saveUser();
        let returnUser = testUser.getUserDetails();
        XCTAssertTrue(returnUser.getUserId() == testUser.getUserId())
    }
    
    func testGetUserDetail(){
        let userProfileModel = testUser.getUserDetails();
        XCTAssertTrue(userProfileModel.getUserId() == "manjudg")
    }
    
}
