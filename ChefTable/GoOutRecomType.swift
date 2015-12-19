//
//  GoOutRecomType.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/14/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import Foundation
import CoreData


class GoOutRecomType: NSManagedObject {

    
    class var entityName: String { return "GoOutRecomType" }
    
    class func typeWithGoOutInfo(goOutInfo: GoOut, inManagedObjectContext context: NSManagedObjectContext) -> GoOutRecomType? {
        
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "type = %@", goOutInfo.type)
        
        if let goOutRecomType = (try? context.executeFetchRequest(request))?.first as? GoOutRecomType {
            return goOutRecomType
        } else if let goOutRecomType = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as? GoOutRecomType {
            
            goOutRecomType.type = goOutInfo.type
            
            return goOutRecomType
        }
        
        return nil
    }
    

}
