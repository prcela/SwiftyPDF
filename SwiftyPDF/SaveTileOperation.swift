//
//  SaveTilesOperation.swift
//  SwiftyPDF
//
//  Created by prcela on 16/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

let pageTilesSavedNotification = "pageTilesSavedNotification"

class SaveTileOperation: Operation
{
    var image: UIImage
    var path: String
    var rect: CGRect
    var pageIdx: Int
    
    weak var tilesQueue: OperationQueue?
    
    init(image: UIImage, path: String, rect: CGRect, pageIdx: Int)
    {
        self.image = image
        self.path = path
        self.rect = rect
        self.pageIdx = pageIdx
    }
    
    override func main() {
        
        let tileImage = image.cgImage?.cropping(to: rect)
        
        let imageData = UIImagePNGRepresentation(UIImage(cgImage: tileImage!))
        
        try? imageData?.write(to: URL(fileURLWithPath: path), options: [])
        
        var ctPageTilesInQueue = 0
        for op in tilesQueue!.operations
        {
            if (op as! SaveTileOperation).pageIdx == self.pageIdx
            {
                ctPageTilesInQueue += 1
            }
        }
        
        print("ctPageTilesInQueue:\(ctPageTilesInQueue) for pageIdx:\(pageIdx)")
        
        // if this was the last one on the page
        if ctPageTilesInQueue <= 1
        {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: pageTilesSavedNotification), object: self.pageIdx)
            }
        }
    }

}
