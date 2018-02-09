//
//  UserService.swift
//  AcubeIO
//
//  Created by Sudhindra on 07/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol UserProfileService {
    var delegate: UserProfileServiceDelegate { get }
    func getUserProfile(withUser userModel: UserModel)
}

// Delegate for the UserProfileService
protocol UserProfileServiceDelegate {
    func onSuccessfull(withUser userProfile: UserProfileModel)
    func handleUserProfileErrors(error: Error)
}

// The class is responsible to validate the input
// parameters and consequently hit the login api
class UserProfileServiceHandler: UserProfileService {
    
    
    let delegate: UserProfileServiceDelegate
    
    init(delegate: UserProfileServiceDelegate) {
        self.delegate = delegate
    }
    func getUserProfile(withUser userModel: UserModel) {
        if(userModel.getAuthToken() != ""){
            let oAcubeRSA = AcubeRsa();
            let accessToken = oAcubeRSA.decryptString(_inputString: userModel.getAuthToken());
            
            let url:String = Config.USER_PROFILE_ENDPOINT
            let headers:[String:String] = ["Accept": "application/json", "Authorization": "Bearer \(accessToken)"]
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let error = response.result.error {
                    self.delegate.handleUserProfileErrors(error: UserProfileValidationError.invalidAccessToken)
                    return
                }else {
                    
                    let responseValue  = JSON(response.result.value!)
                    if(responseValue != JSON.null){
                        let userProfile  = UserProfileModel()
                        userProfile.setId(_id: responseValue["id"].stringValue)
                        userProfile.setUsername(_userName: responseValue["username"].stringValue)
                        userProfile.setFirstName(_firstName: responseValue["first_name"].stringValue)
                        userProfile.setLastName(_lastName: responseValue["last_name"].stringValue)
                        userProfile.setProfilePic(_profilePic: responseValue["profile_pic"].stringValue)
                        userProfile.setEmail(_email: responseValue["email"].stringValue)
                        userProfile.setGender(_gender: responseValue["gender"].intValue)
                        userProfile.setMobile(_mobile: responseValue["mobile"].stringValue)
                        userProfile.setCountryCode(_countryCode: responseValue["country_code"].stringValue)
                        if(responseValue["dob"].stringValue != ""){
                            userProfile.setDob(_dob: responseValue["dob"].stringValue)
                        }
                        userProfile.setPassword(_password: responseValue["country_code"].stringValue)
                        self.delegate.onSuccessfull(withUser: userProfile)                        
                      
                    }
                }
            }
        }
    }
    
    
}
