//
//  diyOptionTopLeftView.swift
//  ChefTable
//
//  Created by Yangye Zhu on 12/8/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

@IBDesignable
class diyOptionTopLeftView: UIView {

    @IBInspectable
    var color: UIColor = UIColor.redColor() {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 {
        didSet { setNeedsDisplay() }
    }
    
    
    // Properties for drawing the 5-star
    
    private var starRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2
    }
    
    private var point0: CGPoint {
        return CGPoint(x: starRadius, y: 0)
    }
    
    private var point1: CGPoint {
        return CGPoint(x: starRadius + starRadius * CGFloat(sin(2*M_PI/5)), y: starRadius - starRadius * CGFloat(cos(2*M_PI/5)))
    }
    
    private var point2: CGPoint {
        return CGPoint(x: starRadius + starRadius * CGFloat(sin(M_PI/5)), y: starRadius + starRadius * CGFloat(cos(M_PI/5)))
    }
    
    private var point3: CGPoint {
        return CGPoint(x: starRadius - starRadius * CGFloat(sin(M_PI/5)), y: starRadius + starRadius * CGFloat(cos(M_PI/5)))
    }
    
    private var point4: CGPoint {
        return CGPoint(x: starRadius - starRadius * CGFloat(sin(2*M_PI/5)), y: starRadius - starRadius * CGFloat(cos(2*M_PI/5)))
    }
    
    private var points: [CGPoint] {
        return [point0, point1, point2, point3, point4]
    }
    
    // Utility for drawing the 5-star

    private func pathsForStar(points: [CGPoint]) -> [UIBezierPath] {
        
        var paths = [UIBezierPath]()
        let n = points.count
        
        for i in 0..<n {
            let path = UIBezierPath()
            path.moveToPoint(points[i])
            path.addLineToPoint(points[(i+2)%n])
            path.lineWidth = lineWidth
            paths.append(path)
        }
        
        return paths
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        color.set()
        
        for path in pathsForStar(points) {
            path.stroke()
        }
        
    }
    

}
