//
//  UserProfileModel.swift
//  AcubeIO
//
//  Created by Sudhindra on 06/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import CoreData

class UserProfileModel {
    
    private var id:String               = "";
    private var userName:String         = "";
    private var firstName:String        = "";
    private var lastName:String         = "";
    private var profilePic:String       = "";
    private var email:String            = "";
    private var mobile:String           = "";
    private var gender:Int              = 0;
    private var password:String         = "";
    private var countryCode:String      = "";
    private var dob:String              = "";
    
    func getId() -> String {
        return self.id;
    }
    
    func setId(_id:String) -> Void {
        self.id = _id;
    }
    
    func getUsername() -> String {
        return self.userName;
    }
    
    func setUsername(_userName:String) -> Void {
        self.userName = _userName;
    }
    
    func getFirstName() -> String {
        return self.firstName;
    }
    
    func setFirstName(_firstName:String) -> Void {
        self.firstName = _firstName;
    }
    
    func getLastName() -> String {
        return self.lastName;
    }
    
    func setLastName(_lastName:String) -> Void {
        self.lastName = _lastName;
    }
    
    func getProfilePic() -> String {
        return self.profilePic;
    }
    
    func setProfilePic(_profilePic:String) -> Void {
        self.profilePic = _profilePic;
    }
    
    func getEmail() -> String {
        return self.email;
    }
    
    func setEmail(_email:String) -> Void {
        self.email = _email;
    }
    
    func getMobile() -> String {
        return self.mobile;
    }
    
    func setMobile(_mobile:String) -> Void {
        self.mobile = _mobile;
    }
    
    func getCountryCode() -> String {
        return self.countryCode;
    }
    
    func setCountryCode(_countryCode:String) -> Void {
        self.countryCode = _countryCode;
    }
    
    func getGender() -> Int {
        return self.gender;
    }
    
    func setGender(_gender:Int) -> Void {
        self.gender = _gender;
    }
    
    func getDob() -> String {
        return self.dob;
    }
    
    func setDob(_dob:String) -> Void {
        self.dob = _dob;
    }
    
    func getPassword() -> String {
        return self.password;
    }
    
    func setPassword(_password:String) -> Void {
        self.password = _password;
    }
    
    func saveUserProfile() -> Void {
        do {
            let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<UserProfile>(entityName: "UserProfile")
            fetchRequest.predicate = NSPredicate(format: "username == %@", self.userName)
            let entity = NSEntityDescription.entity(forEntityName: "UserProfile", in: context)
            
            let fetchedResults = try context.fetch(fetchRequest)
            for item in fetchedResults {
                context.delete(item)
            }
            let oUserProfile = NSManagedObject(entity: entity!, insertInto: context)
            oUserProfile.setValue(self.id, forKey: "id")
            oUserProfile.setValue(self.userName, forKey: "username")
            oUserProfile.setValue(self.firstName, forKey: "first_name")
            oUserProfile.setValue(self.lastName, forKey: "last_name")
            oUserProfile.setValue(self.profilePic, forKey: "profile_pic")
            oUserProfile.setValue(self.email, forKey: "email")
            oUserProfile.setValue(self.mobile, forKey: "mobile")
            oUserProfile.setValue(self.countryCode, forKey: "country_code")
            oUserProfile.setValue(self.gender, forKey: "gender")
            if(self.dob != ""){
                oUserProfile.setValue(self.dob, forKey: "dob")
            }
            //TODO  should we encrypt and store user password in DB?
            //oUserProfile.setValue(self.password, forKey: "password")
            // Save the data to coredata
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
    }
    
}
