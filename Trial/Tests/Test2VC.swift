//
//  Test2VC.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
}

class CollectionViewController: UICollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        cell.label.text = String(indexPath.row)
        return cell
    }
    
    @objc func doZoom() {
        collectionView.setZoomScale(1.5, animated: true)
    }
    
    override func viewDidLoad() {
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            DispatchQueue.main.async {
//                self.collectionView.setZoomScale(0.5, animated: true)
                self.collectionView.zoom(to: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)), animated: true)
            }
        }
    }
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return collectionView.cellForItem(at: IndexPath(row: 22, section: 0))
    }
}
