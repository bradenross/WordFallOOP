//
//  ScreenSettings.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/14/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import UIKit
import SpriteKit

public extension SKScene{
    
    func deviceSize(scene: SKScene) {
        let device = UIDevice.current.modelName
        
        
        
        switch device {
        case "iPhone SE", "iPod Touch 5", "iPod Touch 6": scene.size = CGSize(width: 640, height: 1136)
        case "iPhone 6", "iPhone 6s", "iPhone 7", "iPhone 8": scene.size = CGSize(width: 750, height: 1334)
        case "iPhone 6 Plus", "iPhone 6s Plus", "iPhone 7 Plus", "iPhone 8 Plus": scene.size = CGSize(width: 720, height: 1280)
        case "iPhone X", "iPhone XS": scene.size = CGSize(width: 750, height: 1624)
        case "iPhone XR", "iPhone 11": scene.size = CGSize(width: 828, height: 1792)
        case "iPhone XS Max": scene.size = CGSize(width: 828, height: 1792)
        case "iPhone 11 Pro", "iPhone 11 Pro Max": scene.size = CGSize(width: 828, height: 1792)
        default: scene.size = CGSize(width: 720, height: 1280)
            
        }
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        default:                                        return identifier
        }
    }
    
}
