//
//  FileManager+Extension.swift
//  SandboxBrowserController
//
//  Created by Mr.Wang on 2020/1/6.
//

import UIKit

extension FileManager {

    func folderSizeAt(path: String) -> Double {
        let manager = FileManager.default
        guard manager.fileExists(atPath: path),
            let childFilePath = manager.subpaths(atPath: path) else {
                return 0
        }
        return childFilePath.reduce(0) { (size, subPath) -> Double in
            let fileAbsoluePath = path + "/" + subPath
            return fileSizeAt(path: fileAbsoluePath) + size
        }
    }
    
    func fileSizeAt(path: String) -> Double {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: path) else {
            return 0
        }
        let dict = attributes as NSDictionary
        let fileSize = dict.fileSize()
        return Double(fileSize) / 1000
    }

    func formateSize(size: Double) -> String {
        if size < 1000 {
            return String.init(format: "%.0f B",  size)
        } else if size < 1000 * 1000 {
            return String.init(format: "%.1f K",  size / 1000)
        } else if size < 1000 * 1000 * 1000 {
            return String.init(format: "%.1f M",  size / (1000 * 1000))
        } else {
            return String.init(format: "%.1f G",  size / (1000 * 1000 * 1000))
        }
    }
}
