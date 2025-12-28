//
//  DashboardView.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject var vm : DashboardViewModel = DashboardViewModel()
    
    var body: some View {
        ZStack {
            
            ScrollView(showsIndicators: false) {
                VStack {
                    topSectionDashboardView
                    
                    myDeviceSection
                    
                    otherDeviceSection
                    
                    Spacer(minLength: 0)
                }
            }
            
            
        }
        .background(background)

    }
}

extension DashboardView {
    private var background : some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [.blueAccent, .blueDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            .offset(x: 0, y: 300)
            .frame(width: 918, height: 918)
            .ignoresSafeArea(edges: .all)

        
    }
    
    private var topSectionDashboardView: some View {
        HStack {
            Image("profile-photo")
            VStack(alignment: .leading) {
                Text("Hana Almahera")
                HStack() {
                    Image(systemName: "map.fill")
                    Text("Washington D.C")
                }
            }
            Spacer()
            Image(systemName: "magnifyingglass")
                .padding(.trailing, 8)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 40)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 12)
        )
        .padding()
        
    }
    
    private var myDeviceSection : some View {
        VStack(alignment: .leading,spacing: 15) {
            HStack {
                Text("My Device")
                    .bold()
                Spacer()
            }
            
            HStack {
                Button(action: {
                    
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                        Text("Add Device")
                            .foregroundColor(.white)
                        
                            
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .padding(.horizontal, 15)
                    .background(RoundedRectangle(cornerRadius: 10))
                })
                
                NavigationLink(destination: {
                    FindDeviceView()
                }, label: {
                    Text("Find Device")
                        .bold()
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.blue)
                                       
                        )
                })
                
            }
            
            Divider()
            
            ForEach(vm.devices.filter { $0.isConnected }) { device in
                
                NavigationLink(destination: {
                    DeviceDetail(points: DeveloperMock.shared.points)
                }, label: {
                    DeviceView(
                        device: device,
                        iconNameDevice: device.icon,
                        iconNameOptions: "gearshape",
                        colorOptions: Color.blue,
                        colorDevice: Color.purple
                    )
                })
                
            }
            
            
            
            
                
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 12)
        )
        .padding()
    }
    
    private var otherDeviceSection : some View {
        VStack(alignment: .leading,spacing: 15) {
            HStack {
                Text("Other Device")
                    .bold()
                Spacer()
            }
            
            ForEach(vm.devices.filter {!$0.isConnected }) { device in
                Button(action: {
                    vm.connect(to: device)
                }, label: {
                    DeviceView(
                        device:device,
                        iconNameDevice: device.icon,
                        iconNameOptions: "ellipsis",
                        colorOptions: Color.gray,
                    )
                })
                
            }
            
                
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 12)
        )
        .padding()
    }
}

#Preview {
    DashboardView()
    
}
