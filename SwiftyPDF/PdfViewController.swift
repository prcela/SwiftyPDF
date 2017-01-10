//
//  ViewController.swift
//  SwiftyPDF
//
//  Created by prcela on 12/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit


class PdfViewController: UIViewController {
    
    var url: URL?
    var pageController: UIPageViewController!
    var currentPageIdx: Int?
    fileprivate var barsHidden = true
    fileprivate var pendingPageIdx: Int?
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumbsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumbsContainerView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PdfViewController.onPageTilesSaved(_:)), name: NSNotification.Name(rawValue: pageTilesSavedNotification), object: nil)
        
    }
    
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let statusBarHeight = Config.prefersStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.size.height
        
        navBarTopConstraint.constant = barsHidden ? -navBar.frame.size.height-statusBarHeight:0
        thumbsBottomConstraint.constant = barsHidden ? -thumbsContainerView.frame.size.height:0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "embed"
        {
            
            pageController = segue.destination as! UIPageViewController
            
            pageController.dataSource = self
            pageController.delegate = self
            
            if PdfDocument.open(url: url!) != nil
            {
                if let pageDesc = PdfDocument.pagesDesc.first
                {
                    let singlePageVC = storyboard!.instantiateViewController(withIdentifier: "pdfPage") as! SinglePageViewController
                    singlePageVC.pageIdx = pageDesc.idx
                    
                    currentPageIdx = singlePageVC.pageIdx
                    
                    pageController.setViewControllers([singlePageVC], direction: .forward, animated: false, completion: nil)
                }
            }
        }
    }
    
    func onPageTilesSaved(_ notification: Notification)
    {
        let pageIdx = notification.object as! Int
        print("Tiles saved for page: \(pageIdx)")
        
        for vc in pageController.viewControllers!
        {
            let singlePageVC = vc as! SinglePageViewController
            if singlePageVC.pageIdx == pageIdx
            {
                singlePageVC.imageScrollView?.tilingView?.setNeedsDisplay()
            }
        }        
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return Config.prefersStatusBarHidden
    }
    
    @IBAction func tap(_ sender: AnyObject)
    {
        barsHidden = !barsHidden
        
        let statusBarHeight = Config.prefersStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.size.height
        
        navBarTopConstraint.constant = barsHidden ? -navBar.frame.size.height-statusBarHeight:0
        thumbsBottomConstraint.constant = barsHidden ? -thumbsContainerView.frame.height:0
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) 
    }

    @IBAction func done(_ sender: AnyObject)
    {
        dismiss(animated: true) {
            PdfDocument.close()
        }
    }
}

extension PdfViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let singlePageVC = viewController as! SinglePageViewController
        if let idx = singlePageVC.pageIdx, idx < PdfDocument.pagesDesc.count-1
        {
            let nextSinglePageVC = storyboard!.instantiateViewController(withIdentifier: "pdfPage") as! SinglePageViewController
            nextSinglePageVC.pageIdx = idx+1
            return nextSinglePageVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let singlePageVC = viewController as! SinglePageViewController
        if let idx = singlePageVC.pageIdx, idx > 1
        {
            let prevSinglePageVC = storyboard!.instantiateViewController(withIdentifier: "pdfPage") as! SinglePageViewController
            prevSinglePageVC.pageIdx = idx-1
            return prevSinglePageVC
        }
        return nil
    }
}

extension PdfViewController: UIPageViewControllerDelegate
{
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        if let vc = pendingViewControllers.last
        {
            pendingPageIdx = (vc as! SinglePageViewController).pageIdx
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if completed
        {
            for previousVC in previousViewControllers
            {
                if let singlePageVC = previousVC as? SinglePageViewController
                {
                    singlePageVC.removeTilingView()
                    
                    if let imageScrollView = singlePageVC.imageScrollView
                    {
                        imageScrollView.zoomScale = imageScrollView.minimumZoomScale
                    }

                }
            }
            
            currentPageIdx = pendingPageIdx
        }
    }
}
