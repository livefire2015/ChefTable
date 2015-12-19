//
//  ImageViewController.swift
//  Cassini
//
//  Created by CS193p Instructor on 10/12/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{
    // MARK: - Public Model
    
    var imageData: NSData? {
        didSet { updateUI() }
    }
    
    // MARK: - UI
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.minimumZoomScale = 0.003
            scrollView.maximumZoomScale = 3.0
            scrollView.delegate = self
        }
    }
    
    // MARK: Private Implementation
    
    private func updateUI() {
        image = nil
        
        if let imageData = self.imageData {
            image = UIImage(data: imageData)
        }
        
    }
    
    private var imageView = UIImageView()
    
    // convenience computed var so that we can
    // do ancillary things whenever our image changes
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            scrollViewDidScrollOrZoom = false
            autozoomToFit()
        }
    }
    
    private var scrollViewDidScrollOrZoom = false
    
    private func autozoomToFit() {
        if scrollViewDidScrollOrZoom == false {
            if let scrollv = scrollView {
                if image != nil {
                    scrollv.zoomScale = max(scrollv.bounds.size.width/image!.size.width, scrollv.bounds.size.height/image!.size.height)
                    
                    scrollv.contentOffset = CGPoint(x: (imageView.frame.size.width-scrollv.frame.size.width)/2, y: (imageView.frame.size.height-scrollv.frame.size.height)/2)
                    scrollViewDidScrollOrZoom = false
                }
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    
    
    // MARK: - VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillLayoutSubviews() {  // deal with rotation of screen
        super.viewWillLayoutSubviews()
        autozoomToFit()
    }
    
    override func viewDidLayoutSubviews() {  // deal with rotation of screen
        super.viewDidLayoutSubviews()
        autozoomToFit()
    }
    
}
