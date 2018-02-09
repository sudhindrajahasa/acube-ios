//
//  Utilities.swift
//  AcubeIO
//
//  Created by Sudhindra on 07/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import Foundation

enum LoginFormValidationError: LocalizedError {
    case invalidUsernameLength
    case invalidPasswordLength
    case invalidPasswordCharacters
    case invalidCredentials
    case invalidRequest
    
    var errorDescription: String? {
        var errorString:String? = nil
        switch self {
        case .invalidUsernameLength:
            errorString = "Your username should have atleast 2 and atmost 10 characters"
        case .invalidPasswordLength:
            errorString = "Your password should be of atleast 3 characters with atleast one upercase letter and one decimal digit"
        case .invalidPasswordCharacters:
            errorString = "Your password should have atleast one upercase letter and one decimal digit"
        case .invalidCredentials:
            errorString = "Invalid credentials"
        case .invalidRequest:
            errorString = "Bad request"
        }
        
        return errorString
    }
}


enum UserProfileValidationError: LocalizedError {
    case invalidAccessToken
    case invalidRequest
    
    var errorDescription: String? {
        var errorString:String? = nil
        switch self {
        case .invalidAccessToken:
            errorString = "Invalid Access Token"
        case .invalidRequest:
            errorString = "Bad request"
        }        
        return errorString
    }
}
