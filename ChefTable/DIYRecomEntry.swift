//
//  DIYRecomEntry.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/17/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import Foundation
import CoreData


class DIYRecomEntry: NSManagedObject {

    
    class var entityName: String { return "DIYRecomEntry" }
    
    
    class func entryWithDIYInfo(diyInfo: DIY, inManagedObjectContext context: NSManagedObjectContext) -> DIYRecomEntry? {
        
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "name = %@", diyInfo.name)
        
        if let diyRecomEntry = (try? context.executeFetchRequest(request))?.first as? DIYRecomEntry {
            return diyRecomEntry
        } else if let diyRecomEntry = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as? DIYRecomEntry {
            
            diyRecomEntry.name = diyInfo.name
            diyRecomEntry.type = diyInfo.type
            diyRecomEntry.recipe = diyInfo.recipe
            diyRecomEntry.procedure = diyInfo.procedure
            diyRecomEntry.imageData = diyInfo.imageData
            diyRecomEntry.typeInfo = DIYRecomType.typeWithDIYInfo(diyInfo, inManagedObjectContext: context)
            
            return diyRecomEntry
        }
        
        return nil
    }


}
