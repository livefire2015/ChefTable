//
//  RecomTableViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/13/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//
//  Our reusable recommendation table view controller,
//  for either go-out or do-it-yourself choice
//

//  Refs:
/* Search API: https://www.veasoftware.com/tutorials/2015/6/27/uisearchcontroller-in-swift-xcode-7-ios-9-tutorial  http://stackoverflow.com/questions/29830698/uisearchcontroller-wont-dismiss-searchbar-and-overlap-for-ios-8-swift  */

/* File I/O: http://www.techotopia.com/index.php/IOS_8_Directory_Handling_and_File_I/O_in_Swift_–_A_Worked_Example  */

/* Core Data Diary App  https://goo.gl/a0g461  */

/* Delete and Update for collection view: http://stackoverflow.com/questions/29610316/how-to-add-a-delete-button-to-collection-view-cell-in-swift
http://stackoverflow.com/questions/15778017/cant-get-uimenucontroller-to-show-custom-items */

/* CollectionView inside TableView  http://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/  */

/* Pre-load some recoms (Refs: https://youtu.be/Lp1e3RBfJyE, http://www.raywenderlich.com/12170/core-data-tutorial-how-to-preloadimport-existing-data-updated)   */

/* Recipe App using UICollectionView  http://www.appcoda.com/supplementary-view-uicollectionview-flow-layout/  */


import UIKit
import CoreData

class RecomTableViewController: CoreDataTableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    
    // MARK: - Public
    
    // This var determines what kind of choices to show in our table view,
    // either go-out or do-it-yourself
    var category: String? {
        didSet { setfRCvarForTableCell() }
    }
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet { setfRCvarForTableCell() }
    }
    
    // Our core data instance
    var goOutEntry: GoOutRecomEntry?
    
    var diyEntry: DIYRecomEntry?
    
    
    // Our model for searching
    var filteredGoOuts = [GoOutRecomEntry]()
    
    var filteredDIYs = [DIYRecomEntry]()
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - Constants
    private struct StoryBoard {
        
        static let GoOutCategory = "Go out!"
        static let DIYCategory = "DIY!"
        
        static let TableCellIdentifier = "RecomInTable"
        static let CollectionCellIdentifier = "RecomInCollection"
        static let CollectionCellDeleteKey = "Entry"
        
        static let GoOutCollectionCellSegue = "ShowGoOutRecomDetails"
        static let GoOutNewEntryModal = "GoToNewGoOutModalVC"
        static let GoOutUpdateModal = "UpdateGoOut"
        static let DIYCollectionCellSegue = "ShowDIYRecomDetails"
        static let DIYNewEntryModal = "GoToNewDIYModalVC"
        static let DIYUpdateModal = "UpdateDIY"
        
        static let FileNameSeparator = " "
        static let FileTextContentSeparator = "###"
    }
    
    // MARK: - UI Actions
    
    @IBAction private func newEntryBarButton(sender: UIBarButtonItem) {
        
        if let category = self.category {
            switch category {
            case StoryBoard.GoOutCategory:
                performSegueWithIdentifier(StoryBoard.GoOutNewEntryModal, sender: sender)
            case StoryBoard.DIYCategory:
                performSegueWithIdentifier(StoryBoard.DIYNewEntryModal, sender: sender)
            default:
                break
            }
        }
        
    }
    
    // MARK: - VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = category
        
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = resultSearchController.searchBar

        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        resultSearchController.active = false
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.TableCellIdentifier, forIndexPath: indexPath)
        
        if let recomTypeCell = cell as? RecomTableViewCell,
            let category = self.category {
                switch category {
                case StoryBoard.GoOutCategory:
                    if let goOutRecomType = fetchedResultsController?.objectAtIndexPath(indexPath) as? GoOutRecomType {
                        var type: String?
                        goOutRecomType.managedObjectContext?.performBlockAndWait {
                            type = goOutRecomType.type
                        }
                        recomTypeCell.recomType = type
                    }
                case StoryBoard.DIYCategory:
                    if let diyRecomType = fetchedResultsController?.objectAtIndexPath(indexPath) as? DIYRecomType {
                        var type: String?
                        diyRecomType.managedObjectContext?.performBlockAndWait {
                            type = diyRecomType.type
                        }
                        recomTypeCell.recomType = type
                    }
                default:
                    break
                }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let recomTableViewCell = cell as? RecomTableViewCell {
            recomTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let type = RecomType[collectionView.tag]
        
        if let context = managedObjectContext,
            let category = self.category {
                switch category {
                case StoryBoard.GoOutCategory:
                    
                    if resultSearchController.active {
                        return filteredGoOuts.filter{$0.type == type}.count
                        
                    } else {
                        
                        let request = NSFetchRequest(entityName: GoOutRecomEntry.entityName)
                        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                        request.predicate = NSPredicate(format: "type = %@", type)
                        
                        var count: Int?
                        context.performBlockAndWait {
                            count = context.countForFetchRequest(request, error: nil)
                        }
                        return count!
                    }
                    
                case StoryBoard.DIYCategory:
                    
                    if resultSearchController.active {
                        return filteredDIYs.filter{$0.type == type}.count
                        
                    } else {
                        
                        let request = NSFetchRequest(entityName: DIYRecomEntry.entityName)
                        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                        request.predicate = NSPredicate(format: "type = %@", type)
                        
                        var count: Int?
                        context.performBlockAndWait {
                            count = context.countForFetchRequest(request, error: nil)
                        }
                        return count!
                    }
                    
                default:
                    break
                }
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryBoard.CollectionCellIdentifier, forIndexPath: indexPath)
        
        
        let type = RecomType[collectionView.tag]
        
        if let recomCell = cell as? RecomCollectionViewCell,
            let context = managedObjectContext,
            let category = self.category {
                switch category {
                case StoryBoard.GoOutCategory:
                    
                    var name: String?, time: String?, place: String?, phone: String?, imageData: NSData?
                    
                    if resultSearchController.active {
                        let entry = filteredGoOuts.filter{$0.type == type}[indexPath.item]
                        name = entry.name
                        time = entry.time
                        place = entry.place
                        phone = entry.phone
                        imageData = entry.imageData
                        
                    } else {
                        
                        let request = NSFetchRequest(entityName: GoOutRecomEntry.entityName)
                        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                        request.predicate = NSPredicate(format: "type = %@", type)
                        
                        context.performBlockAndWait {
                            let entries = try? context.executeFetchRequest(request)
                            if entries?.count > 0 {
                                if let entry = entries![indexPath.item] as? GoOutRecomEntry {
                                    name = entry.name
                                    time = entry.time
                                    place = entry.place
                                    phone = entry.phone
                                    imageData = entry.imageData
                                }
                            }
                        }
                    }
                    
                    let goOut = GoOut(withName: name!, withType: type, withTime: time!, withPlace: place!, withPhone: phone!, withImageData: imageData)
                    recomCell.goOut = goOut
                    
                case StoryBoard.DIYCategory:
                    
                    var name: String?, recipe: String?, procedure: String?, imageData: NSData?
                    
                    if resultSearchController.active {
                        let entry = filteredDIYs.filter{$0.type == type}[indexPath.item]
                        name = entry.name
                        recipe = entry.recipe
                        procedure = entry.procedure
                        imageData = entry.imageData
                        
                    } else {
                        
                        let request = NSFetchRequest(entityName: DIYRecomEntry.entityName)
                        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                        request.predicate = NSPredicate(format: "type = %@", type)
                        
                        context.performBlockAndWait {
                            let entries = try? context.executeFetchRequest(request)
                            if entries?.count > 0 {
                                if let entry = entries![indexPath.item] as? DIYRecomEntry {
                                    name = entry.name
                                    recipe = entry.recipe
                                    procedure = entry.procedure
                                    imageData = entry.imageData
                                }
                            }
                        }
                    }
                    
                    let diy = DIY(withName: name!, withType: type, withRecipe: recipe!, withProcedure: procedure!, withImageData: imageData)
                    recomCell.diy = diy
                    
                default:
                    break
                }
        }
        
        return cell
    }
    
    // MARK: - UISearchResultsUpdating Method
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let context = managedObjectContext,
            let category = self.category {
                switch category {
                case StoryBoard.GoOutCategory:
                    
                    filteredGoOuts.removeAll(keepCapacity: false)
                    
                    let request = NSFetchRequest(entityName: GoOutRecomEntry.entityName)
                    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                    request.predicate = NSPredicate(format: "name contains[c] %@", searchController.searchBar.text!)
                    
                    context.performBlockAndWait {
                        if let entries = try? context.executeFetchRequest(request) as! [GoOutRecomEntry] where entries.count > 0 {
                            self.filteredGoOuts = entries
                        }
                    }
                    
                    
                case StoryBoard.DIYCategory:
                    
                    filteredDIYs.removeAll(keepCapacity: false)
                    
                    let request = NSFetchRequest(entityName: DIYRecomEntry.entityName)
                    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                    request.predicate = NSPredicate(format: "name contains[c] %@", searchController.searchBar.text!)
                    
                    context.performBlockAndWait {
                        if let entries = try? context.executeFetchRequest(request) as! [DIYRecomEntry] where entries.count > 0 {
                            self.filteredDIYs = entries
                        }
                    }
                    
                default:
                    break
                }
        }
        
        tableView.reloadData()
        
    }
    
    
    // MARK: - UICollectionViewCell segue
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        if let category = self.category {
            switch category {
            case StoryBoard.GoOutCategory:
                performSegueWithIdentifier(StoryBoard.GoOutCollectionCellSegue, sender: cell)
            case StoryBoard.DIYCategory:
                performSegueWithIdentifier(StoryBoard.DIYCollectionCellSegue, sender: cell)
            default:
                break
            }
        }
        
    }
    
    
    // MARK: - Custom UICollectionView Menu
    
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let deleteMI = UIMenuItem(title: "Delete", action: "dismiss:")
        let updateMI = UIMenuItem(title: "Update", action: "update:")
        UIMenuController.sharedMenuController().menuItems = [deleteMI, updateMI]
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        return action == "dismiss:" || action == "update:"
    }
    
    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
        // Note: first update the data source (our Core Data model here), then save, finally notify the collection view of any changes (e.g., deleteItemsAtIndexPaths)
        
        let type = RecomType[collectionView.tag]
        
        if action == "dismiss:" {
            if let context = managedObjectContext,
                let category = self.category,
                let cachesDirectory = NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first {
                    switch category {
                    case StoryBoard.GoOutCategory:
                        
                        let request = NSFetchRequest(entityName: GoOutRecomEntry.entityName)
                        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                        request.predicate = NSPredicate(format: "type = %@", type)
                        
                        var name: String?, time: String?, place: String?, phone: String?, imageData: NSData?
                        context.performBlockAndWait {
                            let entries = try? context.executeFetchRequest(request)
                            if entries?.count > 0 {
                                if let entry = entries![indexPath.item] as? GoOutRecomEntry {
                                    
                                    name = entry.name
                                    time = entry.time
                                    place = entry.place
                                    phone = entry.phone
                                    imageData = entry.imageData
                                    
                                    context.deleteObject(entry)
                                    
                                    do {
                                        try context.save()
                                    } catch let error {
                                        print("Core Data Error: \(error)")
                                    }
                                    
                                    collectionView.deleteItemsAtIndexPaths([indexPath])
                                }
                            }
                        }
                        
                        var delete = [String : String]()
                        let textFilename = ["\(category)","\(name!)", ".dat"].joinWithSeparator(StoryBoard.FileNameSeparator)
                        let imageFilename = ["\(category)","\(name!)", ".jpg"].joinWithSeparator(StoryBoard.FileNameSeparator)
                        let textFileURL = cachesDirectory.URLByAppendingPathComponent(textFilename)
                        let imageFileURL = cachesDirectory.URLByAppendingPathComponent(imageFilename)
                        let textContent = ["\(name!)","\(type)","\(time!)","\(place!)","\(phone!)"].joinWithSeparator(StoryBoard.FileTextContentSeparator)
                        if let textData = (textContent as NSString).dataUsingEncoding(NSUTF8StringEncoding) where textData.writeToURL(textFileURL, atomically: true) {
                            delete["textFilename"] = textFilename
                            
                        }
                        if let imageData = imageData where imageData.writeToURL(imageFileURL, atomically: true) {
                            delete["imageFilename"] = imageFilename
                        }
                        delete["category"] = category
                        Deletes().addDelete(delete)
                        
                    case StoryBoard.DIYCategory:
                        let request = NSFetchRequest(entityName: DIYRecomEntry.entityName)
                        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                        request.predicate = NSPredicate(format: "type = %@", type)
                        
                        var name: String?, recipe: String?, procedure: String?, imageData: NSData?
                        context.performBlockAndWait {
                            let entries = try? context.executeFetchRequest(request)
                            if entries?.count > 0 {
                                if let entry = entries![indexPath.item] as? DIYRecomEntry {
                                    
                                    name = entry.name
                                    recipe = entry.recipe
                                    procedure = entry.procedure
                                    imageData = entry.imageData
                                    
                                    context.deleteObject(entry)
                                    
                                    do {
                                        try context.save()
                                    } catch let error {
                                        print("Core Data Error: \(error)")
                                    }
                                    
                                    collectionView.deleteItemsAtIndexPaths([indexPath])
                                }
                            }
                        }
                        
                        var delete = [String : String]()
                        let textFilename = ["\(category)","\(name!)", ".dat"].joinWithSeparator(StoryBoard.FileNameSeparator)
                        let imageFilename = ["\(category)","\(name!)", ".jpg"].joinWithSeparator(StoryBoard.FileNameSeparator)
                        let textFileURL = cachesDirectory.URLByAppendingPathComponent(textFilename)
                        let imageFileURL = cachesDirectory.URLByAppendingPathComponent(imageFilename)
                        let textContent = ["\(name!)","\(type)","\(recipe!)","\(procedure!)"].joinWithSeparator(StoryBoard.FileTextContentSeparator)
                        if let textData = (textContent as NSString).dataUsingEncoding(NSUTF8StringEncoding) where textData.writeToURL(textFileURL, atomically: true) {
                            delete["textFilename"] = textFilename
                            
                        }
                        if let imageData = imageData where imageData.writeToURL(imageFileURL, atomically: true) {
                            delete["imageFilename"] = imageFilename
                        }
                        delete["category"] = category
                        Deletes().addDelete(delete)
                        
                    default:
                        break
                    }
            }
            
        } else if action == "update:" {
            if let context = managedObjectContext,
                let category = self.category {
                    switch category {
                    case StoryBoard.GoOutCategory:
                        
                        let request = NSFetchRequest(entityName: GoOutRecomEntry.entityName)
                        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                        request.predicate = NSPredicate(format: "type = %@", type)
                        
                        
                        context.performBlockAndWait {
                            let entries = try? context.executeFetchRequest(request)
                            if entries?.count > 0 {
                                if let entry = entries![indexPath.item] as? GoOutRecomEntry {
                                    
                                    self.goOutEntry = entry
                                    self.performSegueWithIdentifier(StoryBoard.GoOutUpdateModal, sender: sender)
                                }
                            }
                        }
                        
                        
                        
                    case StoryBoard.DIYCategory:
                        let request = NSFetchRequest(entityName: DIYRecomEntry.entityName)
                        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                        request.predicate = NSPredicate(format: "type = %@", type)
                        
                        context.performBlockAndWait {
                            let entries = try? context.executeFetchRequest(request)
                            if entries?.count > 0 {
                                if let entry = entries![indexPath.item] as? DIYRecomEntry {
                                    
                                    self.diyEntry = entry
                                    self.performSegueWithIdentifier(StoryBoard.DIYUpdateModal, sender: sender)
                                }
                            }
                        }
                        
                        
                    default:
                        break
                    }
            }
        }
        
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController.contentViewController
        if let identifier = segue.identifier {
            switch identifier {
            case StoryBoard.GoOutCollectionCellSegue:
                if let goOutRecomDetailstvc = destination as? GoOutRecomDetailsTableViewController,
                    let goOutRecomcvc = sender as? RecomCollectionViewCell {
                        goOutRecomDetailstvc.goOut = goOutRecomcvc.goOut
                }
                
            case StoryBoard.GoOutNewEntryModal:
                if let goOutRecomNewEntryvc = destination as? GoOutRecomNewEntryViewController {
                    goOutRecomNewEntryvc.managedObjectContext = managedObjectContext
                }
                
            case StoryBoard.GoOutUpdateModal:
                if let goOutRecomNewEntryvc = destination as? GoOutRecomNewEntryViewController {
                    goOutRecomNewEntryvc.managedObjectContext = managedObjectContext
                    goOutRecomNewEntryvc.goOutEntry = goOutEntry
                }
                
                
            case StoryBoard.DIYCollectionCellSegue:
                if let diyesvc = destination as? DiyEmbedSegueViewController,
                    let diyRecomcvc = sender as? RecomCollectionViewCell {
                        diyesvc.diy = diyRecomcvc.diy
                }
                
            case StoryBoard.DIYNewEntryModal:
                if let diyRecomNewEntryvc = destination as? DiyRecomNewEntryViewController {
                    diyRecomNewEntryvc.managedObjectContext = managedObjectContext
                }
                
            case StoryBoard.DIYUpdateModal:
                if let diyRecomNewEntryvc = destination as? DiyRecomNewEntryViewController {
                    diyRecomNewEntryvc.managedObjectContext = managedObjectContext
                    diyRecomNewEntryvc.diyEntry = diyEntry
                }
                
                
            default:
                break
            }
        }
    }
    
    
    // set our fetchedResultsController
    private func setfRCvarForTableCell() {
        if let context = managedObjectContext where category != nil {
            switch category! {
            case StoryBoard.GoOutCategory:
                let request = NSFetchRequest(entityName: GoOutRecomType.entityName)
                request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            case StoryBoard.DIYCategory:
                let request = NSFetchRequest(entityName: DIYRecomType.entityName)
                request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true, selector: "localizedCaseInsensitiveCompare:")]
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            default:
                fetchedResultsController = nil
            }
        } else {
            fetchedResultsController = nil
        }
    }
    
    
}
