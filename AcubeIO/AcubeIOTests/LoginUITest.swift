//
//  LoginUITest.swift
//  AcubeIOTests
//
//  Created by Sudhindra on 08/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import XCTest
@testable import AcubeIO

class FakeLoginActionService: LoginServiceDelegate {
    var isLoginSuccessFullCalled = false
    var isHandleErrorCalled = false
    var error: Error? = nil
    
    func loginSuccessfull(withUser user: UserModel) {
        isLoginSuccessFullCalled = true
    }
    
    func handleLoginErrors(error: Error) {
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
        delegate.handleLoginErrors(error: error)
    }
}

class LoginUITest: XCTestCase {
    var vcLogin : LoginViewController!
    let acubeRSA = AcubeRsa()
    let testUser = UserModel(_userId: "manjudg" , _authToken :"123" , _refreshToken : "456")
    let testUserProfile = UserProfileModel()
    
     override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginPage") as! LoginViewController
        vcLogin = vc
        _ = vcLogin.view // To call viewDidLoad
    }
    
    func testInvalidCredentialsInLoginServiceEndToEnd() {
        
        let actionDelegate = FakeLoginActionService()
        
        vcLogin.userNameTxt.text = "manjudg"
        vcLogin.passwordTxt.text = "manjudg"
        vcLogin.loginService = FakeFailureLoginService(error: .invalidCredentials, delegate: actionDelegate)
        vcLogin.btnLogin.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginServiceError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(String(describing: actionDelegate.error))")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginServiceError.invalidCredentials, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginServiceError.invalidCredentials) but got \(receivedError)")
    }
    
    
    func testDataNilInLoginServiceEndToEnd() {
        let actionDelegate = FakeLoginActionService()
        vcLogin.userNameTxt.text = "manjudg"
        vcLogin.passwordTxt.text = "manjudg"
        vcLogin.loginService = FakeFailureLoginService(error: .nilData, delegate: actionDelegate)
        vcLogin.btnLogin.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginServiceError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(String(describing: actionDelegate.error))")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginServiceError.nilData, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginServiceError.nilData) but got \(receivedError)")
    }
    
    func testInvalidUsernameLengthEndToEnd() {
        let actionDelegate = FakeLoginActionService()
        vcLogin.userNameTxt.text = "m"
        vcLogin.passwordTxt.text = "manjudg"
        vcLogin.loginService = LoginServiceHandler(delegate: actionDelegate)
        vcLogin.btnLogin.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginFormValidationError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(String(describing: actionDelegate.error))")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginFormValidationError.invalidUsernameLength, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginFormValidationError.invalidUsernameLength) but got \(receivedError)")
    }
    
    func testInvalidPasswordLengthEndToEnd() {
        let actionDelegate = FakeLoginActionService()
        vcLogin.userNameTxt.text = "manjudg"
        vcLogin.passwordTxt.text = "m"
        vcLogin.loginService = LoginServiceHandler(delegate: actionDelegate)
        vcLogin.btnLogin.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginFormValidationError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(String(describing: actionDelegate.error))")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginFormValidationError.invalidPasswordLength, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginFormValidationError.invalidPasswordLength) but got \(receivedError)")
    }
    
    func testWrongStatusCodeInLoginServiceEndToEnd() {
        
        let actionDelegate = FakeLoginActionService()
        vcLogin.userNameTxt.text = "manjudg"
        vcLogin.passwordTxt.text = "manjudg"
        vcLogin.loginService = FakeFailureLoginService(error: .wrongStatusCode, delegate: actionDelegate)
        vcLogin.btnLogin.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginServiceError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(String(describing: actionDelegate.error))")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginServiceError.wrongStatusCode, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginServiceError.wrongStatusCode) but got \(receivedError)")
    }
    
    
    func testClearFields() {
        let actionDelegate = FakeLoginActionService()
        vcLogin.userNameTxt.text = "manjudg"
        vcLogin.passwordTxt.text = "manjudg"
        vcLogin.loginService = FakeFailureLoginService(error: .emptyText, delegate: actionDelegate)
        vcLogin.clearFields()
        XCTAssertTrue(vcLogin.userNameTxt.text == "" )
        XCTAssertTrue(vcLogin.passwordTxt.text == "")
    }
    
    func testsavePersonAuthToken(){
        vcLogin.savePersonAuthToken(_userModel: testUser)
        let returnUser = testUser.getUserDetails()
        XCTAssertTrue(acubeRSA.decryptString(_inputString: returnUser.getAuthToken()) == "123")
        XCTAssertTrue(acubeRSA.decryptString(_inputString: returnUser.getRefreshToken()) == "456")
        XCTAssertTrue(returnUser.getUserId() == "manjudg" )
    }
    
    func testSaveLoginSuccessfull() {
        vcLogin.loginSuccessfull(withUser: testUser)
        let returnUser = testUser.getUserDetails()
        XCTAssertTrue(acubeRSA.decryptString(_inputString: returnUser.getAuthToken()) == "123")
        XCTAssertTrue(acubeRSA.decryptString(_inputString: returnUser.getRefreshToken()) == "456")
        XCTAssertTrue(returnUser.getUserId() == "manjudg" )        
    }
    
    
}

