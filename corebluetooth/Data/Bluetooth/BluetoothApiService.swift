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
    private var perphericals: [CBPeripheral] = []

    @Published var devices: [BluetoothPresentationModel] = []
    
    
    override init() {
        super.init( )
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    //MARK: Step 2
    func connect(devicePresentationModel: DevicePresentationModel) {
        
        //After connect stop to save battery
        centralManager?.stopScan( )
        
        //1. Find  peripherical
        let peripheralToConnect = findPeripherical(with: devicePresentationModel)
        
        //2. Validate if we found it
        guard let peripheralToConnect = peripheralToConnect else {
            return
        }
        
        //3. Connect with the peripherical
        centralManager?.connect(peripheralToConnect, options: nil)
        
    }
    
    private func findPeripherical(with device: DevicePresentationModel) -> CBPeripheral? {
        guard let peripherical = perphericals.first(where: { $0.identifier.uuidString == device.id }) else {
            print("Peripherical not found")
            return nil
        }
        return peripherical
    }
    
}

extension BluetoothApiService {
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //MARK: 1. Transform the peripherica to a presentation model then save it
        let model = BluetoothPresentationModel.fromCBPheriphericalDevice(peripheral)
        if !devices.contains(where: { $0.id == model.id}) {
            
            //Also, save peripherical with the CBPerpherical, This is a requirement because to connect we need the same object
            self.perphericals.append(peripheral) // Save the object
            self.devices.append(model)           // Save the UI model
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected successfully to: \(peripheral.name ?? "No Name")")
        
        // A. Set the delegate so the Peripheral can talk back to us
        peripheral.delegate = self
        
        // Passing nil means "Give me everything" (Battery, Heart Rate, etc.)
        peripheral.discoverServices(nil)
    }
}

extension BluetoothApiService: CBPeripheralDelegate {
    
    // This is called when peripheral.discoverServices(nil) finishes
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        
        if let error = error {
                    print("Error discovering services: \(error.localizedDescription)")
                    return
        }
        
        guard let services = peripheral.services else {
            print("No services discovered.")
            return
        }
        
        print("Discovered services: \(services)")
    }
    
    // This is called when peripheral.discoverCharacteristics(nil, for: service) finishes
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        
        guard let characteristics = service.characteristics else {
            print("No characteristics discovered.")
            return
        }
        
        for characteristic in characteristics {
            print("Found characteristic: \(characteristic.uuid)")
            
            // TODO:  read data immediately:
            // TODO: peripheral.readValue(for: characteristic)
            
            // TODO: To get live updates (notifications):
            // TODO: peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        
        if let error = error {
                print("Data transfer error: \(error)")
                return
        }
        
        // 1. Get the raw bytes
        guard let data = characteristic.value else {
            print("No data received.")
            return
        }
        
        
        // 2. TODO: Identify which characteristic sent this data
            if characteristic.uuid.uuidString == "YOUR-SPECIFIC-UUID-HERE" {
                
                // 3. Convert data to something useful (String, Int, Float)
                // Example: Converting to String
                if let stringValue = String(data: data, encoding: .utf8) {
                    print("New Value: \(stringValue)")
                }
                
                // Example: Converting to Byte Array (common for hardware)
                let bytes = [UInt8](data)
                print("Raw Bytes: \(bytes)")
            }
        
        
    }
}


