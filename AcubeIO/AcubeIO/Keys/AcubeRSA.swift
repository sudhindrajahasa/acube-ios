//
//  AcubeRSA.swift
//  AcubeIO
//
//  Created by Uday Patil on 06/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import Foundation
import SwiftyRSA

class AcubeRsa {
    
    func encryptString(_inputString : String) ->String{
        var encryptedString : String = ""
        do{
            // encryption
            let publicKey = try PublicKey(pemNamed: "public")
            let textToEncrypt = try ClearMessage(string: _inputString, using: .utf8)
            let encrypted = try textToEncrypt.encrypted(with: publicKey, padding: .PKCS1)
            encryptedString = encrypted.base64String
            
        }catch{
            print("caught: \(error)")
        }
        return encryptedString
    }
    
    func decryptString(_inputString : String) ->String{
        var decryptedString : String = ""
        do{
            // decryption
            let privateKey = try PrivateKey(pemNamed: "private")
            let encryptedData = try EncryptedMessage(base64Encoded: _inputString)
            let decryptedText = try encryptedData.decrypted(with: privateKey, padding: .PKCS1)
            decryptedString = try decryptedText.string(encoding: .utf8)
            
        }catch{
            print("caught: \(error)")
        }
        return decryptedString
    }
}
