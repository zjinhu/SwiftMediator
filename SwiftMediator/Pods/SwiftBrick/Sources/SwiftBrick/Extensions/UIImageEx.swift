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
        let name = image.sha256
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
    
//    var md5: String {
//        let data = Data(self.pngData()!)
//        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
//            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
//            return hash
//        }
//        return hash.map { String(format: "%02x", $0) }.joined()
//    }
    
    var sha256: String {
        let data = Data(self.pngData()!)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.reduce("") { $0 + String(format:"%02x", $1) }
    }

}

class CountedColor {
  let color: UIColor
  let count: Int
  
  init(color: UIColor, count: Int) {
    self.color = color
    self.count = count
  }
}


extension UIImage {
  fileprivate func resize(to newSize: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 2)
    draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return result!
  }
  ///取图片色系 background背景色 primary主色调 secondary次要颜色 detail内容颜色
  public func colors(scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
    let cgImage: CGImage
    
    if let scaleDownSize = scaleDownSize {
      cgImage = resize(to: scaleDownSize).cgImage!
    } else {
      let ratio = size.width / size.height
      let r_width: CGFloat = 250
      cgImage = resize(to: CGSize(width: r_width, height: r_width / ratio)).cgImage!
    }
    
    let width = cgImage.width
    let height = cgImage.height
    let bytesPerPixel = 4
    let bytesPerRow = width * bytesPerPixel
    let bitsPerComponent = 8
    let randomColorsThreshold = Int(CGFloat(height) * 0.01)
    let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let raw = malloc(bytesPerRow * height)
    let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
    let context = CGContext(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
    context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
    let data = UnsafePointer<UInt8>(context?.data?.assumingMemoryBound(to: UInt8.self))
    let imageBackgroundColors = NSCountedSet(capacity: height)
    let imageColors = NSCountedSet(capacity: width * height)
    
    let sortComparator: (CountedColor, CountedColor) -> Bool = { (a, b) -> Bool in
      return a.count <= b.count
    }
    
    for x in 0..<width {
      for y in 0..<height {
        let pixel = ((width * y) + x) * bytesPerPixel
        let color = UIColor(
          red:   CGFloat((data?[pixel+1])!) / 255,
          green: CGFloat((data?[pixel+2])!) / 255,
          blue:  CGFloat((data?[pixel+3])!) / 255,
          alpha: 1
        )
        
        if x >= 5 && x <= 10 {
          imageBackgroundColors.add(color)
        }
        
        imageColors.add(color)
      }
    }
    
    var sortedColors = [CountedColor]()
    
    for color in imageBackgroundColors {
      guard let color = color as? UIColor else { continue }
      
      let colorCount = imageBackgroundColors.count(for: color)
      
      if randomColorsThreshold <= colorCount  {
        sortedColors.append(CountedColor(color: color, count: colorCount))
      }
    }
    
    sortedColors.sort(by: sortComparator)
    
    var proposedEdgeColor = CountedColor(color: blackColor, count: 1)
    
    if let first = sortedColors.first { proposedEdgeColor = first }
    
    if proposedEdgeColor.color.isBlackOrWhite && !sortedColors.isEmpty {
      for countedColor in sortedColors where CGFloat(countedColor.count / proposedEdgeColor.count) > 0.3 {
        if !countedColor.color.isBlackOrWhite {
          proposedEdgeColor = countedColor
          break
        }
      }
    }
    
    let imageBackgroundColor = proposedEdgeColor.color
    let isDarkBackgound = imageBackgroundColor.isDark
    
    sortedColors.removeAll()
    
    for imageColor in imageColors {
      guard let imageColor = imageColor as? UIColor else { continue }
      
      let color = imageColor.color(minSaturation: 0.15)
      
      if color.isDark == !isDarkBackgound {
        let colorCount = imageColors.count(for: color)
        sortedColors.append(CountedColor(color: color, count: colorCount))
      }
    }
    
    sortedColors.sort(by: sortComparator)
    
    var primaryColor, secondaryColor, detailColor: UIColor?
    
    for countedColor in sortedColors {
      let color = countedColor.color
      
      if primaryColor == nil &&
        color.isContrasting(with: imageBackgroundColor) {
        primaryColor = color
      } else if secondaryColor == nil &&
        primaryColor != nil &&
        primaryColor!.isDistinct(from: color) &&
        color.isContrasting(with: imageBackgroundColor) {
        secondaryColor = color
      } else if secondaryColor != nil &&
        (secondaryColor!.isDistinct(from: color) &&
          primaryColor!.isDistinct(from: color) &&
          color.isContrasting(with: imageBackgroundColor)) {
        detailColor = color
        break
      }
    }
    
    free(raw)
    
    return (
      imageBackgroundColor,
      primaryColor   ?? (isDarkBackgound ? whiteColor : blackColor),
      secondaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
      detailColor    ?? (isDarkBackgound ? whiteColor : blackColor))
  }
  ///取图片上一点颜色
  public func color(at point: CGPoint, completion: @escaping (UIColor?) -> Void) {
    let size = self.size
    let cgImage = self.cgImage
    
    DispatchQueue.global(qos: .userInteractive).async {
      let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      guard let imgRef = cgImage,
        let dataProvider = imgRef.dataProvider,
        let dataCopy = dataProvider.data,
        let data = CFDataGetBytePtr(dataCopy), rect.contains(point) else {
          DispatchQueue.main.async {
            completion(nil)
          }
          return
      }
      
      let pixelInfo = (Int(size.width) * Int(point.y) + Int(point.x)) * 4
      let red = CGFloat(data[pixelInfo]) / 255.0
      let green = CGFloat(data[pixelInfo + 1]) / 255.0
      let blue = CGFloat(data[pixelInfo + 2]) / 255.0
      let alpha = CGFloat(data[pixelInfo + 3]) / 255.0
      
      DispatchQueue.main.async {
        completion(UIColor(red: red, green: green, blue: blue, alpha: alpha))
      }
    }
  }
}
