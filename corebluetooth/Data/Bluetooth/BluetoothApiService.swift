//
//  BluetoothApiService.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import Foundation
import Combine
import CoreBluetooth

class BluetoothApiService : NSObject {
    
    private var centralManager: CBCentralManager?
    private var perphericals: [CBPeripheral] = []

    @Published var devices: [BluetoothPresentationModel] = []
    @Published var bpmValues: [HeartRatePoint] = []
    
    
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

extension BluetoothApiService : CBCentralManagerDelegate {
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //MARK: 1. Transform the peripherica to a presentation model then save it
        let model = BluetoothPresentationModel.fromCBPheriphericalDeviceToNewDevice(peripheral)
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
        
        // 1. Find the index of this device in your array
        if let index = devices.firstIndex(where: { $0.id == peripheral.identifier.uuidString }) {
            
            // 2. Create a copy of the model with isConnected = true
            var updatedDevice = devices[index]
            updatedDevice.connected = true
            print("Updating device: \(updatedDevice)")
            // 3. Replace the old item with the new one to trigger the UI update
            devices[index] = updatedDevice
        }
        
        // A. Set the delegate so the Peripheral can talk back to us
        peripheral.delegate = self
        
        // Passing nil means "Give me everything" (Battery, Heart Rate, etc.) - all services
        peripheral.discoverServices(nil)
    }
}

extension BluetoothApiService: CBPeripheralDelegate {
    
    // Call after discovering services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        
        if let error = error {
                    print("Error discovering services: \(error.localizedDescription)")
                    return
        }
        
        guard let services = peripheral.services else {
            print("No services discovered.")
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
    }
    
    
    
    // This is called after when peripheral.discoverCharacteristics(nil, for: service) finishes
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
            
            // 1. Heart Rate Measurement (NOTIFY)
            if characteristic.uuid ==  BluetoothConstants.Characteristic.heartRateMeasurement {
                print("Subscribing to Heart Rate Measurement...")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        
        if let error = error {
                print("Data transfer error: \(error)")
                return
        }
        
        
        // 2. TODO: Identify which characteristic sent this data
        if characteristic.uuid == BluetoothConstants.Characteristic.heartRateMeasurement {
            guard let data = characteristic.value else {
                print("No data received.")
                return
            }
             
            parsingLogicStart(data: data)
        
        }
    }
    
    func parsingLogicStart(data: Data) {
        // --- PARSING LOGIC START ---
                
        // Byte 0 is the "Flags" byte. It tells us how to read the rest.
        let firstByte = data[0]
        
        // Check Bit 0 of the first byte.
        // If it is '0', the Heart Rate is 8-bit (Standard).
        // If it is '1', the Heart Rate is 16-bit (High Precision).
        let isUInt16 = (firstByte & 0x01) != 0
        
        var bpm: Int = 0
        
        if isUInt16 {
            // 16-bit: Read 2 bytes (Index 1 and 2)
            // Example: Elephant or Hummingbird heart rate
            if data.count >= 3 {
                 bpm = Int(data[1]) + (Int(data[2]) << 8)
            }
        } else {
            // 8-bit: Read 1 byte (Index 1)
            // Example: Human heart rate (0-255 bpm)
            if data.count >= 2 {
                bpm = Int(data[1])
            }
        }
        
        // --- PARSING LOGIC END ---
        
        print("❤️ Live Heart Rate: \(bpm) BPM")
        
        // 4. Send this value to your Dashboard/Chart
        // Use the closure we defined earlier
        DispatchQueue.main.async {
            self.bpmValues.append(HeartRatePoint(date: Date(), value: bpm))
            
            if self.bpmValues.count > 50 {
                self.bpmValues.removeFirst()
            }
        }
    }
}


