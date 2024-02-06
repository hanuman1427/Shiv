//
//  CoreDataManager.swift
//  Voice & Text Translator
//
//  Created by mac on 02/12/22.
//

import Foundation
import CoreData
import UIKit


class PIPValueData {
    
    func SavePipValue(context : NSManagedObjectContext, PipV : PipValueData?) -> Bool {
        
        let entity = NSEntityDescription.entity(forEntityName: "PipValue",in: context)!
        let data = NSManagedObject(entity: entity,insertInto: context)
        data.setValue(PipV?.pipName, forKey: "pipName")
        data.setValue(PipV?.timestamp, forKey: "timestamp")
        data.setValue(PipV?.date, forKey: "date")
        data.setValue(PipV?.pipArray, forKey: "pipArray")
        data.setValue(PipV?.noOfPips, forKey: "noOfPips")
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func fetchPipValue(context : NSManagedObjectContext,complation : @escaping (([PipValue]) -> ())) {
        var arrReminder = [PipValue]()
        let fetchRequest = NSFetchRequest<PipValue>(entityName: "PipValue")
        do {
            arrReminder = try context.fetch(fetchRequest)
            complation(arrReminder)
        } catch {
            complation([PipValue]())
        }
    }
    
    func deletePipValue(context : NSManagedObjectContext,selectedProduct : PipValue) -> Bool {
        context.delete(selectedProduct)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
}


