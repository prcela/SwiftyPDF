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
}
