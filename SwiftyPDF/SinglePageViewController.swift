//
//  SinglePageViewController.swift
//  SwiftyPDF
//
//  Created by prcela on 14/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class SinglePageViewController: UIViewController {
    
    @IBOutlet weak var imageScrollView: ImageScrollView?
    
    weak var placeholder: UIImage? {
        didSet {
            refreshTiledImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView?.layoutIfNeeded()
        
        refreshTiledImage()
    }
    
    private func refreshTiledImage()
    {
        if let p = placeholder
        {
            let contentSizeMagnifier:CGFloat = 3
            let imageContentSize = CGSize(width: contentSizeMagnifier*p.size.width, height: contentSizeMagnifier*p.size.height)
            imageScrollView?.displayTiledImage(p, imageContentSize: imageContentSize)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SinglePageViewController: UIScrollViewDelegate
{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageScrollView!.zoomImageView
    }
}
