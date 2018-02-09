//
//  BluetoothDeviceTableViewCell.swift
//  AcubeIO
//
//  Created by Sudhindra on 07/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothDeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelMacID: UILabel!
    @IBOutlet weak var labelDeviceName: UILabel!
    
    var parentViewController = HomeViewController()
    var deviceSequence : Int = 0
    
    func setParentViewController (_homeController : HomeViewController){
        self.parentViewController = _homeController;
    }
    
    func setSequece (_sequence : Int){
        self.deviceSequence = _sequence;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.parentViewController != nil){
            self.parentViewController.connectToDevice(_sequence: self.deviceSequence)
            
        }
    }
}
