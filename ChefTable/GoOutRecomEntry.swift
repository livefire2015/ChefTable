//
//  GoOutRecomEntry.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/13/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import Foundation
import CoreData


class GoOutRecomEntry: NSManagedObject {
    
    class var entityName: String { return "GoOutRecomEntry" }
    

    class func entryWithGoOutInfo(goOutInfo: GoOut, inManagedObjectContext context: NSManagedObjectContext) -> GoOutRecomEntry? {
        
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "name = %@", goOutInfo.name)
        
        if let goOutRecomEntry = (try? context.executeFetchRequest(request))?.first as? GoOutRecomEntry {
            return goOutRecomEntry
        } else if let goOutRecomEntry = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as? GoOutRecomEntry {
            
            goOutRecomEntry.name = goOutInfo.name
            goOutRecomEntry.type = goOutInfo.type
            goOutRecomEntry.time = goOutInfo.time
            goOutRecomEntry.place = goOutInfo.place
            goOutRecomEntry.phone = goOutInfo.phone
            goOutRecomEntry.imageData = goOutInfo.imageData
            goOutRecomEntry.typeInfo = GoOutRecomType.typeWithGoOutInfo(goOutInfo, inManagedObjectContext: context)
            
            return goOutRecomEntry
        }
        
        return nil
    }

    
}
