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
    var placeholder: UIImage?
    var idx: Int

    init(pageIdx: Int)
    {
        self.idx = pageIdx
    }
    
    func createPlaceHolder(maxSize: CGSize, completion: (success: Bool)->Void)
    {
        ImageCreator.createPlaceHolder(idx, maxSize: maxSize) { (success: Bool, image: UIImage) in
            self.placeholder = image
            completion(success: success)
        }
    }
    
    func createTiles()
    {
        ImageCreator.createTiles(idx)
    }
}
