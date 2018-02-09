//
//  LoginService.swift
//  AcubeIO
//
//  Created by Sudhindra on 07/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum LoginServiceError: LocalizedError {
    case invalidCredentials
    case nilData
    case wrongStatusCode
    case unknown
    case emptyText
    
    var errorDescription: String? {
        var errorString:String? = nil
        switch self {
        case .invalidCredentials:
            errorString = "The user credentials are invalid"
        case .nilData:
            errorString = "Failed to fetch your data, please try again later"
        case .wrongStatusCode:
            errorString = "Wrong status code received, please try again later"
        case .emptyText:
            errorString = "Empty texts"
        default:
            errorString = "Something went wrong please try again later"
        }
        
        return errorString
    }
}

protocol LoginService {
    var delegate: LoginServiceDelegate { get }
    func login(withUsername username: String?, password: String?)
}

// Delegate for the LoginService
protocol LoginServiceDelegate {
    
    func loginSuccessfull(withUser user: UserModel)
    
    func handleLoginErrors(error: Error)
}


// The class is responsible to validate the input
// parameters and consequently hit the login api
class LoginServiceHandler: LoginService {
    let delegate: LoginServiceDelegate
    
    init(delegate: LoginServiceDelegate) {
        self.delegate = delegate
    }
    
    func login(withUsername username: String?, password: String?) {
        let result = validate(userName: username ?? "", password: password ?? "")
        switch result {
        case .failure(let error):
            //handle error
            delegate.handleLoginErrors(error: error)
            return
        case .success(_):
            guard let username = username else {
                delegate.handleLoginErrors(error: LoginFormValidationError.invalidUsernameLength)
                return
            }
            doLogin(username: username, password: password)
            break
        }
    }
    
    func validate(userName username: String, password: String) -> Result<Bool> {
        guard username.characters.count >= 2 && username.characters.count <= 10 else {
            return Result.failure(LoginFormValidationError.invalidUsernameLength)
        }
        
        guard password.characters.count > 2 else {
            return Result.failure(LoginFormValidationError.invalidPasswordLength)
        }
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        _ = texttest.evaluate(with: password)
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        _ = texttest1.evaluate(with: password)
        
//        guard capitalresult && numberresult else {
//           // return Result.failure(LoginFormValidationError.invalidPasswordCharacters)
//        }
        
        return .success(true)
    }
    
    func doLogin(username: String?, password: String?){
        let clientId = Config.CLIENT_ID
        let secrete = Config.CLIENT_SECRET
        let credentialData = "\(clientId):\(secrete)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        var url:String = Config.AUTH_TOKEN_ENDPOINT + "?grant_type=password";
        url += "&client_id=" + clientId
        url += "&username=" + username!
        url += "&password=" + password!
        let headers:[String:String] = ["Content-Type": "application/x-www-form-urlencoded","Accept": "application/json", "Authorization": "Basic \(base64Credentials)"]
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            // Handle response to extract the OAuth Token
            if let error = response.result.error {
                self.delegate.handleLoginErrors(error: error)
                return
            }else {
                let responseValue  = JSON(response.result.value!)
                if(responseValue["error"] != JSON.null){
                    self.delegate.handleLoginErrors(error: LoginFormValidationError.invalidCredentials)
                }else {
                    let accessToken = responseValue["access_token"].stringValue
                    let refreshToken = responseValue["refresh_token"].stringValue
                    let userModel = UserModel(_userId: username!, _authToken: accessToken, _refreshToken: refreshToken)
                    self.delegate.loginSuccessfull(withUser: userModel)
                    
                }
            }
        }
    }
}
