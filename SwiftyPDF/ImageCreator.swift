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
    
    class func cachedPagesPath() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let pagesPath = "\(paths.first!)/pages"
        
        if !NSFileManager.defaultManager().fileExistsAtPath(pagesPath)
        {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(pagesPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        return pagesPath
    }
    
    class func clearCachedFiles()
    {
        let fm = NSFileManager.defaultManager()
        do {
            let cachedPath = cachedPagesPath()
            let paths = try fm.contentsOfDirectoryAtPath(cachedPath)
            for path in paths
            {
                try fm.removeItemAtPath("\(cachedPath)/\(path)")
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
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
        let mag = Config.contentSizeMagnifier
        let bigSize = CGSize(width: pageRect.size.width * mag, height: pageRect.size.height * mag)
        let op = PdfPageToImageOperation(imageSize: bigSize, pdfPage: pdfPage)
        op.completion = {(success: Bool, image: UIImage) in
            let pageIdx = CGPDFPageGetPageNumber(pdfPage)
            let op = SaveTilesOperation(image: image, pageIdx: pageIdx)
            op.completion = completion
            bigTilesQueue.addOperation(op)
        }
        bigTilesQueue.addOperation(op)
        
    }

}
