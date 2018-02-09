 //
 //  Jahasa Technology Ltd all rights reserved
 //  AcubeIO
 //  HomeViewController
 //  Created by Sudhindra on 06/02/18.
 //  Copyright © 2018 Jahasa. All rights reserved.
 //

import UIKit
import CoreBluetooth

class HomeViewController: HeaderViewController  {
    let bleUUID = CBUUID.init(string: Config.ACUBE_BLEID);
    var scanTimer: Timer!
    var seconds = 0 //variable will be set to 0 everytime scan is triggerd.
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    // Page variables
    var manager: CBCentralManager!
    var connectedPeripheral: CBPeripheral!
    var bluetoothDeviceList = [BluetoothDevices]()
    var blutoothPoweredOn = false
    
    // storyboard connections
    @IBOutlet weak var bluetoothTableView: UITableView!
    @IBOutlet weak var btnScan: UIButton!
    @IBAction func btnLogoutClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginView: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginPage") as! LoginViewController
        //TODO  remove user entiry from database
        UIApplication.shared.keyWindow?.rootViewController = loginView
    }
    
    @IBAction func scanBtnClick(_ sender: Any) {
        self.runTimer();
        self.btnScan.isEnabled = false;
        bluetoothDeviceList.removeAll()
        bluetoothTableView.reloadData()
        blutoothPoweredOn = false
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothTableView.delegate = self
        bluetoothTableView.dataSource = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        seconds = 0;
        self.manager.stopScan();
        self.scanTimer.invalidate();
        self.seconds = 0;
        self.btnScan.isEnabled = true;
        self.btnScan.setTitle("SCAN", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func connectToDevice(_sequence: Int){
        if(_sequence <=  bluetoothDeviceList.count){
            manager.connect(bluetoothDeviceList[_sequence].peripheralData, options: nil)
        }
    }
    
    func runTimer() {
        scanTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1
        if(self.seconds > 15){
            self.manager.stopScan()
            self.scanTimer.invalidate();
            self.seconds = 0;
            self.btnScan.isEnabled = true;
            self.btnScan.setTitle("SCAN", for: .normal)
        }
    }
}

extension HomeViewController : CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn{
            self.blutoothPoweredOn = true
            manager.scanForPeripherals(withServices: nil, options: nil)
        }else if central.state == .poweredOff{
            let popupView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "acubeAlerts") as! PopUpViewController;
            self.addChildViewController(popupView);
            popupView.view.frame = self.view.frame;
            self.view.addSubview(popupView.view);
            popupView.setHeading(_headingText: "Error!")
            popupView.setMessage(_messageText: "Bluetooth is turned off")
            popupView.didMove(toParentViewController: self)
            manager.stopScan()
            print("Powered Off")
        }else if central.state == .unauthorized{
            print("unauthorized")
            manager.stopScan()
        }else if central.state == .unsupported{
            print("Unspported")
            manager.stopScan()
        }else if central.state == .unknown{
            print("unknown")
            manager.stopScan()
        }
       
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        performSegue(withIdentifier: "showBluetoothCommunication", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showBluetoothCommunication"){
            var destinationController = segue.destination as! BluetoothCommunicationViewController
            destinationController.setConnectedPeripheral(_connectedPeripheral: connectedPeripheral)
            destinationController.setCBCentralManager(_cbCentralManager: manager)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        btnScan.setTitle("Scanning", for: .normal)
        var tempDevice: BluetoothDevices;
        print("Peripheral Name: \(String(describing: peripheral.name))!")
        if(peripheral.name != nil){
            if(advertisementData != nil)
            {
                if(advertisementData["kCBAdvDataServiceUUIDs"] != nil){
                    let advertisementDataArray = (advertisementData["kCBAdvDataServiceUUIDs"] as! NSArray)
                    if(advertisementDataArray.count > 0){
                        if(String(describing: advertisementDataArray[0]) == String(describing: self.bleUUID)){
                            if(bluetoothDeviceList.contains(where: { $0.Name == peripheral.name!} )){
                            }else {
                                tempDevice = BluetoothDevices(Name: peripheral.name!,MacAddress: peripheral.identifier.description, peripheralData: peripheral);
                                bluetoothDeviceList.append(tempDevice)
                                bluetoothTableView.reloadData();
                            }
                        }
                    }
                }
            }
        }
    }
}

extension HomeViewController : UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

}

extension HomeViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothDeviceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell “bluetoothCell”
        let cell: BluetoothDeviceTableViewCell = bluetoothTableView.dequeueReusableCell(withIdentifier: "bluetoothCell") as! BluetoothDeviceTableViewCell
        cell.labelDeviceName.text = bluetoothDeviceList[indexPath.row].Name
        cell.labelMacID.text = bluetoothDeviceList[indexPath.row].MacAddress
        cell.setSequece(_sequence: indexPath.row)
        cell.setParentViewController(_homeController: self)
        return cell;
    }
}
