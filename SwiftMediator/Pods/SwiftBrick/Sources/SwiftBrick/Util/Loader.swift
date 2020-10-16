//
//  JHImageLoader.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit

extension Bundle {
    
    #if !ENABLE_SPM
    private class _BundleClass { }
    #endif
    
    static var current: Bundle {
        #if ENABLE_SPM
        return Bundle.module
        #else
        return Bundle(for: _BundleClass.self)
        #endif
    }
}

public struct L{
    
    static var bundle: Bundle = {
        let path = Bundle.current.path(forResource: "SwiftBrick", ofType: "bundle", inDirectory: nil)
        let bundle = Bundle(path: path ?? "")
        return bundle ?? Bundle.current
    }()
    
    public static func image(_ named: String) -> UIImage {
        guard let image = UIImage(named: named, in: bundle, compatibleWith: nil) else {
            let image = UIImage(named: named)
            return image ?? UIImage()
        }
        return image
    }
    
    public static func color(_ named: String) -> UIColor {
        guard let color = UIColor(named: named, in: bundle, compatibleWith: nil) else {
            return UIColor.init(named: named) ?? UIColor.clear
        }
        return color
    }
}
