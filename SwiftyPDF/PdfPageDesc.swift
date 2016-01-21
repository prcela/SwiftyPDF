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
        let path = ImageCreator.pageDirPath(idx) + "/placeholder.png"
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    func createPlaceHolder(maxSize: CGSize, completion: (success: Bool)->Void)
    {
        ImageCreator.createPlaceHolder(idx, maxSize: maxSize, completion: completion)
    }
    
    func createTiles()
    {
        ImageCreator.createTiles(idx)
    }
}
