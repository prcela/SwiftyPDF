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
    static var bigQueue = NSOperationQueue()
    static var thumbnailsQueue = NSOperationQueue()
    static var tilesQueue = NSOperationQueue()
    
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
    
    class func createPlaceHolder(pageIdx: Int, maxSize:CGSize, completion: ((success: Bool, image: UIImage)->Void)?)
    {
        guard let pdfPage = PdfDocument.getPage(pageIdx) else {return}
        let pageRect:CGRect = CGPDFPageGetBoxRect(pdfPage, Config.pdfBox)
        print("pdf page rect: \(pageRect)")
        let scaleX = pageRect.size.width/(maxSize.width*UIScreen.mainScreen().scale)
        let scaleY = pageRect.size.height/(maxSize.height*UIScreen.mainScreen().scale)
        let maxScale = max(scaleX,scaleY)
        let placeholderSize = CGSizeMake(pageRect.size.width*maxScale, pageRect.size.height*maxScale)
        print("placeholder size: \(placeholderSize)")
        let op = PdfPageToImageOperation(imageSize: placeholderSize, pageIdx: pageIdx)
        op.completion = completion
        placeholdersQueue.addOperation(op)
    }
    
    class func createThumbnail()
    {
    }
    
    class func createTiles(pageIdx:Int)
    {
        guard let pdfPage = PdfDocument.getPage(pageIdx) else {return}
        
        print("Creating tiles for page \(pageIdx)")

        // Important! If tiles are generating concurently change the logic for knowing when the last page tile is saved
        tilesQueue.maxConcurrentOperationCount = 1
        
        // old ops should have the lower priority than tiles from this page
        for oldTileOp in tilesQueue.operations
        {
            oldTileOp.queuePriority = .Low
        }
        
        let pageRect = CGPDFPageGetBoxRect(pdfPage, Config.pdfBox)
        let scale = Config.pdfSizeMagnifier //* UIScreen.mainScreen().scale
        let bigSize = CGSize(width: pageRect.size.width * scale, height: pageRect.size.height * scale)
        let op = PdfPageToImageOperation(imageSize: bigSize, pageIdx: pageIdx)
        op.completion = {(success: Bool, image: UIImage) in
            
            let cachedPagesPath = ImageCreator.cachedPagesPath()
            
            let pageDirPath = "\(cachedPagesPath)/\(pageIdx)"
            
            if !NSFileManager.defaultManager().fileExistsAtPath(pageDirPath)
            {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(pageDirPath, withIntermediateDirectories: false, attributes: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
            //        let imageData = UIImagePNGRepresentation(UIImage(CGImage: image.CGImage!))
            //        let path = "\(cacheDirPath)/\(pageIdx)/big.png"
            //
            //        print(path)
            //        imageData?.writeToFile(path, atomically: false)
            
            let size = Config.tileSize
            
            let cols = image.size.width / size.width
            let rows = image.size.height / size.height
            
            var fullColumns = floor(cols)
            var fullRows = floor(rows)
            
            let remainderWidth = image.size.width - (fullColumns * size.width)
            let remainderHeight = image.size.height - (fullRows * size.height)
            
            
            if (cols > fullColumns) {
                fullColumns++
            }
            if (rows > fullRows) {
                fullRows++
            }
            
            for (var y = 0; y < Int(fullRows); ++y)
            {
                for (var x = 0; x < Int(fullColumns); ++x)
                {
                    var tileSize = size
                    if (x + 1 == Int(fullColumns) && remainderWidth > 0) {
                        // Last column
                        tileSize.width = remainderWidth;
                    }
                    if (y + 1 == Int(fullRows) && remainderHeight > 0) {
                        // Last row
                        tileSize.height = remainderHeight;
                    }
                    
                    let rect = CGRect(x: CGFloat(x)*size.width, y: CGFloat(y)*size.height,
                        width: tileSize.width, height: tileSize.height)
                    
                    let tilePath = "\(pageDirPath)/\(x)_\(y).png"
                    
                    if !NSFileManager.defaultManager().fileExistsAtPath(tilePath)
                    {
                        let op = SaveTileOperation(image: image, path: tilePath, rect: rect, pageIdx: pageIdx)
                        op.tilesQueue = tilesQueue
                        tilesQueue.addOperation(op)
                    }
                }
            }

        }
        bigQueue.addOperation(op)
    }

}
