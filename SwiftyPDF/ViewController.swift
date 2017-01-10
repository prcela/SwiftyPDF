//
//  ViewController.swift
//  SwiftyPDF
//
//  Created by prcela on 04/02/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func openPdf(_ sender: AnyObject)
    {
        let path = Bundle.main.path(forResource: "big_pdf_1", ofType: "pdf")!
        let url = URL(fileURLWithPath: path)
        let pdfViewController = UIStoryboard(name: "Pdf", bundle: nil).instantiateInitialViewController() as! PdfViewController
        pdfViewController.url = url
        present(pdfViewController, animated: true, completion: nil)
    }
}
