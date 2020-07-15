//
//  JHImageLoader.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit

public class L{
    static var bundle: Bundle = {
        let path = Bundle(for: L.self).path(forResource: "SwiftBrick", ofType: "bundle", inDirectory: nil)
        let bundle = Bundle(path: path ?? "")
        return bundle ?? Bundle(for: L.self)
    }()
    
    public static func image(_ named: String) -> UIImage {
        guard let image = UIImage(named: named, in: bundle, compatibleWith: nil) else {
            return UIImage(named: named) ?? UIImage()
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
