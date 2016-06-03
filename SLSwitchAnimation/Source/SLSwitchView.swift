//
//  SLSwitchView.swift
//  SLSwitchAnimation
//
//  Created by silan on 16/5/28.
//  Copyright © 2016年 summer-liu. All rights reserved.
//

import Foundation
import UIKit

class SLSwitchView: UIButton {
    
    var faceLayer: SLFaceLayer!
    var faceBgLayer: CALayer!
    var isAnimating: Bool = false
    
    let margin: CGFloat = 5
    
    var isOn: Bool = false
    
    let onColor = UIColor(red: 73/255.0, green: 182/255.0, blue: 235/255.0, alpha: 1)
    let offColor = UIColor(red: 211/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        self.clipsToBounds = true
        self.backgroundColor = offColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.addTarget(self, action: #selector(SLSwitchView.switchStatus), forControlEvents: .TouchUpInside)
        
        initFaceBgLayer()
        initFaceView()
    }
    
    private func initFaceBgLayer() {
        
        let width = self.frame.size.height - 2 * margin

        faceBgLayer = CALayer()
        
        faceBgLayer.frame = CGRectMake(margin, margin, width, width)
        faceBgLayer.cornerRadius = width / 2
        faceBgLayer.masksToBounds = true
        faceBgLayer.backgroundColor = UIColor.whiteColor().CGColor

        layer.addSublayer(faceBgLayer)
    }
    
    private func initFaceView() {
        
        faceLayer = SLFaceLayer()
        
        faceLayer.frame = faceBgLayer.bounds
        faceLayer.onColor = onColor
        faceLayer.offColor = offColor
        faceLayer.isOn = isOn
        faceLayer.mouthOffset = faceBgLayer.bounds.size.width / 2
        
        faceBgLayer.addSublayer(faceLayer)
        
        faceLayer.setNeedsDisplay()
    }
    
    private func positionOfFaceView(on: Bool) -> CGPoint {
        
        let width = self.frame.size.height - 2 * margin

        if on {
            return CGPointMake(self.frame.size.width - margin - width + width / 2, margin + width / 2)
        } else {
            return CGPointMake(margin + width / 2, margin + width / 2)
        }
    }
    
    func switchStatus() {
        
        guard isAnimating == false else {
            return
        }
        
        isAnimating = true
        
        if isOn {
            moveLeftAnimation()
            
        } else {
            moveRightAnimation()
        }
        
        faceBgLayerAnimation()
        backgroundAnimation()
    }
    
    // MARK: animations
    
    func faceBgLayerAnimation() {
        
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        
        positionAnimation.duration = 0.5
        positionAnimation.fromValue = positionOfFaceView(isOn).x
        positionAnimation.toValue = positionOfFaceView(!isOn).x
        positionAnimation.delegate = self
        positionAnimation.setValue("faceBgLayerAnimation", forKey: "animation")
        positionAnimation.removedOnCompletion = false
        positionAnimation.fillMode = kCAFillModeForwards;

        faceBgLayer.addAnimation(positionAnimation, forKey: "positionAnimation")
    }
    
    // bgColor
    func backgroundAnimation() {
        let backgroundAnimation = CABasicAnimation(keyPath: "backgroundColor")
        
        backgroundAnimation.duration = 0.5
        backgroundAnimation.fromValue = isOn ? onColor.CGColor : offColor.CGColor
        backgroundAnimation.toValue = isOn ? offColor.CGColor : onColor.CGColor
        backgroundAnimation.delegate = self
        backgroundAnimation.setValue("backgroundAnimation", forKey: "animation")
        backgroundAnimation.removedOnCompletion = false
        backgroundAnimation.fillMode = kCAFillModeForwards;
        self.layer.addAnimation(backgroundAnimation, forKey: "background")
    }
    
    func moveRightAnimation() {
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        
        positionAnimation.duration = 0.3
        positionAnimation.fromValue = faceLayer.position.x
        positionAnimation.toValue = faceLayer.position.x + faceLayer.frame.size.width
        positionAnimation.delegate = self
        positionAnimation.setValue("moveAnimation", forKey: "animation")
        positionAnimation.removedOnCompletion = false
        positionAnimation.fillMode = kCAFillModeForwards;
        
        faceLayer.addAnimation(positionAnimation, forKey: "positionAnimation")
    }
    
    func moveLeftAnimation() {
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        
        positionAnimation.duration = 0.3
        positionAnimation.fromValue = faceLayer.position.x
        positionAnimation.toValue = faceLayer.position.x - faceLayer.frame.size.width
        positionAnimation.delegate = self
        positionAnimation.setValue("moveAnimation", forKey: "animation")
        positionAnimation.removedOnCompletion = false
        positionAnimation.fillMode = kCAFillModeForwards;
        
        faceLayer.addAnimation(positionAnimation, forKey: "positionAnimation")
    }
    
    func moveRightBackAnimation() {
        
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        
        animation.duration = 0.5
        animation.values = [faceLayer.position.x - faceLayer.frame.size.width, faceLayer.position.x + faceLayer.frame.size.width / 6, faceLayer.position.x]
        animation.delegate = self
        animation.setValue("moveBackAnimation", forKey: "animation")
        
        faceLayer.addAnimation(animation, forKey: "positionAnimation")
    }
    
    func moveLeftBackAnimation() {
        
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        
        animation.duration = 0.5
        animation.values = [faceLayer.position.x + faceLayer.frame.size.width, faceLayer.position.x - faceLayer.frame.size.width / 6, faceLayer.position.x]
        animation.delegate = self
        animation.setValue("moveBackAnimation", forKey: "animation")
        
        faceLayer.addAnimation(animation, forKey: "positionAnimation")
    }

    func mouthAnimation(on: Bool, offset: CGFloat) {
        
        let animation1 = CABasicAnimation(keyPath: "mouthOffset")
        
        animation1.duration = 0.5
        animation1.fromValue = on ? offset : 0
        animation1.toValue = on ? 0 : offset

        faceLayer.addAnimation(animation1, forKey: "mouthAnimation")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let type = anim.valueForKey("animation") as? String {
                // 脸盘移动到端点
                if type == "faceBgLayerAnimation" {
                    
                    faceBgLayer.removeAllAnimations()
                    faceBgLayer.position = positionOfFaceView(!isOn)
                    
                    faceLayer.isOn = !isOn
                    faceLayer.mouthOffset = !isOn ? faceLayer.bounds.size.width / 2 : 0
                    faceLayer.setNeedsDisplay()
                
                    if (!isOn) {
                        mouthAnimation(isOn, offset: faceLayer.bounds.size.width / 2)
                        moveRightBackAnimation()
                    } else {
                        moveLeftBackAnimation()
                    }
                } else if type == "backgroundAnimation" {
                    
                    self.backgroundColor = isOn ? onColor : offColor
                    
                } else if type == "moveBackAnimation" {
                    
                    faceLayer.removeAllAnimations()

                    isOn = !isOn
                    isAnimating = false
                }
            }
        }
    }
}