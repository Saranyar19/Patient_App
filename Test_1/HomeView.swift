//
//  HomeView.swift
//  Test_1
//
//  Created by Jegathiswaran Skyraan on 30/08/24.
//

import SwiftUI
import UIKit
import GooglePlaces
import GoogleMaps
struct HomeView: View {
    @State var arrPatientList : [Patientdetails] = []
    @State var showAddUser : Bool = false
    var body: some View {
        ZStack{
            VStack{
                Section(content: {
                    HStack{
                        Text("Patient list")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            showAddUser = true
                        }, label: {
                            Text(Image(systemName: "plus.circle"))
                                .bold()
                                .font(.system(size: 25))
                        })
                    }
                    .padding(.horizontal)
                    
                })
                
                .headerProminence(.increased)
                
                if arrPatientList.count > 0 {
                    List {
                        ForEach(arrPatientList,id: \.patientID){
                            patient in
                            ListRowView(patient: patient)
                        }
                        
                    }
                    .listStyle(.insetGrouped)
                    
                    
                }else{
                    VStack(alignment:.center){
                        Spacer()
                        Text("No entry yet!")
                            .bold()
                        Spacer()
                    }
                }
                
            }
            if showAddUser{
                Color.black.opacity(0.5)
                AddPatientDetails(showAddUser: $showAddUser, ReloadCD: {
                    self.arrPatientList = CoreDataManager.shared.getPatientDetails()
                })
                .frame(height: UIScreen.main.bounds.height / 2)
                .padding(.horizontal)
            }

        }
        .onAppear(){
            self.arrPatientList = CoreDataManager.shared.getPatientDetails()
        }

    }
}

#Preview {
    HomeView()
}



//struct MapViewControllerBridge: UIViewControllerRepresentable {
//
//  func makeUIViewController(context: Context) -> MapViewController {
//    // Replace this line
//    return MapViewController()
//  }
//
//  func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
//  }
//}

class MapViewController: UIViewController {
    
    let map =  GMSMapView(frame: .zero)
    
    var isAnimating: Bool = false
    
    override func loadView() {
        super.loadView()
        self.view = map
    }
    
}

struct MapViewControllerBridge: UIViewControllerRepresentable {
    
    var GetLogation : (CLLocationCoordinate2D) -> Void
    
    func makeUIViewController(context: Context) -> MapViewController {
        
        let uiViewController = MapViewController()
        uiViewController.map.delegate = context.coordinator
        return uiViewController
    }
    
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapViewControllerBridge: MapViewControllerBridge
        init(_ mapViewControllerBridge: MapViewControllerBridge) {
            self.mapViewControllerBridge = mapViewControllerBridge
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            mapViewControllerBridge.GetLogation(coordinate)
        }
        
    }
}
