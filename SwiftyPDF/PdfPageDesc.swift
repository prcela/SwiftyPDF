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
    var viewController: SinglePageViewController?
    var placeholder: UIImage?
    var pdfPage: CGPDFPage

    init(pdfPage: CGPDFPage)
    {
        self.pdfPage = pdfPage
    }
    
    func createPlaceHolder()
    {
        ImageCreator.createPlaceHolder(pdfPage) { (success: Bool, image: UIImage) in
            self.placeholder = image
            self.viewController?.displayZoomImage()
        }
    }
    
    func createTiles()
    {
        ImageCreator.createTiles(pdfPage)
    }
}
