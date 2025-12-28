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
        BluetoothPresentationModel(id: UUID().uuidString, name: "Sniper Smartwatch"),
        BluetoothPresentationModel(id: UUID().uuidString, name: "Headphone M5"),
        BluetoothPresentationModel(id: UUID().uuidString, name: "Muze Band"),
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
    
}
