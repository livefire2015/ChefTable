//
//  PageEntranceViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/22/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

//  Refs:
/* Page Control Refs: http://www.appcoda.com/uipageviewcontroller-storyboard-tutorial/
https://youtu.be/8bltsDG2ENQ */

/* App Icon: http://restaurantsofchester.com/wp-content/uploads/2015/10/4-compressor-1024x512.jpg  https://makeappicon.com */

/* Embed a YouTube video https://developers.google.com/youtube/v3/guides/ios_youtube_helper  */



import UIKit
import CoreData

class PageEntranceViewController: UIViewController, UIPageViewControllerDataSource {
    
    // Our page content model here
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    
    let pageVideoIds = ["cgTScNCgYCk", "N5fdp-qkMW4"]
    
    let pageIntros = ["Want to go to restaurants?", "Why not create your own dish?"]
    
    let pageChoices = ["Go out!", "DIY!"]
    
    
    // MARK: - VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up our PageViewController
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier(StoryBoard.PVCstoryboardId) as? UIPageViewController {
            
            pageViewController.dataSource = self
            
            let startVC = viewControllerAtIndex(0)
            var viewControllers = [UIViewController]()
            viewControllers.append(startVC)
            pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
            
            pageViewController.view.frame = CGRectMake(0, 40, view.frame.width, view.frame.size.height - 80)
            
            addChildViewController(pageViewController)
            view.addSubview(pageViewController.view)
            pageViewController.didMoveToParentViewController(self)
            
        }
        
        title = "Chef's Table"
        
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let cvc = viewController as? ChoiceViewController,
            let currIndex = cvc.pageIndex {
                
                var index = currIndex
                
                if index == 0 || index == NSNotFound {
                    return nil
                }
                
                index--
                
                return viewControllerAtIndex(index)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let cvc = viewController as? ChoiceViewController,
            let currIndex = cvc.pageIndex {
                
                var index = currIndex
                
                if index == NSNotFound {
                    return nil
                }
                
                index++
                
                if index == pageChoices.count {
                    return nil
                }
                
                return viewControllerAtIndex(index)
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageChoices.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Private
    
    private struct StoryBoard {
        static let PVCstoryboardId = "PageViewController"
        static let CVCstoryboardId = "ContentViewController"
    }
    
    
    // A helper function for creating content view controller for our page view controller
    
    private func viewControllerAtIndex(index: Int) -> ChoiceViewController {
        if pageChoices.count == 0 || index >= pageChoices.count {
            return ChoiceViewController()
        }
        
        if let cvc = storyboard?.instantiateViewControllerWithIdentifier(StoryBoard.CVCstoryboardId) as? ChoiceViewController {
            
            cvc.managedObjectContext = managedObjectContext
            cvc.pageIndex = index
            cvc.videoId = pageVideoIds[index]
            cvc.intro = pageIntros[index]
            cvc.choice = pageChoices[index]
            
            return cvc
        }
        
        return ChoiceViewController()
    }
    
    
}
