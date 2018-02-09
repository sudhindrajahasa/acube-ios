//
//  PoupViewController.swift
//  AcubeIO
//
//  Created by Sudhindra on 07/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//
import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblMessageContents: UILabel!    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnClose: UIButton!
    
    var requestFromPage : Int = 0;
    
    public func setRequestFrom(_pageNo : Int){
        requestFromPage = _pageNo
    }
    
    @IBAction func btnClose_TouchUpInside(_ sender: Any) {
        self.view.removeFromSuperview();
    }
    
    public func setHeading(_headingText : String){
        lblHeading.text = _headingText;
    }
    
    public func setMessage(_messageText : String){
        lblMessageContents.text = _messageText;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8);
        self.adjustViewAligments();
    }
    
    private func adjustViewAligments(){
        alertView.layer.masksToBounds = true;
        alertView.layer.cornerRadius = 12;        
        btnClose.layer.masksToBounds = true;
        btnClose.layer.cornerRadius = 5;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
