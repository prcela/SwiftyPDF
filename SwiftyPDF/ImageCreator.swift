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
    
    class func createPlaceHolder(pdfPage: CGPDFPage, completion: ((success: Bool, image: UIImage)->Void)?)
    {
        let pageRect:CGRect = CGPDFPageGetBoxRect(pdfPage, CGPDFBox.CropBox)
        let op = PdfPageToImageOperation(imageSize: pageRect.size, pdfPage: pdfPage)
        op.completion = completion
        placeholdersQueue.addOperation(op)
    }
    
    class func createThumbnail()
    {
    }

}
