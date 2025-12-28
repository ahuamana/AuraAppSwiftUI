//
//  DashboardViewModel.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import Foundation
import Combine

class DashboardViewModel : ObservableObject {
    @Published var devices: [DevicePresentationModel] = []
    @Published var heartRateValues: [HeartRatePoint] = []
    
    private var bluetoothManager: BluetoothApiService
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.bluetoothManager = BluetoothApiService()
        addObservers()
    }
    
    func addObservers() {
        
        //Handle scan devices
        bluetoothManager.$devices
            .map(mapAndSortDevices)
            .sink(receiveValue: { [weak self] devices in
                self?.devices = devices
                print("devices \(devices)")
            })
            .store(in: &cancellables)
        
        //Handle data for the chart
        bluetoothManager.$bpmValues
            .sink(receiveValue: { [weak self] bmpValues in
                self?.heartRateValues = bmpValues
                print("bmpValues: \(bmpValues)")
            })
            .store(in: &cancellables)
    }
    
    
    func connect(to device: DevicePresentationModel) {
        print("Clicked connect to \(device.name)")
        bluetoothManager.connect(devicePresentationModel: device)
    }
    
    private func mapAndSortDevices(_ devices: [BluetoothPresentationModel]) -> [DevicePresentationModel] {
      return devices.map { $0.toDevicePresentationModel() }
            .sorted { a, b in
                                let aUnknown = a.name.caseInsensitiveCompare("Unknown") == .orderedSame
                                let bUnknown = b.name.caseInsensitiveCompare("Unknown") == .orderedSame

                                if aUnknown != bUnknown { return !aUnknown } // Unknown last
                                return a.name.localizedCaseInsensitiveCompare(b.name) == .orderedAscending
                            }
    }
}
