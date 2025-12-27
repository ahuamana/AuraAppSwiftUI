//
//  ContentView.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import SwiftUI
import CoreBluetooth



struct ContentView: View {
    
    @StateObject private var vm = BluetoothViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                    List(vm.devices) { peripheral in
                        NavigationLink ( destination: {
                            Text(peripheral.name)
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(peripheral.name)
                                Text(peripheral.id)
                            }
                        })
                        
                    }
                    .listStyle(.plain)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle(Text("Bluetooth Devices"))
        .padding()
    }
}

#Preview {
    ContentView()
}
