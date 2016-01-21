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
    static var pagesDesc = [PdfPageDesc]()
    
    class func open(path path: String) -> CGPDFDocument?
    {
        let docURL = NSURL(fileURLWithPath: path)
        doc = CGPDFDocumentCreateWithURL(docURL)

        let ctPages = CGPDFDocumentGetNumberOfPages(doc)
        for idx in 1...ctPages
        {
            let pageDesc = PdfPageDesc(pageIdx: idx)
            pagesDesc.append(pageDesc)
        }

        return doc
    }
    
    class func getPage(idx: Int) -> CGPDFPage?
    {
        return CGPDFDocumentGetPage(doc, idx)
    }
    
    class func getPageDesc(idx: Int) -> PdfPageDesc?
    {
        return pagesDesc[idx-1]
    }

}
