//
//  UIImageEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/7/9.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
import CommonCrypto

extension UIImage {
    static func createPlaceHolderImage(image : UIImage?, imageView : UIImageView) -> UIImage?{
        imageView.layoutIfNeeded()
        guard let image = image else {
            return nil
        }
        let name = image.md5
        let imageName = "placeHolder_\(imageView.bounds.size.width)_\(imageView.bounds.size.height)_\(name).png"
        let fileManager = FileManager.default
        let path : String = NSHomeDirectory() + "/Documents/PlaceHolder/"
        let filePath = path + imageName
        if fileManager.fileExists(atPath: filePath) {
            guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
                else { return nil }
            let image = UIImage.init(data: data)
            return image
        }
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setFillColor(UIColor.clear.cgColor)
            ctx.fill(CGRect(origin: CGPoint.zero, size: imageView.bounds.size))
            
            let placeholderRect = CGRect(x: (imageView.bounds.size.width - image.size.width) / 2.0,
                                         y: (imageView.bounds.size.height - image.size.height) / 2.0,
                                         width: image.size.width,
                                         height: image.size.height)
            
            ctx.saveGState()
            ctx.translateBy(x: placeholderRect.origin.x, y: placeholderRect.origin.y)
            ctx.translateBy(x: 0, y: placeholderRect.size.height)
            ctx.scaleBy(x: 1.0, y: -1.0)
            ctx.translateBy(x: -placeholderRect.origin.x, y: -placeholderRect.origin.y)
            ctx.draw(image.cgImage!, in: placeholderRect, byTiling: false)
            ctx.restoreGState()
        }
        
        if let placeHolder = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            try? fileManager.createDirectory(at: URL.init(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
            fileManager.createFile(atPath: filePath, contents: placeHolder.pngData(), attributes: nil)
            return placeHolder
        }
        UIGraphicsEndImageContext()
        return nil
    }
    
    var md5: String {
        let data = Data(self.pngData()!)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
