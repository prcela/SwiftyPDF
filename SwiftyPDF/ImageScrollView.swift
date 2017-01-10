//
//  ImageScrollView.swift
//  SwiftyPDF
//
//  Created by prcela on 16/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView
{
    var zoomImageView: UIImageView?
    var tilingView: TilingView?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    
        // center the zoom view as it becomes smaller than the size of the screen
        
        if var frameToCenter = zoomImageView?.frame
        {
            let boundsSize = bounds.size
        
            // center horizontally
            if (frameToCenter.size.width < boundsSize.width) {
                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
            }
            else
            {
                frameToCenter.origin.x = 0;
            }
            
            // center vertically
            if (frameToCenter.size.height < boundsSize.height)
            {
                frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
            }
            else
            {
                frameToCenter.origin.y = 0;
            }
            
            zoomImageView!.frame = frameToCenter
        }
    }
    
    func displayZoomImage(_ image: UIImage, imageContentSize: CGSize)
    {
        guard zoomImageView == nil else {return}
        
        // reset our zoomScale to 1.0 before doing any further calculations
        self.zoomScale = 1.0
        
        // make views to display the new image
        zoomImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: imageContentSize))
        zoomImageView!.image = image
        addSubview(zoomImageView!)

        configureForImageSize(imageContentSize)
    }
    
    func displayTiledImages(_ pageIdx: Int)
    {
        guard zoomImageView != nil else {return}
        
        if tilingView == nil
        {
            tilingView = TilingView(frame: zoomImageView!.bounds)
            tilingView!.pageIdx = pageIdx
            zoomImageView?.addSubview(tilingView!)
        }
        else
        {
            tilingView!.setNeedsDisplay()
        }
    }
    
    func configureForImageSize(_ imageContentSize: CGSize)
    {
        print("image content size: \(imageContentSize)")
        contentSize = imageContentSize
        setMaxMinZoomScalesForCurrentBounds()
        zoomScale = minimumZoomScale
    }
    
    func setMaxMinZoomScalesForCurrentBounds()
    {
        let boundsSize = bounds.size
        
        // calculate min/max zoomscale
        let xScale = boundsSize.width  / contentSize.width    // the scale needed to perfectly fit the image width-wise
        let yScale = boundsSize.height / contentSize.height   // the scale needed to perfectly fit the image height-wise
        
        // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
        let imagePortrait = contentSize.height > contentSize.width
        let phonePortrait = boundsSize.height > boundsSize.width
        var minScale = imagePortrait == phonePortrait ? xScale : min(xScale, yScale)
        
        // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
        // maximum zoom scale to 0.5.
        // Added bounce zoom that will enable zooming even more the content size is.
        let maxScale = Config.extraZoom / UIScreen.main.scale
        
        // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
        if (minScale > maxScale) {
            minScale = maxScale;
        }
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale

    }

}
