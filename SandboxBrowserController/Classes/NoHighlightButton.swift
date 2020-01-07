//
//  NoHighlightButton.swift
//  SandboxBrowserController
//
//  Created by Mr.Wang on 2020/1/6.
//

import UIKit

class NoHighlightButton: UIButton {
    
    override var isHighlighted: Bool {
        set { }
        get { return false }
    }
    
}
