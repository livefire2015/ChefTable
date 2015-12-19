//
//  DiyRecomNewEntryViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/17/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit
import CoreData

class DiyRecomNewEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Public
    
    var managedObjectContext: NSManagedObjectContext?
    
    var diyEntry: DIYRecomEntry?
    
    
    // MARK: - UI
    
    @IBAction private func touchDoneButton(sender: UIBarButtonItem) {
        
        if diyEntry == nil {
            insertNewEntry()
        } else {
            updateTypeAndImage()
        }

        dismissModalBarButton()
    }
    
    
    @IBAction private func touchCancelButton(sender: UIBarButtonItem) {
        dismissModalBarButton()
    }
    
    @IBOutlet private weak var diyRecomNewNameTextField: UITextField! {
        didSet { diyRecomNewNameTextField.delegate = self }
    }
    private var diyRecomName: String? {
        get { return diyRecomNewNameTextField?.text }
        set { diyRecomNewNameTextField?.text = newValue }
    }
    
    @IBOutlet private weak var diyRecomNewTypeSelector: UISegmentedControl!
    private var diyRecomTypeIndex: Int {
        get { return diyRecomNewTypeSelector.selectedSegmentIndex }
        set { diyRecomNewTypeSelector.selectedSegmentIndex = newValue }
    }
    
    @IBOutlet private weak var diyRecomNewRecipeTextView: UITextView!
    private var diyRecomRecipe: String? {
        get { return diyRecomNewRecipeTextView?.text }
        set { diyRecomNewRecipeTextView?.text = newValue }
    }
   
    @IBOutlet private weak var diyRecomNewProcedureTextView: UITextView!
    private var diyRecomProcedure: String? {
        get { return diyRecomNewProcedureTextView?.text }
        set { diyRecomNewProcedureTextView?.text = newValue }
    }
    
    
    // MARK: - Image from Camera or Photo Library
    
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
        
        if diyEntry != nil {
            diyRecomName = diyEntry?.name
            diyRecomTypeIndex = RecomType.indexOf((diyEntry?.type)!)!
            diyRecomRecipe = diyEntry?.recipe
            diyRecomProcedure = diyEntry?.procedure
            
            if diyEntry?.imageData != nil {
                imageView.image = UIImage(data: (diyEntry?.imageData)!)
                makeRoomForImage()
            }
            
            title = diyRecomName
        } else {
            title = "Add a DIY Item"
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        diyRecomNewNameTextField.becomeFirstResponder()
        
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
        if textField == diyRecomNewNameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    // MARK: - Update (Use NSNotification only for texts)
    
    private var nametfObserver: AnyObject?
    private var recipetvObserver: AnyObject?
    private var proceduretvObserver: AnyObject?
    
    private func listenToTextFields() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        
        nametfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: diyRecomNewNameTextField, queue: queue) {
            notification in
            if let context = self.managedObjectContext {
                context.performBlock {
                    
                    self.diyEntry?.name = self.diyRecomName
                    
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
        
        recipetvObserver = center.addObserverForName(UITextViewTextDidChangeNotification, object: diyRecomNewRecipeTextView, queue: queue) {
            notification in
            if let context = self.managedObjectContext {
                context.performBlock {
                    
                    self.diyEntry?.recipe = self.diyRecomRecipe
                    
                    do {
                        try context.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                    }
                }
                
            }
            
        }
        
        proceduretvObserver = center.addObserverForName(UITextViewTextDidChangeNotification, object: diyRecomNewProcedureTextView, queue: queue) {
            notification in
            if let context = self.managedObjectContext {
                context.performBlock {
                    
                    self.diyEntry?.procedure = self.diyRecomProcedure
                    
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
        if recipetvObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(recipetvObserver!)
            recipetvObserver = nil
        }
        if proceduretvObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(proceduretvObserver!)
            proceduretvObserver = nil
        }
    }
    
    // General update-by-pressing-done method
    private func updateTypeAndImage() {
        
        if let context = managedObjectContext {
            context.performBlock {
                self.diyEntry?.type = RecomType[self.diyRecomTypeIndex]
                
                if let image = self.imageView.image {
                    self.diyEntry?.imageData = UIImageJPEGRepresentation(image, 0.75)
                } else {
                    self.diyEntry?.imageData = nil
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
                if let name = self.diyRecomNewNameTextField?.text,
                    let recipe = self.diyRecomNewRecipeTextView?.text,
                    let procedure = self.diyRecomNewProcedureTextView?.text {
                        let type = RecomType[self.diyRecomTypeIndex]
                        let imageData: NSData?
                        if let image = self.imageView.image {
                            imageData = UIImageJPEGRepresentation(image, 0.75)
                        } else {
                            imageData = nil
                        }
                        let diyInfo = DIY(withName: name, withType: type, withRecipe: recipe, withProcedure: procedure, withImageData: imageData)
                        DIYRecomEntry.entryWithDIYInfo(diyInfo, inManagedObjectContext: context)
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
    
    // Core Data sanity-check helper
    private func printDatabaseStats(context: NSManagedObjectContext) {
        context.performBlock{
            let typeCount = context.countForFetchRequest(NSFetchRequest(entityName: DIYRecomType.entityName), error: nil)
            print("\(typeCount) DIYRecomTypes")
            let entryCount = context.countForFetchRequest(NSFetchRequest(entityName: DIYRecomEntry.entityName), error: nil)
            print("\(entryCount) DIYRecomEntries")
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
