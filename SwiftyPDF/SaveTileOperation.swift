//
//  SaveTilesOperation.swift
//  SwiftyPDF
//
//  Created by prcela on 16/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

let pageTilesSavedNotification = "pageTilesSavedNotification"

class SaveTileOperation: NSOperation
{
    var image: UIImage
    var path: String
    var rect: CGRect
    var pageIdx: Int
    
    weak var tilesQueue: NSOperationQueue?
    
    init(image: UIImage, path: String, rect: CGRect, pageIdx: Int)
    {
        self.image = image
        self.path = path
        self.rect = rect
        self.pageIdx = pageIdx
    }
    
    override func main() {
        
        let tileImage = CGImageCreateWithImageInRect(image.CGImage,rect)
        
        let imageData = UIImagePNGRepresentation(UIImage(CGImage: tileImage!))
        
        print(path)
        imageData?.writeToFile(path, atomically: false)
        
        let ctPageTilesInQueue = tilesQueue!.operations.reduce(0) { (sum, op) -> Int in
            if (op as! SaveTileOperation).pageIdx == self.pageIdx
            {
                return sum + 1
            }
            else
            {
                return sum
            }
        }
        
        // if this was the last one on the page
        if ctPageTilesInQueue <= 1
        {
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotificationName(pageTilesSavedNotification, object: self.pageIdx)
            }
        }
    }

}
