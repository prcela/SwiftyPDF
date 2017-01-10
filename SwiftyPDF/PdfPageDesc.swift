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
    var size: CGSize?

    init(pageIdx: Int)
    {
        self.idx = pageIdx
    }
    
    func placeholderExists() -> Bool
    {
        let path = ImageCreator.cachedPagePath(idx) + "/placeholder.png"
        return FileManager.default.fileExists(atPath: path)
    }
    
    func preparePlaceHolder(_ maxSize: CGSize, completion: @escaping (_ success: Bool)->Void)
    {
        if !placeholderExists()
        {
            ImageCreator.createPlaceHolder(idx, maxSize: maxSize, completion: completion)
        }
    }
    
    func tilesExists() -> Bool
    {
        let path = ImageCreator.cachedPagePath(idx) + "/tiles"
        return FileManager.default.fileExists(atPath: path)
    }
    
    func prepareTiles()
    {
        if !tilesExists()
        {
            ImageCreator.createTiles(idx)
        }
    }
}
