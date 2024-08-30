//
//  AddUserDetails.swift
//  Test_1
//
//  Created by Jegathiswaran Skyraan on 30/08/24.
//

import SwiftUI
import CoreLocation
struct AddPatientDetails: View {
    @State var patientName = ""
    @State var patientAge : Int = 1
    @State var patientGender = "Male"
    @Binding var showAddUser : Bool
    @State var isActiveNavigate = false
    @State var location : CLLocationCoordinate2D?
    
    var GenderArr : [String] = ["Male","Female"]
    
    var ReloadCD : () -> Void
    
    var body: some View {
        if showAddUser{
            let count = CoreDataManager.shared.getPatientDetails().count + 1
            VStack(alignment:.leading,spacing: 20){
                HStack{
                    Text("Add Patient")
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        showAddUser = false
                    }, label: {
                        Image(systemName: "x.circle")

                    })

                }
                
                Text("Patient ID:  **HRS\(String(format: "%04d", count))**")
                
                Text("Patient Name:")
                
                TextField("Enter your Name", text: $patientName)
                
                Text("Patient Age:")

                Picker("Please choose a Age", selection: $patientAge) {
                    ForEach(1..<100, id: \.self) {
                        Text("\($0)")
                    }
                }
                
                Text("Patient Gender:")
                
                Picker("Please choose gender", selection: $patientGender) {
                    ForEach(GenderArr, id: \.self) {
                        Text("\($0)")
                    }
                }
                
                
                if let location = location{
                    Text("Longitude: \(location.longitude)")
                    Text("Latitude: \(location.latitude)")
                }else{
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            isActiveNavigate.toggle()
                        }, label: {
                            Text("Select Location")
                                .bold()
                                .foregroundColor(Color.white)
                                .padding(.horizontal)
                                .padding(.vertical,5)
                                .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                )
                        })
                        Spacer()
                    }
                }

                HStack{
                    Spacer()
                    
                    Button(action: {
                        if patientName.isEmpty || patientAge == 0 || patientGender.isEmpty || location == nil{
                            DispatchQueue.main.async {
                                
                                let AleetController = UIAlertController(title: "Please enter all details", message: "", preferredStyle: .alert)
                                let AlertBtn = UIAlertAction(title: "OK", style: .default)
                                AleetController.addAction(AlertBtn)
                                if let window = UIApplication.shared.windows.first, let RVC = window.rootViewController{
//                                    AleetController.present(RVC, animated: true)
                                    RVC.present(AleetController, animated: true)
                                }
                            }
                        }else{
                            CoreDataManager.shared.SaveCategoryData(patientID: "HRS\(String(format: "%04d", count))", patientName: patientName, patientAge: patientAge, patientGender: patientGender, patientLat: location!.latitude, patientLong: location!.longitude)
                            patientName = ""
                            patientAge = 0
                            patientGender = ""
                            location = nil
                            showAddUser = false
                            ReloadCD()
                        }
                        
                    }, label: {
                        Text("Save")
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .padding(.vertical,5)
                            .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                            )
                    })
                    Spacer()
                }

                
            }.padding()
                .background(
                    ZStack{
                        NavigationLink("", isActive: $isActiveNavigate, destination: {
                            MapViewControllerBridge(GetLogation: {
                                Location in
                                location = Location
                                isActiveNavigate = false
                            })

                        })

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    }
                )
                .font(.system(size: 20))
                .foregroundColor(.black)

        }
    }
}

#Preview {
    HomeView()
}
