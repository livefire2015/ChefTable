//
//  GoOutRecomNewEntryViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/13/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit
import CoreData

class GoOutRecomNewEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Public
    
    var managedObjectContext: NSManagedObjectContext?
    
    var goOutEntry: GoOutRecomEntry?
    
    
    // MARK: - UI
    
    @IBAction private func touchDoneButton(sender: UIBarButtonItem) {
        
        if goOutEntry == nil {
            insertNewEntry()
        } else {
            updateTypeAndImage()
        }
        
        dismissModalBarButton()
    }
    @IBAction private func touchCancelButton(sender: UIBarButtonItem) {
        dismissModalBarButton()
    }
    
    @IBOutlet private weak var goOutRecomNewNameTextField: UITextField! {
        didSet { goOutRecomNewNameTextField.delegate = self }
    }
    private var goOutRecomName: String? {
        get { return goOutRecomNewNameTextField?.text }
        set { goOutRecomNewNameTextField?.text = newValue }
    }
    
    @IBOutlet private weak var goOutRecomNewTypeSelector: UISegmentedControl!
    private var goOutRecomTypeIndex: Int {
        get { return goOutRecomNewTypeSelector.selectedSegmentIndex }
        set { goOutRecomNewTypeSelector.selectedSegmentIndex = newValue }
    }
    
    @IBOutlet private weak var goOutRecomNewTimeTextView: UITextView!
    private var goOutRecomTime: String? {
        get { return goOutRecomNewTimeTextView?.text }
        set { goOutRecomNewTimeTextView?.text = newValue }
    }
    
    @IBOutlet private weak var goOutRecomNewPlaceTextView: UITextView!
    private var goOutRecomPlace: String? {
        get { return goOutRecomNewPlaceTextView?.text }
        set { goOutRecomNewPlaceTextView?.text = newValue }
    }
    
    @IBOutlet private weak var goOutRecomNewPhoneTextView: UITextView!
    private var goOutRecomPhone: String? {
        get { return goOutRecomNewPhoneTextView?.text }
        set { goOutRecomNewPhoneTextView?.text = newValue }
    }
    
    
    // MARK: - Image
    
    private var imageView = UIImageView()
    
    @IBOutlet private weak var imageViewContainer: UIView! {
        didSet {
            imageViewContainer.addSubview(imageView)
        }
    }
    
    @IBAction private func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            promptForSource()
        } else {
            promptForPhotoLibrary()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        imageView.image = image
        makeRoomForImage()
        dismissImageChoosing()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissImageChoosing()
    }
    
    
    
    // MARK: - VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if goOutEntry != nil {
            goOutRecomName = goOutEntry?.name
            goOutRecomTypeIndex = RecomType.indexOf((goOutEntry?.type)!)!
            goOutRecomTime = goOutEntry?.time
            goOutRecomPlace = goOutEntry?.place
            goOutRecomPhone = goOutEntry?.phone
            
            if goOutEntry?.imageData != nil {
                imageView.image = UIImage(data: (goOutEntry?.imageData)!)
                makeRoomForImage()
            }
            
            title = goOutRecomName
        } else {
            title = "Add a Go-Out Item"
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        goOutRecomNewNameTextField.becomeFirstResponder()
        
        listenToTextFields()
        listenToTextViews()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopListeningToTextFields()
        stopListeningToTextViews()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        makeRoomForImage()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == goOutRecomNewNameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Update (Use NSNotification only for texts)
    
    private var nametfObserver: AnyObject?
    private var timetvObserver: AnyObject?
    private var placetvObserver: AnyObject?
    private var phonetvObserver: AnyObject?
    
    private func listenToTextFields() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        
        nametfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: goOutRecomNewNameTextField, queue: queue) {
            notification in
            if let context = self.managedObjectContext {
                context.performBlock {
                    
                    self.goOutEntry?.name = self.goOutRecomName
                    
                    do {
                        try context.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                    }
                }
                
            }
        }
        
    }
    
    private func stopListeningToTextFields() {
        if nametfObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(nametfObserver!)
            nametfObserver = nil
        }
    }
    
    private func listenToTextViews() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        
        timetvObserver = center.addObserverForName(UITextViewTextDidChangeNotification, object: goOutRecomNewTimeTextView, queue: queue) {
            notification in
            if let context = self.managedObjectContext {
                context.performBlock {
                    
                    self.goOutEntry?.time = self.goOutRecomTime
                    
                    do {
                        try context.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                    }
                }
                
            }
            
        }
        
        placetvObserver = center.addObserverForName(UITextViewTextDidChangeNotification, object: goOutRecomNewPlaceTextView, queue: queue) {
            notification in
            if let context = self.managedObjectContext {
                context.performBlock {
                    
                    self.goOutEntry?.place = self.goOutRecomPlace
                    
                    do {
                        try context.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                    }
                }
                
            }
            
        }
        
        phonetvObserver = center.addObserverForName(UITextViewTextDidChangeNotification, object: goOutRecomNewPhoneTextView, queue: queue) {
            notification in
            if let context = self.managedObjectContext {
                context.performBlock {
                    
                    self.goOutEntry?.phone = self.goOutRecomPhone
                    
                    do {
                        try context.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                    }
                }
                
            }
            
        }
        
        
    }
    
    private func stopListeningToTextViews() {
        if timetvObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(timetvObserver!)
            timetvObserver = nil
        }
        if placetvObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(placetvObserver!)
            placetvObserver = nil
        }
        if phonetvObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(phonetvObserver!)
            phonetvObserver = nil
        }
    }
    
    
    private func updateTypeAndImage() {
        
        if let context = managedObjectContext {
            context.performBlock {
                self.goOutEntry?.type = RecomType[self.goOutRecomTypeIndex]
                
                if let image = self.imageView.image {
                    self.goOutEntry?.imageData = UIImageJPEGRepresentation(image, 0.75)
                } else {
                    self.goOutEntry?.imageData = nil
                }
                
                do {
                    try context.save()
                } catch let error {
                    print("Core Data Error: \(error)")
                }
            }
            
        }
    }
    
    
    
    // MARK: - Insert (Use Core Data Insert)
    
    private func insertNewEntry() {
        if let context = managedObjectContext {
            context.performBlock {
                if let name = self.goOutRecomName,
                    let time = self.goOutRecomTime,
                    let place = self.goOutRecomPlace,
                    let phone = self.goOutRecomPhone {
                        let type = RecomType[self.goOutRecomTypeIndex]
                        let imageData: NSData?
                        if let image = self.imageView.image {
                            imageData = UIImageJPEGRepresentation(image, 0.75)
                        } else {
                            imageData = nil
                        }
                        let goOutInfo = GoOut(withName: name, withType: type, withTime: time, withPlace: place, withPhone: phone, withImageData: imageData)
                        GoOutRecomEntry.entryWithGoOutInfo(goOutInfo, inManagedObjectContext: context)
                }
                
                do {
                    try context.save()
                } catch let error {
                    print("Core Data Error: \(error)")
                }
                
            }
            //printDatabaseStats(context)
        }
    }
    
    
    // Core Data sanity check
    private func printDatabaseStats(context: NSManagedObjectContext) {
        context.performBlock{
            let typeCount = context.countForFetchRequest(NSFetchRequest(entityName: GoOutRecomType.entityName), error: nil)
            print("\(typeCount) GoOutRecomTypes")
            let entryCount = context.countForFetchRequest(NSFetchRequest(entityName: GoOutRecomEntry.entityName), error: nil)
            print("\(entryCount) GoOutRecomEntries")
        }
    }
    
    // MARK: - Other Private Implementation
    
    private func dismissModalBarButton() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func dismissImageChoosing() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if imageView.image?.aspectRatio > 0 {
            if let width = imageView.superview?.frame.size.width {
                let height = width / (imageView.image!.aspectRatio)
                extraHeight = height - (imageView.frame.height)
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -imageView.frame.height
            imageView.frame = CGRectZero
        }
        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
    }
    
    
    private func promptForSource() {
        let alert = UIAlertController(title: "Add An Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            (action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            })
        alert.addAction(UIAlertAction(title: "Photo Library", style: .Default) {
            (action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            })
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) {
            (action: UIAlertAction) -> Void in
            // do nothing
            })
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    private func promptForPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    
}


extension UIImage {
    var aspectRatio: CGFloat { return size.height != 0 ? size.width / size.height : 0 }
}