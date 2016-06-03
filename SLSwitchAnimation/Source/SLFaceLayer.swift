//
//  SLFaceLayer.swift
//  SLSwitchAnimation
//
//  Created by silan on 16/5/28.
//  Copyright © 2016年 summer-liu. All rights reserved.
//

import Foundation
import UIKit

// my face like this: - -
//                     -
class SLFaceLayer: CALayer {
    
    private let leftEyeXRatio: CGFloat = 0.2
    
    var isOn: Bool = true   
    
    // when isOn is ture, mouthOffset = mouthLength
    var mouthOffset: CGFloat = 0
    var onColor: UIColor?
    var offColor: UIColor?
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LeftEye
    private func leftEyeOrigin() -> CGPoint {
        return CGPointMake(self.frame.size.width * leftEyeXRatio, self.frame.size.height / 4)
    }
    
    private func leftEyePath() -> UIBezierPath {
        let origin = leftEyeOrigin()
        let size = eyeSize()
        let path = UIBezierPath(ovalInRect: CGRectMake(origin.x, origin.y, size.width, size.height))
        
        return path
    }
    
    // MARK: RightEye
    private func rightEyeOrigin() -> CGPoint {
        return CGPointMake(self.frame.size.width * (1 - leftEyeXRatio) - eyeSize().width, self.frame.size.height / 4)
    }
    
    private func rightEyePath() -> UIBezierPath {
        let origin = rightEyeOrigin()
        let size = eyeSize()
        let path = UIBezierPath(ovalInRect: CGRectMake(origin.x, origin.y, size.width, size.height))
        
        return path
    }
    
    private func eyeSize() -> CGSize {
        return CGSizeMake(self.frame.size.width / 6, self.frame.size.height / 4) ;
    }
    
    // MARK: Mouth
    private func mouthLenth() -> CGFloat {
        return self.frame.size.width / 2;
    }
    
    private func mouthY() -> CGFloat {
        return self.frame.size.height * 0.7;
    }
    
    private func mouthRect() -> CGRect {
        let rect = CGRectMake((self.frame.size.width - mouthLenth()) / 2, mouthY(), mouthLenth(), self.frame.size.height * 0.1)
        return rect
    }
    
    private func mouthPath() -> UIBezierPath {
        
        if isOn {
            let path = UIBezierPath()

            path.moveToPoint(CGPointMake(mouthRect().origin.x, mouthRect().origin.y))
            path.addCurveToPoint(CGPointMake(mouthLenth() + mouthRect().origin.x, mouthY()), controlPoint1: CGPointMake(mouthRect().origin.x + mouthOffset / 4, mouthY() + mouthOffset / 2),
                                 controlPoint2: CGPointMake(mouthRect().origin.x + mouthOffset * 3 / 4, mouthY() + mouthOffset / 2))
            path.closePath()
            
            return path
        } else {
            let path = UIBezierPath(rect: mouthRect())
            return path
        }
    }
    
    private func color() -> UIColor {
        if isOn {
            if let onColor = onColor {
                return onColor
            }
            
            return UIColor(red: 73/255.0, green: 182/255.0, blue: 235/255.0, alpha: 1)
        } else {
            if let offColor = offColor {
                return offColor
            }
            
            return UIColor(red: 211/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1)
        }
    }
    
    // MARK: draw
    override func drawInContext(ctx: CGContext) {
        
        let bezierLeft = leftEyePath()
        let bezierRight = rightEyePath()
        let bezierMouth = mouthPath()
        
        CGContextAddPath(ctx, bezierLeft.CGPath)
        CGContextAddPath(ctx, bezierRight.CGPath)
        CGContextAddPath(ctx, bezierMouth.CGPath)
        CGContextSetFillColorWithColor(ctx, color().CGColor)
        CGContextSetStrokeColorWithColor(ctx, UIColor.clearColor().CGColor)
        CGContextFillPath(ctx)
    }

    internal override class func needsDisplayForKey(key: String) -> Bool {
        if key == "mouthOffset" {
            return true
        }
        
        return super.needsDisplayForKey(key)
    }
}