//
//  DIYRecomEntry+CoreDataProperties.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/17/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DIYRecomEntry {

    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var recipe: String?
    @NSManaged var procedure: String?
    @NSManaged var imageData: NSData?
    @NSManaged var typeInfo: NSManagedObject?

}
