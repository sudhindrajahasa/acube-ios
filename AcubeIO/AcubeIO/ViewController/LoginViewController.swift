 //
 //  Jahasa Technology Ltd all rights reserved
 //  AcubeIO
 //  LoginViewController
 //  Created by Sudhindra on 05/02/18.
 //  Copyright © 2018 Jahasa. All rights reserved.
 //

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userNameImage: UIImageView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    
    var loginService: LoginService!
    var userProfileService: UserProfileService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loginService = LoginServiceHandler(delegate: self)
        userProfileService = UserProfileServiceHandler(delegate: self)
    }
    
    /**
     * Initializes the view, by refrencing all the required widgets and
     * actions to be taken after the view is rendered.
     *
     **/
    func initView(){
        // design of UI
        let userNamePaddingView  = UIView(frame: CGRect(x:0,y:0,width:35,height:self.userNameTxt.frame.height))
        self.userNameTxt.leftView = userNamePaddingView
        self.userNameTxt.leftViewMode = UITextFieldViewMode.always
        
        let passwordPaddingView  = UIView(frame: CGRect(x:0,y:0,width:35,height:self.userNameTxt.frame.height))
        self.passwordTxt.leftView = passwordPaddingView
        self.passwordTxt.leftViewMode = UITextFieldViewMode.always
        
        let backgroundImage = UIImage(named:"loginBackground.jpg")
        self.loginView.layer.contents = backgroundImage?.cgImage
        
        userNameImage.image = userNameImage.image!.withRenderingMode(.alwaysTemplate)
        userNameImage.tintColor = UIColor.white
        
        passwordImage.image = passwordImage.image!.withRenderingMode(.alwaysTemplate)
        passwordImage.tintColor = UIColor.white
  
    }
    
    /**
     * Hide the keyboard after editing
     *
     **/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
    }

    func clearFields(){
        userNameTxt.text = "";
        passwordTxt.text = "";
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Login button click handler,
     * validates the credentials logins if valid else shows the alert message
     *
     **/
    @IBAction func loginBtn(_ sender: Any) {
        let userName = self.userNameTxt.text?.trimmingCharacters(in: .whitespaces)
        let password = self.passwordTxt.text?.trimmingCharacters(in: .whitespaces)
        var parameters = [String : String]()
        parameters["username"] = userName
        parameters["password"] = password
        ProgressViewUtils.shared.showProgressView(self.view)
        loginService.login(withUsername: userName, password: password)
    }
    
     /*
     savePersonAuthToken function will take username, authtoken and refresh token as parameters
     Auth token and refresh tokens will be encoded using RSA encryption and stored in the Core data in User Entity
     */
    func savePersonAuthToken(_userModel : UserModel) {
        let oAcubeRSA = AcubeRsa();
        let encryptedAuthToken = oAcubeRSA.encryptString(_inputString :_userModel.getAuthToken());
        let encryptedRefreshToken = oAcubeRSA.encryptString(_inputString :_userModel.getRefreshToken());
        
        let oUser  = UserModel(_userId: _userModel.getUserId(), _authToken: encryptedAuthToken, _refreshToken: encryptedRefreshToken );
        oUser.saveUser()
        userProfileService.getUserProfile(withUser: oUser);
    }
}

extension LoginViewController: LoginServiceDelegate {
    func loginSuccessfull(withUser user: UserModel) {
       self.savePersonAuthToken(_userModel: user)
    }
    
    func handleLoginErrors(error: Error) {
        ProgressViewUtils.shared.hideProgressView()
        let popupView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "acubeAlerts") as! PopUpViewController;
        self.addChildViewController(popupView);
        popupView.view.frame = self.view.frame;
        self.view.addSubview(popupView.view);
        popupView.setHeading(_headingText: "ERROR!")
        popupView.setMessage(_messageText: error.localizedDescription)
        popupView.didMove(toParentViewController: self);
    }
}

extension LoginViewController: UserProfileServiceDelegate {
    
    func onSuccessfull(withUser userProfile: UserProfileModel) {
        userProfile.saveUserProfile();
       
        ProgressViewUtils.shared.hideProgressView()
         self.performSegue(withIdentifier: "showNavigationController", sender: nil)
    }
    
    func handleUserProfileErrors(error: Error) {
        ProgressViewUtils.shared.hideProgressView()        
        let popupView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "acubeAlerts") as! PopUpViewController;
        self.addChildViewController(popupView);
        popupView.view.frame = self.view.frame;
        self.view.addSubview(popupView.view);
        popupView.setHeading(_headingText: "ERROR!")
        popupView.setMessage(_messageText: error.localizedDescription)
        popupView.didMove(toParentViewController: self);
    }
}
