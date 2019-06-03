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
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        cell.label.text = String(indexPath.section * 10 + indexPath.row)
        return cell
    }
    
    override func viewDidLoad() {
        collectionView.contentInset = UIEdgeInsets(top: 500, left: 100, bottom: 0, right: 100)
    }
}
