//
//  AcubeBLE.swift
//  AcubeIO
//
//  Created by Sudhindra on 07/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import Foundation
import CoreBluetooth


class AcubeBLE {
    
    private static var _aubeBLE:AcubeBLE = AcubeBLE();
    
    static func getAcubeBLE() -> AcubeBLE {
        return _aubeBLE;
    }
    var manager: CBCentralManager!
    var peripheral: CBPeripheral!
    
    init() {
    }
}
