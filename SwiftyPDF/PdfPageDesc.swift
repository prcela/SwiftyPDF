//
//  PdfPage.swift
//  SwiftyPDF
//
//  Created by prcela on 15/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class PdfPageDesc: NSObject
{
    var idx: Int

    init(pageIdx: Int)
    {
        self.idx = pageIdx
    }
    
    func placeholderExists() -> Bool
    {
        let path = ImageCreator.cachedPagePath(idx) + "/placeholder.png"
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    func preparePlaceHolder(maxSize: CGSize, completion: (success: Bool)->Void)
    {
        if !placeholderExists()
        {
            ImageCreator.createPlaceHolder(idx, maxSize: maxSize, completion: completion)
        }
    }
    
    func tilesExists() -> Bool
    {
        let path = ImageCreator.cachedPagePath(idx) + "/tiles"
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    func prepareTiles()
    {
        if !tilesExists()
        {
            ImageCreator.createTiles(idx)
        }
    }
}
