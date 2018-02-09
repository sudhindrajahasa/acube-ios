//
//  OAuth2RequestHandler.swift
//  AcubeIO
//
//  Created by Sudhindra on 05/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import Foundation
import OAuthSwift


extension ViewController: OAuthWebViewControllerDelegate {
    #if os(iOS) || os(tvOS)
    
    func oauthWebViewControllerDidPresent() {
        
    }
    func oauthWebViewControllerDidDismiss() {
        
    }
    #endif
    
    func oauthWebViewControllerWillAppear() {
        
    }
    func oauthWebViewControllerDidAppear() {
        
    }
    func oauthWebViewControllerWillDisappear() {
        
    }
    func oauthWebViewControllerDidDisappear() {
        // Ensure all listeners are removed if presented web view close
        oauthswift?.cancel()
    }
}


extension ViewController {
    
    // MARK: - do authentification
    func doAuthService(service: String) {
        
        // Check parameters
        guard var parameters = services[service] else {
            showAlertView(title: "Miss configuration", message: "\(service) not configured")
            return
        }
        self.currentParameters = parameters
        
        // Ask to user by showing form from storyboards
        self.formData.data = nil
        Queue.main.async { [unowned self] in
            self.performSegue(withIdentifier: Storyboards.Main.FormSegue, sender: self)
            // see prepare for segue
        }
        // Wait for result
        guard let data = formData.waitData() else {
            // Cancel
            return
        }
        
        parameters["consumerKey"] = data.key
        parameters["consumerSecret"] = data.secret
        
        if Services.parametersEmpty(parameters) { // no value to set
            let message = "\(service) seems to have not weel configured. \nPlease fill consumer key and secret into configuration file \(self.confPath)"
            print(message)
            Queue.main.async { [unowned self] in
                self.showAlertView(title: "Key and secret must not be empty", message: message)
            }
        }
        
        parameters["name"] = service
        
        switch service {
       case "SoundCloud":
            doOAuthSoundCloud(parameters)
        default:
            print("\(service) not implemented")
        }
    }
    
    
    // MARK: SoundCloud
    func doOAuthSoundCloud(_ serviceParameters: [String:String]) {
        let oauthswift = OAuth2Swift(
            consumerKey:    serviceParameters["consumerKey"]!,
            consumerSecret: serviceParameters["consumerSecret"]!,
            authorizeUrl:   "https://soundcloud.com/connect",
            accessTokenUrl: "https://api.soundcloud.com/oauth2/token",
            responseType:   "code"
        )
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = getURLHandler()
        let state = generateState(withLength: 20)
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "https://oauthswift.herokuapp.com/callback/soundcloud")!, scope: "", state: state,
            success: { credential, response, parameters in
                self.showTokenAlert(name: serviceParameters["name"], credential: credential)
                self.testSoundCloud(oauthswift,credential.oauthToken)
        },
            failure: { error in
                print(error.description)
        }
        )
    }
    
    func testSoundCloud(_ oauthswift: OAuth2Swift, _ oauthToken: String) {
        let _ = oauthswift.client.get(
            "https://api.soundcloud.com/me?oauth_token=\(oauthToken)",
            success: { data, response in
                let dataString = String(data: data, encoding: String.Encoding.utf8)
                print(dataString)
        }, failure: { error in
            print(error)
        }
        )
    }
}
