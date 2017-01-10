//
//  ThumbnailsDataSource.swift
//  SwiftyPDF
//
//  Created by prcela on 06/02/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class ThumbnailsDataSource: NSObject, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PdfDocument.pagesDesc.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ThumbCell
        cell.numLabel.text = String(indexPath.row+1)
        return cell
        
    }

}
