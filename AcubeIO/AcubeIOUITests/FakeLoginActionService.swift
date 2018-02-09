//
//  FakeLoginActionService.swift
//  AcubeIOUITests
//
//  Created by Uday Patil on 08/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import Foundation
import io
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
