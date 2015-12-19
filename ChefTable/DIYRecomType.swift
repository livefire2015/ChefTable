//
//  DIYRecomType.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/17/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import Foundation
import CoreData


class DIYRecomType: NSManagedObject {
    
    
    class var entityName: String { return "DIYRecomType" }
    
    class func typeWithDIYInfo(diyInfo: DIY, inManagedObjectContext context: NSManagedObjectContext) -> DIYRecomType? {
        
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "type = %@", diyInfo.type)
        
        if let diyRecomType = (try? context.executeFetchRequest(request))?.first as? DIYRecomType {
            return diyRecomType
        } else if let diyRecomType = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as? DIYRecomType {
            
            diyRecomType.type = diyInfo.type
            
            return diyRecomType
        }
        
        return nil
    }
    
    
}
