//
//  ViewController.swift
//  SwiftyPDF
//
//  Created by prcela on 12/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pageController: UIPageViewController!
    var viewControllers = [SinglePageViewController?]()
    var currentPageIdx: Int?
    private var pendingPageIdx: Int?
    var doc: CGPDFDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func document() -> CGPDFDocument?
    {
        if(doc == nil)
        {
            let path = NSBundle.mainBundle().pathForResource("sample", ofType: "pdf")!
            let docURL = NSURL(fileURLWithPath: path)
            doc = CGPDFDocumentCreateWithURL(docURL)
            
            let ctPages = CGPDFDocumentGetNumberOfPages(doc)
            for _ in 1...ctPages
            {
                viewControllers.append(nil)
            }
        }
        return doc
    }
    
    private func pageIndexOfViewController(viewController: UIViewController) -> Int?
    {
        for (idx,vc) in viewControllers.enumerate()
        {
            if vc == viewController
            {
                return idx
            }
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "embed"
        {
            
            pageController = segue.destinationViewController as! UIPageViewController
            
            pageController.dataSource = self
            pageController.delegate = self
            
            document()
            if viewControllers[0] == nil
            {
                let vc = storyboard!.instantiateViewControllerWithIdentifier("pdfPage") as! SinglePageViewController
                viewControllers[0] = vc
            }
            
            pageController.setViewControllers([viewControllers[0]!], direction: .Forward, animated: false, completion: nil)
        }
    }
}

extension ViewController: UIPageViewControllerDataSource
{
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if let idx = pageIndexOfViewController(viewController) where idx < viewControllers.count-1
        {
            var nextVC = viewControllers[idx+1]
            
            if nextVC == nil
            {
                nextVC = storyboard!.instantiateViewControllerWithIdentifier("pdfPage") as? SinglePageViewController
                viewControllers[idx+1] = nextVC
            }
            return nextVC
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if let idx = pageIndexOfViewController(viewController) where idx > 0
        {
            var prevVC = viewControllers[idx-1]
            if prevVC == nil
            {
                prevVC = storyboard!.instantiateViewControllerWithIdentifier("pdfPage") as? SinglePageViewController
                viewControllers[idx-1] = prevVC
            }
            
            return prevVC
        }
        return nil
    }
}

extension ViewController: UIPageViewControllerDelegate
{
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController])
    {
        print("pending:")
        if let vc = pendingViewControllers.last
        {
            pendingPageIdx = pageIndexOfViewController(vc)
            print(pendingPageIdx)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        print("previous:")
        for vc in previousViewControllers
        {
            let idx = pageIndexOfViewController(vc)
            print(idx)
        }
        
        if completed
        {
            currentPageIdx = pendingPageIdx
        }
    }
}
