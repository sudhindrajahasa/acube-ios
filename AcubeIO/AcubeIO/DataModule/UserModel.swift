//
//  UserModel.swift
//  AcubeIO
//
//  Created by Sudhindra on 06/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import CoreData

class UserModel {
    
    private var userid:String               = "";
    private var refreshtoken:String         = "";
    private var authtoken:String            = "";
    
    func getUserId() -> String {
        return self.userid;
    }
    
    func setUserId(_userId:String) -> Void {
        self.userid = _userId;
    }
    
    func getAuthToken() -> String {
        return self.authtoken;
    }
    
    func setAuthToken(_authToken:String) -> Void {
        self.authtoken = _authToken;
    }
    
    func getRefreshToken() -> String {
        return self.refreshtoken;
    }
    
    func setRefreshToken(_refreshToken:String) -> Void {
        self.refreshtoken = _refreshToken;
    }
    
    init(_userId:String , _authToken :String , _refreshToken : String){
        self.userid = _userId
        self.authtoken = _authToken
        self.refreshtoken = _refreshToken
    }
    
    func saveUser() -> Void {
        do {
            let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "userid == %@", self.userid)
            var recordFond : Bool = false
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            
            let fetchedResults = try context.fetch(fetchRequest)
            for item in fetchedResults {
                context.delete(item)
            }
            let oUser = NSManagedObject(entity: entity!, insertInto: context)
            oUser.setValue(self.userid, forKey: "userid")
            oUser.setValue(self.refreshtoken, forKey: "refreshtoken")
            oUser.setValue(self.authtoken, forKey: "authtoken")
            // Save the data to coredata
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
    }
    
    
    func getUserDetails() -> UserModel {
        var returnModel = self;
        do {
            let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "userid == %@", self.userid)
            var recordFond : Bool = false
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            
            let fetchedResults = try context.fetch(fetchRequest)
            for item in fetchedResults {
                returnModel.setAuthToken(_authToken: item.authtoken!)
                returnModel.setRefreshToken(_refreshToken: item.refreshtoken!)
                break;
            }
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
        return returnModel;
    } 
}
