//
//  EateryRecom.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/12/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//
//  Our model for GoOut choice and DIY choice


import Foundation

let RecomType = ["Chinese Food", "Non-Chinese Food"]

class GoOut {
    var name: String {
        get { return goOutRestaurantName }
        set { goOutRestaurantName = String(newValue) }
    }
    
    var type: String {
        get { return goOutRestaurantType }
        set { goOutRestaurantType = String(newValue) }
    }
    
    var time: String {
        get { return goOutRestaurantTime }
        set { goOutRestaurantTime = String(newValue) }
    }
    
    var place: String {
        get { return goOutRestaurantPlace }
        set { goOutRestaurantPlace = String(newValue) }
    }
    
    var phone: String {
        get { return goOutRestaurantPhone }
        set { goOutRestaurantPhone = String(newValue) }
    }
    
    var imageData: NSData?
    
    convenience init(withName name: String, withType type: String, withTime time: String, withPlace place: String, withPhone phone: String, withImageData imageData: NSData?) {
        self.init()
        self.name = name
        self.type = type
        self.time = time
        self.place = place
        self.phone = phone
        self.imageData = imageData
    }
    
    private var goOutRestaurantName = ""
    
    private var goOutRestaurantType = ""
    
    private var goOutRestaurantTime = ""
    
    private var goOutRestaurantPlace = ""
    
    private var goOutRestaurantPhone = ""
}

class DIY {
    var name: String {
        get { return diyDishName }
        set { diyDishName = String(newValue) }
    }
    
    var type: String {
        get { return diyDishType }
        set { diyDishType = String(newValue) }
    }
    
    var recipe: String {
        get { return diyDishRecipe }
        set { diyDishRecipe = String(newValue) }
    }
    
    var procedure: String {
        get { return diyDishProcedure }
        set { diyDishProcedure = String(newValue) }
    }
    
    var imageData: NSData?
    
    convenience init(withName name: String, withType type: String, withRecipe recipe: String, withProcedure procedure: String, withImageData imageData: NSData?) {
        self.init()
        self.name = name
        self.type = type
        self.recipe = recipe
        self.procedure = procedure
        self.imageData = imageData
    }

    
    private var diyDishName = ""
    
    private var diyDishType = ""
    
    private var diyDishRecipe = ""
    
    private var diyDishProcedure = ""
    
    
}