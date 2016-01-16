//
//  ImageCreator.swift
//  SwiftyPDF
//
//  Created by prcela on 15/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class ImageCreator: NSObject
{
    static var placeholdersQueue = NSOperationQueue()
    static var thumbnailsQueue = NSOperationQueue()
    static var bigTilesQueue = NSOperationQueue()
    
    class func createPlaceHolder(pdfPage: CGPDFPage, completion: ((success: Bool, image: UIImage)->Void)?)
    {
        let pageRect:CGRect = CGPDFPageGetBoxRect(pdfPage, CGPDFBox.CropBox)
        print("page rect: \(pageRect)")
        let op = PdfPageToImageOperation(imageSize: pageRect.size, pdfPage: pdfPage)
        op.completion = completion
        placeholdersQueue.addOperation(op)
    }
    
    class func createThumbnail()
    {
    }
    
    class func createBigTiles(pdfPage: CGPDFPage, completion: ((success: Bool)->Void)?)
    {
        let pageRect = CGPDFPageGetBoxRect(pdfPage, CGPDFBox.CropBox)
        let bigSize = CGSize(width: pageRect.size.width*contentSizeMagnifier, height: pageRect.size.height*contentSizeMagnifier)
        let op = PdfPageToImageOperation(imageSize: bigSize, pdfPage: pdfPage)
        op.completion = {(success: Bool, image: UIImage) in
            let pageIdx = CGPDFPageGetPageNumber(pdfPage)
            let op = SaveTilesOperation(image: image, pageIdx: pageIdx)
            bigTilesQueue.addOperation(op)
        }
        bigTilesQueue.addOperation(op)
        
    }

}
