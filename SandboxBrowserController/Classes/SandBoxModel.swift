//
//  SandBoxModel.swift
//  SandboxBrowserController
//
//  Created by Mr.Wang on 2020/1/6.
//

import UIKit

struct SandBoxModel {
    var name = ""
    var size = ""
    var fileType: SandBoxFileType = .other
    var createTime = ""
    var path = ""
}

extension SandBoxModel: Equatable {
    
    static func == (lhs: SandBoxModel, rhs: SandBoxModel) -> Bool {
        return lhs.path == rhs.path && lhs.name == rhs.name
    }
    
}
