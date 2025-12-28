//
//  DeveloperMock.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import Foundation

extension DeveloperMock {
     static var shared: DeveloperMock = .instance
}

class DeveloperMock {
    private static let instance: DeveloperMock = DeveloperMock()
    
    private init() {}
    
    
    let bluetoothDevices : [BluetoothPresentationModel] = [
        BluetoothPresentationModel(id: UUID().uuidString, name: "Sniper Smartwatch", connected: false),
        BluetoothPresentationModel(id: UUID().uuidString, name: "Headphone M5", connected: false),
        BluetoothPresentationModel(id: UUID().uuidString, name: "Muze Band", connected: false),
    ]
    
    let devices : [DevicePresentationModel] = [
        DevicePresentationModel(id: UUID().uuidString, name: "Neurosmart watch", icon: "applewatch.side.right", isConnected: true),
        //DevicePresentationModel(id: UUID().uuidString, name: "Sniper Smartwatch", icon: "applewatch.side.right", isConnected: true),
        ]
    
    
    let devicesNonConnected : [DevicePresentationModel] = [
        DevicePresentationModel(id: UUID().uuidString, name: "Sniper Smartwatch", icon: "applewatch.side.right", isConnected: false),
        DevicePresentationModel(id: UUID().uuidString, name: "Headphone M5", icon: "headphones", isConnected: false),
        DevicePresentationModel(id: UUID().uuidString, name: "Muze Band", icon: "head.profile.arrow.forward.and.visionpro", isConnected: false),
        ]
    
    let points: [HeartRatePoint] = (0..<60).map { i in
        // 1. Calculate time: Go backwards 'i' seconds from now
        // i = 0 -> Now
        // i = 59 -> 59 seconds ago
        let time = Date().addingTimeInterval(Double(-i))
        
        // MATH MAGIC: Create a natural "wave" pattern
        // Base HR is 75.
        // The sine wave (+/- 10) simulates breathing/variance.
        // The random (+/- 2) adds small noise so it looks organic.
        let wave = sin(Double(i) * 0.2) * 10
        let noise = Double.random(in: -2...2)
        let value = Int(75 + wave + noise)
        
        return HeartRatePoint(date: time, value: value)
    }.reversed()
    
}
