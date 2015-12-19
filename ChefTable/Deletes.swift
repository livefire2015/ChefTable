//
//  Deletes.swift
//  ChefTable
//
//  Created by Yangye Zhu on 12/1/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import Foundation

class Deletes {
    
    // MARK: - Public API
    
    var deletes: [Dictionary<String, String>] {
        get {
            return defaults.objectForKey(Storyboard.KeyName) as? [Dictionary<String, String>] ?? []
        }
        set {
            defaults.setObject(newValue, forKey: Storyboard.KeyName)
        }
    }
    
    
    func addDelete(delete: Dictionary<String, String>) {
        var currDeletes = deletes
        currDeletes.insert(delete, atIndex: 0)
        
        deletes = currDeletes
    }
    
    
    // MARK: - Private Implementation
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private struct Storyboard {
        static let KeyName = "RecentDeletes"
        
    }
    
    
}
