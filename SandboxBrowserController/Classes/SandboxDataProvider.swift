//
//  SandboxDataProvider.swift
//  SandboxBrowserController
//
//  Created by Mr.Wang on 2020/1/6.
//

import UIKit

class SandboxDataProvider {

    static func getFilesArray(at path: String, complete: @escaping ([SandBoxModel]) -> ()) {
        let fileManager = FileManager.default
        guard let contents = try? fileManager.contentsOfDirectory(atPath: path) else {
            complete([])
            return
        }
        DispatchQueue.global(qos: .background).async {
            var dataArray: [SandBoxModel] = []
            for name in contents {
                var isDirectory = ObjCBool.init(false)
                let filePath = path + "/" + name
                
                guard fileManager.fileExists(atPath: filePath, isDirectory: &isDirectory) else {
                    continue
                }
                
                var model = SandBoxModel()
                model.name = name
                model.path = path
                
                if isDirectory.boolValue {
                    model.size = fileManager.formateSize(size: fileManager.folderSizeAt(path: filePath))
                    model.fileType = .folder
                } else {
                    model.size = fileManager.formateSize(size: fileManager.fileSizeAt(path: filePath))
                    let fileType = URL.init(fileURLWithPath: filePath).pathExtension
                    model.fileType = SandBoxFileType.typeFromTypeString(fileType.lowercased())
                }
                
                if let attr = try? FileManager.default.attributesOfItem(atPath: filePath),
                    let time = attr[FileAttributeKey.creationDate] as? Date {
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    model.createTime = format.string(from: time)
                } else {
                    model.createTime = "未知时间"
                }
                dataArray.append(model)
            }
            
            dataArray.sort(by: { $0.name < $1.name })
            DispatchQueue.main.async {
                complete(dataArray)
            }
        }
    }

}
