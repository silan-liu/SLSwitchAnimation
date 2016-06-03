//
//  ViewController.swift
//  SLSwitchAnimation
//
//  Created by silan on 16/5/28.
//  Copyright © 2016年 summer-liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let smallSwitch = SLSwitchView(frame: CGRectMake(100, 200, 100, 40))
        view.addSubview(smallSwitch)

        let bigSwitch = SLSwitchView(frame: CGRectMake(100, 300, 200, 90))
        view.addSubview(bigSwitch)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

