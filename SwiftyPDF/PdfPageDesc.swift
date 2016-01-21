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
    weak var viewController: SinglePageViewController?
    var placeholder: UIImage?
    var idx: Int

    init(pageIdx: Int)
    {
        self.idx = pageIdx
    }
    
    func createPlaceHolder()
    {
        ImageCreator.createPlaceHolder(idx) { (success: Bool, image: UIImage) in
            self.placeholder = image
            self.viewController?.displayZoomImage()
        }
    }
    
    func createTiles()
    {
        ImageCreator.createTiles(idx)
    }
}
