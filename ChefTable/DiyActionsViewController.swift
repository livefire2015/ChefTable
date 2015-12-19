//
//  DiyActionsViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/19/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

// Refs:
/* Picker API: http://makeapppie.com/2014/09/22/swift-swift-using-dates-and-the-uidatepicker-in-swift/  */

/* EventKit API: https://www.andrewcbancroft.com/2015/05/14/beginners-guide-to-eventkit-in-swift-requesting-permission/  https://www.youtube.com/watch?v=KgrY-UJTPRY */

/* Sharing API: http://www.codingexplorer.com/sharing-swift-app-uiactivityviewcontroller/ */

/* Make a call programmatically: http://stackoverflow.com/questions/4929717/make-a-phone-call-programmatically */

/* Core Location help: http://i.stack.imgur.com/gqy04.jpg */

/* NSCalendar help: http://nshipster.com/nscalendar-additions/  */


import UIKit
import CoreLocation
import EventKit

class DiyActionsViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Public
    
    var diy: DIY?
    
    // MARK: - UI
    
    @IBOutlet private weak var nameSwitch: UISwitch!
    @IBOutlet private weak var typeSwitch: UISwitch!
    @IBOutlet private weak var recipeSwitch: UISwitch!
    @IBOutlet private weak var procedureSwitch: UISwitch!
    @IBOutlet private weak var imageSwitch: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    

    // MARK: - VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLocation()
    }

     // MARK: - Actions
    
    // tap to share what is chosen
    @IBAction private func shareDIY(sender: UIButton) {
        var objectsToShare = [AnyObject]()
        
        if nameSwitch.on && diy?.name != nil {
            objectsToShare.append((diy?.name)!)
        }
        if typeSwitch.on && diy?.type != nil {
            objectsToShare.append((diy?.type)!)
        }
        if recipeSwitch.on && diy?.recipe != nil {
            objectsToShare.append((diy?.recipe)!)
        }
        if procedureSwitch.on && diy?.procedure != nil {
            objectsToShare.append((diy?.procedure)!)
        }
        if imageSwitch.on && diy?.imageData != nil {
            objectsToShare.append(UIImage(data: (diy?.imageData)!)!)
        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    // swipe up to save to history
    @IBAction private func saveToRecents(recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .Ended {
            
            // add time
            loadTime()
            
            // add location using Core Location methods (see MARK: Location)
            
            // save current visit
            var choice = [String : String]()
            choice["name"] = diy?.name
            choice["category"] = "DIY!"
            choice["date"] = timeString
            choice["location"] = locationName
            choice["longitude"] = locationLongitude
            choice["latitude"] = locationLatitude
                        
            let ac = UIAlertController(title: diy?.name, message: "Saved to history?", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default) {
                (action: UIAlertAction) -> Void in
                Recents().addChoice(choice)
                })
            ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func createEvent(sender: UIButton) {
        let eventStore = EKEventStore()
        
        let startDate = datePicker.date
        let endDate = startDate.dateByAddingTimeInterval(60*60*3) // 3 hours
        
        let ac = UIAlertController(title: diy?.name, message: "Create an event?", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default) {
            (action: UIAlertAction) -> Void in
            if EKEventStore.authorizationStatusForEntityType(.Event) != .Authorized {
                eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) -> Void in
                    self.createEvent(eventStore, title: (self.diy?.name)!, startDate: startDate, endDate: endDate)
                })
            } else {
                self.createEvent(eventStore, title: (self.diy?.name)!, startDate: startDate, endDate: endDate)
            }
            
            })
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    
    // MARK: - Time
    
    private var timeString = ""
    private func loadTime() {
        let currDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        timeString = formatter.stringFromDate(currDate)
    }
    
    // MARK: - Location
    
    private var locationName = ""
    private var locationLongitude = ""
    private var locationLatitude = ""
    private let locationManager = CLLocationManager()
    private func loadLocation() {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        let location = locations.first
        
        if let longitude = location?.coordinate.longitude,
            let latitude = location?.coordinate.latitude {
                locationLongitude = "\(longitude)"
                locationLatitude = "\(latitude)"
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location!) { (placemarks, error) -> Void in
            let placemark = placemarks!.first
            if let placename = placemark?.name {
                self.locationName = placename
            }
            
        }
        
    }
    
    // MARK: - Event
    
    private func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            
        } catch {
            print("Error in saving new event")
        }
        
    }


}
