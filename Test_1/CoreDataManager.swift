//
//  CoreDataManager.swift
//  Test_1
//
//  Created by Arun Skyraan on 30/08/24.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    let persistentContainer : NSPersistentContainer
    init() {
        persistentContainer = NSPersistentContainer(name: "PatientDetails")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getPatientDetails() -> [Patientdetails] {
        let fetchRequest: NSFetchRequest<Patientdetails> = Patientdetails.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return[]
        }
    }
    
    
    func SaveCategoryData(patientID: String,patientName:String,patientAge:Int,patientGender:String,patientLat:Double,patientLong:Double){
        let entity  = Patientdetails(context: persistentContainer.viewContext)
        entity.patientID = patientID
        entity.patientName = patientName
        entity.patientAge = Int16(patientAge)
        entity.patientGender = patientGender
        entity.patientLat = patientLat
        entity.patientLong = patientLong
        
        
        do {
            try persistentContainer.viewContext.save()
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
}
