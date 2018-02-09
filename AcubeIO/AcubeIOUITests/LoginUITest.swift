//
//  LoginUITest.swift
//  AcubeIOUITests
//
//  Created by Uday Patil on 08/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import XCTest
@testable import AcubeIO

class LoginUITest: XCTestCase {
    var vcLogin : LoginViewController
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginPage") as! LoginViewController
        vcLogin = vc
        _ = vcLogin.view // To call viewDidLoad
       
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}

class FakeLoginActionService: LoginServiceDelegate {
    
    var isLoginSuccessFullCalled = false
    var isHandleErrorCalled = false
    var error: Error? = nil
    
    func loginSuccessfull(withUser user: User) {
        isLoginSuccessFullCalled = true
    }
    
    func handle(error: Error) {
        isHandleErrorCalled = true
        self.error = error
    }
}

class FakeFailureLoginService: LoginService {
    let error: LoginServiceError
    var delegate: LoginServiceDelegate
    
    init(error: LoginServiceError, delegate: LoginServiceDelegate) {
        self.error = error;
        self.delegate = delegate
    }
    func login(withUsername username: String?, password: String?) {
        delegate.handle(error: error)
    }
}
