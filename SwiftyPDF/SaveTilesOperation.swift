//
//  SaveTilesOperation.swift
//  SwiftyPDF
//
//  Created by prcela on 16/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class SaveTilesOperation: NSOperation
{
    var image: UIImage
    var pageIdx: Int
    var completion: ((success: Bool)->Void)? = nil
    
    init(image: UIImage, pageIdx: Int) {
        self.image = image
        self.pageIdx = pageIdx
    }
    
    override func main() {
        
        let cachedPagesPath = ImageCreator.cachedPagesPath()
        
        let pageDirPath = "\(cachedPagesPath)/\(pageIdx)"
        
        if !NSFileManager.defaultManager().fileExistsAtPath(pageDirPath)
        {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(pageDirPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
//        let imageData = UIImagePNGRepresentation(UIImage(CGImage: image.CGImage!))
//        let path = "\(cacheDirPath)/\(pageIdx)/big.png"
//        
//        print(path)
//        imageData?.writeToFile(path, atomically: false)
        
        let size = CGSize(width: 256, height: 256)
        
        let cols = image.size.width / size.width
        let rows = image.size.height / size.height
        
        var fullColumns = floor(cols)
        var fullRows = floor(rows)
        
        let remainderWidth = image.size.width - (fullColumns * size.width)
        let remainderHeight = image.size.height - (fullRows * size.height)
        
        
        if (cols > fullColumns) {
            fullColumns++
        }
        if (rows > fullRows) {
            fullRows++
        }
        
        let fullImage = image.CGImage
        
        for (var y = 0; y < Int(fullRows); ++y)
        {
            for (var x = 0; x < Int(fullColumns); ++x)
            {
                var tileSize = size
                if (x + 1 == Int(fullColumns) && remainderWidth > 0) {
                    // Last column
                    tileSize.width = remainderWidth;
                }
                if (y + 1 == Int(fullRows) && remainderHeight > 0) {
                    // Last row
                    tileSize.height = remainderHeight;
                }
                
                let tileImage = CGImageCreateWithImageInRect(fullImage,
                    CGRect(x: CGFloat(x)*size.width, y: CGFloat(y)*size.height,
                        width: tileSize.width, height: tileSize.height))
                
                let imageData = UIImagePNGRepresentation(UIImage(CGImage: tileImage!))
                
                let path = "\(pageDirPath)/\(x)_\(y).png"
                
                print(path)
                imageData?.writeToFile(path, atomically: false)
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.completion?(success: true)
        }
    }

}
