//
//  TestLayer.swift
//  SLSwitchAnimation
//
//  Created by silan on 16/5/29.
//  Copyright © 2016年 summer-liu. All rights reserved.
//

import Foundation
import UIKit

class TestLayer: CALayer {
    var progress: CGFloat = 0
    var mouthOffset: CGFloat = 0
    
    override func drawInContext(ctx: CGContext) {
        
        CGContextSetLineWidth(ctx, 2)
        CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor)
        CGContextAddArc(ctx, self.bounds.size.width / 2, self.bounds.size.height / 2, 10, 0, CGFloat(M_PI) * progress, 0)
        CGContextStrokePath(ctx)
        
        let bezierMouth = path()

        CGContextAddPath(ctx, bezierMouth.CGPath)
        CGContextFillPath(ctx)
    }
    
    internal override class func needsDisplayForKey(key: String) -> Bool {
        if key == "progress" {
            return true
        } else if key == "mouthOffset" {
            return true
        }
        
        return super.needsDisplayForKey(key)
    }
    
    func path() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointZero)
        
        path.addCurveToPoint(CGPointMake(20, 0), controlPoint1: CGPointMake(mouthOffset / 4, mouthOffset / 2), controlPoint2: CGPointMake(mouthOffset * 3 / 4, mouthOffset / 2))
        
        path.closePath()
        
        return path
    }
    
    func startAnimation() {
        let animation = CABasicAnimation(keyPath: "progress")
        
        animation.duration = 2
        animation.fromValue = 0
        animation.toValue = 1
        animation.removedOnCompletion = false
        
        let animation1 = CABasicAnimation(keyPath: "mouthOffset")
        
        animation1.duration = 2
        animation1.fromValue = 0
        animation1.toValue = 20
        animation1.removedOnCompletion = false
        
        self.addAnimation(animation, forKey: "11")
        self.addAnimation(animation1, forKey: "11")

    }
}