//
//  Recents.swift
//  SmashTag
//
//  Created by Yangye Zhu on 10/25/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import Foundation

class Recents {
    
    // MARK: - Public API
    
    var choices: [Dictionary<String, String>] {
        get {
            return defaults.objectForKey(Storyboard.KeyName) as? [Dictionary<String, String>] ?? []
        }
        set {
            defaults.setObject(newValue, forKey: Storyboard.KeyName)
        }
    }
    
    
    func addChoice(choice: Dictionary<String, String>) {
        var currChoices = choices
        currChoices.insert(choice, atIndex: 0)
        while(currChoices.count > choicesLimit) {
            currChoices.removeLast()
        }
        
        choices = currChoices
    }
    
    
    // MARK: - Private Implementation
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private struct Storyboard {
        static let KeyName = "RecentChoices"
    
    }
    
    private var choicesLimit: Int {
        return 100
    }

    
}