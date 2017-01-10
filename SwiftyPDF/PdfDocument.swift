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
    
    class func open(url: URL) -> CGPDFDocument?
    {
        ImageCreator.clearCachedFiles()
        pagesDesc.removeAll()

        doc = CGPDFDocument(url as CFURL)
        

        let ctPages = doc?.numberOfPages
        for idx in 1...ctPages!
        {
            let pageDesc = PdfPageDesc(pageIdx: idx)
            pagesDesc.append(pageDesc)
        }

        return doc
    }
    
    class func close()
    {
        doc = nil
        ImageCreator.clearCachedFiles()
        pagesDesc.removeAll()

    }
    
    class func getPage(_ idx: Int) -> CGPDFPage?
    {
        return doc?.page(at: idx)
    }
    
    class func getPageSize(_ idx: Int) -> CGSize
    {
        // getting document page is expensive operation, so we are caching the page size
        if let pageDesc = getPageDesc(idx)
        {
            if let pageSize = pageDesc.size
            {
                return pageSize
            }
            else
            {
                pageDesc.size = getPage(idx)?.getBoxRect(Config.pdfBox).size
                return pageDesc.size!
            }
        }
        
        return CGSize.zero
    }
    
    class func getPageDesc(_ idx: Int) -> PdfPageDesc?
    {
        return pagesDesc[idx-1]
    }

}
