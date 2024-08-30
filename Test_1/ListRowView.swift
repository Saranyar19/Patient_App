//
//  ListRowView.swift
//  Test_1
//
//  Created by Jegathiswaran Skyraan on 30/08/24.
//

import SwiftUI
import CoreLocation
struct ListRowView: View {
    @State var patient : Patientdetails
    func GetCityNAme(latitude:Double,longitude:Double,name : @escaping ([String]) -> Void ){
        var arr : [String] = []
        struct ReversedGeoLocation {
            let name: String            // eg. Apple Inc.
            let streetName: String      // eg. Infinite Loop
            let streetNumber: String    // eg. 1
            let city: String            // eg. Cupertino
            let state: String           // eg. CA
            let zipCode: String         // eg. 95014
            let country: String         // eg. United States
            let isoCountryCode: String  // eg. US
            
            var formattedAddress: String {
                return """
                \(name),
                \(streetNumber) \(streetName),
                \(city), \(state) \(zipCode)
                \(country)
                """
            }
            
            // Handle optionals as needed
            init(with placemark: CLPlacemark) {
                self.name           = placemark.name ?? ""
                self.streetName     = placemark.thoroughfare ?? ""
                self.streetNumber   = placemark.subThoroughfare ?? ""
                self.city           = placemark.locality ?? ""
                self.state          = placemark.administrativeArea ?? ""
                self.zipCode        = placemark.postalCode ?? ""
                self.country        = placemark.country ?? ""
                self.isoCountryCode = placemark.isoCountryCode ?? ""
            }
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemarks = placemarks ,let placemark = placemarks.first{
                if let subLocality = placemark.subLocality{
                    arr.append(subLocality)
                }
                if let locality = placemark.locality{
                    arr.append(locality)
                }
                
                
            }
            name(arr)
            
            // Apple Inc.,
            // 1 Infinite Loop,
            // Cupertino, CA 95014
            // United States
            
        }
        
    }

    @State var LocalName = ""
    @State var showCoordinates = false
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Patient ID : \(patient.patientID ?? "")")
                .bold()
            Text("Patient Name :\(patient.patientName ?? "")")
            
            Text("Patient Age :  \(patient.patientAge)")
            Text("Patient Gender : \(patient.patientGender ?? "")")
            
            
            

            if !LocalName.isEmpty{
                HStack{
                    
                    Text("\(LocalName)")
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showCoordinates.toggle()
                        }
                    }, label: {
                        Text(Image(systemName: "chevron.down"))
                            .bold()
                            .rotationEffect(.degrees(!showCoordinates ? 0 : 180))
                    })
                    
                }
            }
            
            if showCoordinates{
                Text("Logitude: \(patient.patientLong)")
                Text("Latitude: \(patient.patientLat)")
            }
        }
        .onAppear(perform: {
            GetCityNAme(latitude: patient.patientLat, longitude: patient.patientLong, name: {
                strArr in
                LocalName = strArr.joined(separator: ", ")
            })
        })

    }
}

#Preview {
    HomeView()
}
