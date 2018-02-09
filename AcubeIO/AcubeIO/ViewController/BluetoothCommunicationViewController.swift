//
//  BluetoothCommunicationViewController.swift
//  AcubeIO
//
//  Created by Sudhindra on 07/02/18.
//  Copyright © 2018 Jahasa. All rights reserved.
//

import UIKit
import  CoreBluetooth

class BluetoothCommunicationViewController: HeaderViewController {
    let bleUUID = CBUUID.init(string: Config.ACUBE_BLEID);
    let writeBLEID = CBUUID.init(string: Config.ACUBE_WRITEBLEID)
    var manager: CBCentralManager!
    
    var writeValue = ""
    
    var connectedPeripheral : CBPeripheral!
    func setConnectedPeripheral (_connectedPeripheral : CBPeripheral){
        connectedPeripheral = _connectedPeripheral
    }
    
    func setCBCentralManager (_cbCentralManager : CBCentralManager){
        manager = _cbCentralManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         connectedPeripheral.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSenSuccessAction(_ sender: Any) {
        writeValue = "SUCCESS";
        if(connectedPeripheral != nil){
            connectedPeripheral.discoverServices(nil);
        }
    }
    
    @IBAction func btnSendFailureAction(_ sender: Any) {
        writeValue = "FAILURE";
        if(connectedPeripheral != nil){
            connectedPeripheral.discoverServices(nil);
        }
    }
}

extension BluetoothCommunicationViewController : CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }

        guard let services = peripheral.services else {
            return
        }
        //We need to discover the all characteristic
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        print("Discovered Services: \(services)")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }

        guard let characteristics = service.characteristics else {
            return
        }

        print("Found \(characteristics.count) characteristics!")

        if(service.uuid == self.bleUUID){
            if(characteristics.count>0){
                for characteristic in characteristics {
                    if( characteristic.uuid == self.writeBLEID) {
                        peripheral.writeValue( writeValue.data(using: .utf8)!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    }
                }
            }
        }
    }

    private func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        print("Data \(String(describing: characteristic.value)) ")
        self.manager.cancelPeripheralConnection(peripheral)
    }

    func peripheral(_ peripheral: CBPeripheral,didWriteValueFor characteristic: CBCharacteristic,error: Error?){

        let popupView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "acubeAlerts") as! PopUpViewController;
        self.addChildViewController(popupView);
        popupView.view.frame = self.view.frame;
        self.view.addSubview(popupView.view);
        popupView.setHeading(_headingText: "Success!")
        popupView.setMessage(_messageText: "Found \(characteristic.uuid) characteristics Error: \(String(describing: error))")
        popupView.didMove(toParentViewController: self)
        self.manager.cancelPeripheralConnection(peripheral)
    }
}

