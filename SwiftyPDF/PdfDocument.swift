//
//  PdfDocument.swift
//  SwiftyPDF
//
//  Created by prcela on 20/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class PdfDocument: NSObject
{
    static var doc: CGPDFDocument?
    
    class func open(path path: String) -> CGPDFDocument?
    {
        let docURL = NSURL(fileURLWithPath: path)
        doc = CGPDFDocumentCreateWithURL(docURL)
        return doc
    }
    
    class func getPage(idx: Int) -> CGPDFPage?
    {
        return CGPDFDocumentGetPage(doc, idx)
    }

}
