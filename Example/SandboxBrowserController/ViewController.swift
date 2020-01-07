//
//  ViewController.swift
//  SandboxBrowserController
//
//  Created by w704444178@qq.com on 01/06/2020.
//  Copyright (c) 2020 w704444178@qq.com. All rights reserved.
//

import UIKit
import SandboxBrowserController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.present(UINavigationController.init(rootViewController: SandboxBrowserController.init(path: NSHomeDirectory(), name: "")), animated: true, completion: nil)
    }

}

