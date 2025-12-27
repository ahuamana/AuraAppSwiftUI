//
//  BluetoothApiService.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import Foundation
import Combine
import CoreBluetooth

class BluetoothApiService : NSObject, CBCentralManagerDelegate {
    
    private var centralManager: CBCentralManager?

    @Published var isPoweredOn: Bool = false
    
    @Published var isScanning: Bool = false
    
    @Published var devices: [BluetoothPresentationModel] = []
    
    @Published var selectedDevice: BluetoothPresentationModel?
    
    override init() {
        super.init( )
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    
}

extension BluetoothApiService {
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let model = BluetoothPresentationModel.fromCBPheriphericalDevice(peripheral)
        if !devices.contains(where: { $0.id == model.id}) {
            self.devices.append(model)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
}
