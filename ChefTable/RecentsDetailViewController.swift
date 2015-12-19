//
//  RecentsDetailViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/29/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

//  Refs:
/* NSCalendar: http://www.jianshu.com/p/5850a5d03b8f */

import UIKit
import MapKit
import CoreData

class RecentsDetailViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Public
    
    var choice: (Dictionary<String, String>)?
    
    class ChoicePoint: NSObject, MKAnnotation {
        var title: String?
        var latitude: Double
        var longitude: Double
        
        init(title: String, latitude: Double, longitude: Double) {
            self.title = title
            self.latitude = latitude
            self.longitude = longitude
        }
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    // MARK: - UI
    
    @IBOutlet private weak var weekOfDayLabel: UILabel!
    
    @IBOutlet private weak var timezoneLabel: UILabel!
    
    @IBOutlet private weak var chineseDateLabel: UILabel!
    
    
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Standard
            mapView.delegate = self
        }
    }
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let category = choice?["category"] {
                switch category {
                case Constants.GoOutCategory:
                    performSegueWithIdentifier(Constants.ShowGoOutChoiceDetailsSegue, sender: view)
                    
                case Constants.DIYCategory:
                    performSegueWithIdentifier(Constants.ShowDIYChoiceDetailsSegue, sender: view)
                    
                default:
                    break
                }
            }
        }
    }
    
    
    // MARK: - Private
    
    private func updateUI() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        if let choice = choice,
            let inputDate = formatter.dateFromString(choice["date"]!) {
                
                title = choice["name"]
                
                // display week of day and time zone
                let calendar = NSCalendar.currentCalendar()
                let flags: NSCalendarUnit = [.Weekday, .TimeZone]
                let components = calendar.components(flags, fromDate: inputDate)
                weekOfDayLabel.text = weekdays[components.weekday]
                if let timezoneName = components.timeZone?.name {
                    timezoneLabel.text = timezoneName
                }
                
                // display corresponding Chinese date in Chinese time zone
                let chineseCalendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierChinese)
                if let chineseTimeZone = NSTimeZone.init(name: "Asia/Shanghai"),
                    let chineseComponents = chineseCalendar?.componentsInTimeZone(chineseTimeZone, fromDate: inputDate) {
                        chineseDateLabel.text = chineseYears[chineseComponents.year] + "年" + chineseMonths[chineseComponents.month] + chineseDays[chineseComponents.day]
                }
                
                // display annotation pin on the Map
                let latitude = (choice["latitude"]! as NSString).doubleValue
                let longitude = (choice["longitude"]! as NSString).doubleValue
                let choicePoint = ChoicePoint(title: choice["name"]!, latitude: latitude, longitude: longitude)
                mapView.addAnnotation(choicePoint)
                mapView.showAnnotations([choicePoint], animated: true)
                
                
        }
        
        
    }
    
    private struct Constants {
        
        static let GoOutCategory = "Go out!"
        static let DIYCategory = "DIY!"
        
        static let AnnotationViewReuseIdentifier = "choice"
        
        static let ShowGoOutChoiceDetailsSegue = "ShowGoOutChoice"
        static let ShowDIYChoiceDetailsSegue = "ShowDIYChoice"
    }
    
    private let weekdays = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    private let chineseYears = ["", "甲子", "乙丑", "丙寅", "丁卯",  "戊辰",  "己巳",  "庚午",  "辛未",  "壬申",  "癸酉",
        "甲戌",   "乙亥",  "丙子",  "丁丑", "戊寅",   "己卯",  "庚辰",  "辛己",  "壬午",  "癸未",
        "甲申",   "乙酉",  "丙戌",  "丁亥",  "戊子",  "己丑",  "庚寅",  "辛卯",  "壬辰",  "癸巳",
        "甲午",   "乙未",  "丙申",  "丁酉",  "戊戌",  "己亥",  "庚子",  "辛丑",  "壬寅",  "癸丑",
        "甲辰",   "乙巳",  "丙午",  "丁未",  "戊申",  "己酉",  "庚戌",  "辛亥",  "壬子",  "癸丑",
        "甲寅",   "乙卯",  "丙辰",  "丁巳",  "戊午",  "己未",  "庚申",  "辛酉",  "壬戌",  "癸亥"]
    private let chineseMonths = ["", "正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
    private let chineseDays = ["", "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
        "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
        "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
    
    
    // MARK: - VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController.contentViewController
        
        if let context = AppDelegate.managedObjectContext, let identifier = segue.identifier, let choice = choice {
            switch identifier {
            case Constants.ShowGoOutChoiceDetailsSegue:
                if let goOutRecomDetailstvc = destination as? GoOutRecomDetailsTableViewController {
                    let request = NSFetchRequest(entityName: GoOutRecomEntry.entityName)
                    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                    request.predicate = NSPredicate(format: "name = %@", choice["name"]!)
                    
                    var name: String?, type: String?, time: String?, place: String?, phone: String?, imageData: NSData?
                    context.performBlockAndWait {
                        let entries = try? context.executeFetchRequest(request)
                        if entries?.count > 0 {
                            if let entry = entries!.first as? GoOutRecomEntry {
                                name = entry.name
                                type = entry.type
                                time = entry.time
                                place = entry.place
                                phone = entry.phone
                                imageData = entry.imageData
                            }
                        }
                    }
                    
                    if let name = name, let type = type, let time = time, let place = place, let phone = phone, let imageData = imageData {
                        let goOut = GoOut(withName: name, withType: type, withTime: time, withPlace: place, withPhone: phone, withImageData: imageData)
                        goOutRecomDetailstvc.goOut = goOut
                    }

                }

            case Constants.ShowDIYChoiceDetailsSegue:
                
                if let diyesvc = destination as? DiyEmbedSegueViewController {
                    let request = NSFetchRequest(entityName: DIYRecomEntry.entityName)
                    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                    request.predicate = NSPredicate(format: "name = %@", choice["name"]!)
                    
                    var name: String?, type: String?, recipe: String?, procedure: String?, imageData: NSData?
                    context.performBlockAndWait {
                        let entries = try? context.executeFetchRequest(request)
                        if entries?.count > 0 {
                            if let entry = entries!.first as? DIYRecomEntry {
                                name = entry.name
                                type = entry.type
                                recipe = entry.recipe
                                procedure = entry.procedure
                                imageData = entry.imageData
                            }
                        }
                    }
                    
                    if let name = name, let type = type, let recipe = recipe, let procedure = procedure, let imageData = imageData {
                        let diy = DIY(withName: name, withType: type, withRecipe: recipe, withProcedure: procedure, withImageData: imageData)
                        diyesvc.diy = diy
                    }

                }
                    
                
            default:
                break
            }
        }
    }
    
    
    
}

