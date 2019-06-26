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
}

class CollectionViewController: UICollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        return cell
    }
    
    override func viewDidLoad() {
        collectionView.delaysContentTouches = true
    }
    
    @IBAction func up(_ sender: Any) {
        print("touchedUp")
        print(Date().timeIntervalSince1970)
        (sender as! UIButton).setImage(UIImage(named: "seek_back"), for: .normal)
        animator.isReversed = true
        animator.startAnimation()
    }
    
    @IBAction func down(_ sender: Any) {
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        print("touchedDown")
        print(Date().timeIntervalSince1970)
        animator.pausesOnCompletion = true
        animator.addAnimations {
            (sender as! UIButton).transform = .init(scaleX: 0.7, y: 0.7)
        }
        animator.startAnimation()
    }
    
    let animator = UIViewPropertyAnimator(duration: 0.4, curve: UIView.AnimationCurve.easeInOut, animations: nil)
}
