//
//  BluetoothConstants.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 28/12/25.
//

import Foundation
import CoreBluetooth

struct BluetoothConstants {
    
    // MARK: - Services (The "Rooms")
    struct Service {
        //Heart rate service (Standard)
        static let heartRate = CBUUID(string: "180D")
        
        //Device Information (Manufacturer, Model, Serial #)
        static let deviceInformation = CBUUID(string: "180A")
        
        // Baterry Service (Battery Level)
        static let battery = CBUUID(string: "180F")
        
        //Environmental Sensing (Temperature, humidity - rarely used in weareable
        static let environmentalSensing = CBUUID(string: "181A")
    }
    
    // MARK: - Characteristics (The "Data")
    struct Characteristic {
        // --- Heart Rate ---
        // The Live Data (Notify)
        static let heartRateMeasurement = CBUUID(string: "2A37")
        // Where is the sensor? Wrist? Chest? (Read)
        static let bodySensorLocation = CBUUID(string: "2A38")
        
        // --- Device Info ---
        static let manufacturerName = CBUUID(string: "2A29")
        static let modelNumber = CBUUID(string: "2A24")
        static let serialNumber = CBUUID(string: "2A25")
        
        // --- Battery ---
        static let batteryLevel = CBUUID(string: "2A19")
        
    }
}
