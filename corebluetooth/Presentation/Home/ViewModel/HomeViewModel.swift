//
//  HomeViewModel.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import Foundation
import Combine

class BluetoothViewModel :  ObservableObject {
    
    @Published var devices: [DevicePresentationModel] = []
    
    private var bluetoothManager: BluetoothApiService
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.bluetoothManager = BluetoothApiService()
        addObservers()
    }
    
    func addObservers() {
        
        bluetoothManager.$devices
            .map { devices in
                devices.map { $0.toDevicePresentationModelNotConnected() }
            }
            .sink(receiveValue: { [weak self] devices in
                self?.devices = devices
            })
            .store(in: &cancellables)
    }
    
}


