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
    static var placeholdersQueue = OperationQueue()
    static var bigQueue = OperationQueue()
    static var thumbnailsQueue = OperationQueue()
    static var tilesQueue = OperationQueue()
    
    fileprivate class func assureDirPathExists(_ path: String)
    {
        if !FileManager.default.fileExists(atPath: path)
        {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    class func cachedPagesPath() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let pagesPath = "\(paths.first!)/pages"
        
        assureDirPathExists(pagesPath)
        
        return pagesPath
    }
    
    class func cachedPagePath(_ pageIdx: Int) -> String
    {
        let path = "\(cachedPagesPath())/\(pageIdx)"
        
        assureDirPathExists(path)
        return path
    }
    
    class func cachedTilesPath(_ pageIdx: Int) -> String
    {
        let path = "\(cachedPagePath(pageIdx))/tiles"
        
        assureDirPathExists(path)
        return path

    }
    
    class func clearCachedFiles()
    {
        let fm = FileManager.default
        do {
            let cachedPath = cachedPagesPath()
            let paths = try fm.contentsOfDirectory(atPath: cachedPath)
            for path in paths
            {
                try fm.removeItem(atPath: "\(cachedPath)/\(path)")
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    class func createPlaceHolder(_ pageIdx: Int, maxSize:CGSize, completion: @escaping (_ success: Bool)->Void)
    {
        let pageSize = PdfDocument.getPageSize(pageIdx)
        print("pdf page size: \(pageSize)")
        let scaleX = pageSize.width/(maxSize.width*UIScreen.main.scale)
        let scaleY = pageSize.height/(maxSize.height*UIScreen.main.scale)
        let maxScale = max(scaleX,scaleY)
        let placeholderSize = CGSize(width: pageSize.width/maxScale, height: pageSize.height/maxScale)
        print("placeholder size: \(placeholderSize)")
        let op = PdfPageToImageOperation(imageSize: placeholderSize, pageIdx: pageIdx)
        op.completion = {success, image in
            
            let pagePath = ImageCreator.cachedPagePath(pageIdx)
            
            let imageData = UIImagePNGRepresentation(image)
            let path = "\(pagePath)/placeholder.png"
            try? imageData?.write(to: URL(fileURLWithPath: path), options: [])
            print("placeholder created for page \(pageIdx)")
            completion(success)
        }
        placeholdersQueue.addOperation(op)
    }
    
    class func createThumbnail()
    {
    }
    
    class func createTiles(_ pageIdx:Int)
    {
        
        print("Creating tiles for page \(pageIdx)")

        // Important! If tiles are generating concurently change the logic for knowing when the last page tile is saved
        tilesQueue.maxConcurrentOperationCount = 1
        
        // old ops should have the lower priority than tiles from this page
        for oldTileOp in tilesQueue.operations
        {
            oldTileOp.queuePriority = .low
        }
        
        let pageSize = PdfDocument.getPageSize(pageIdx)
        let scale = Config.pdfSizeMagnifier //* UIScreen.mainScreen().scale
        let bigSize = CGSize(width: pageSize.width * scale, height: pageSize.height * scale)
        let op = PdfPageToImageOperation(imageSize: bigSize, pageIdx: pageIdx)
        op.completion = {(success: Bool, image: UIImage) in
            
            let tilesPath = ImageCreator.cachedTilesPath(pageIdx)
            
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
                fullColumns += 1
            }
            if (rows > fullRows) {
                fullRows += 1
            }
            
            for y in 0..<Int(fullRows) {
                for x in 0..<Int(fullColumns) {
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
                    
                    let tilePath = "\(tilesPath)/\(x)_\(y).png"
                    
                    if !FileManager.default.fileExists(atPath: tilePath)
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
