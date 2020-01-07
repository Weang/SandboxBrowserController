//
//  SandBoxFileType.swift
//  SandboxBrowserController
//
//  Created by Mr.Wang on 2020/1/6.
//

import UIKit

enum SandBoxFileType {
    
    case folder
    case image
    case video
    case sound
    case pdf
    case txt
    case zip
    case office
    case other
    
    var image: UIImage? {
        switch self {
        case .folder: return BundleHelper.imageNamed("file_foder") 
        case .image: return BundleHelper.imageNamed("file_pic")
        case .video: return BundleHelper.imageNamed("file_video")
        case .sound: return BundleHelper.imageNamed("file_sound")
        case .pdf: return BundleHelper.imageNamed("file_pdf")
        case .txt: return BundleHelper.imageNamed("file_txt")
        case .zip: return BundleHelper.imageNamed("file_zip")
        case .office: return BundleHelper.imageNamed("file_office")
        case .other: return BundleHelper.imageNamed("file_other")
        }
    }
    
    static func typeFromTypeString(_ string: String) -> SandBoxFileType {
        switch string {
        case "png", "jpg", "jpeg", "gif", "bmp":
            return .image
        case "mp3", "wav", "cd", "ogg", "midi", "amr", "m4a", "aac", "m4r":
            return .sound
        case "mp4", "mov":
            return .video
        case "txt":
            return .txt
        case "pdf":
            return .pdf
        case "zip":
            return .zip
        case "xls", "doc", "ppt", "docx", "xlsx", "pptx":
            return .office
        default:
            return .other
        }
    }
    
}
