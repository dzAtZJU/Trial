//
//  ViewController.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/12.
//  Copyright © 2019 周巍然. All rights reserved.
//

import UIKit

let initialItem = IndexPath(row: 3, section: 2)
let initialPosition = CGPoint(x: Template.default2.dXOf(dCol: initialItem.section, dRow: initialItem.row), y: Template.default2.dYOf(initialItem.section))

func positionFromIndex(_ index: IndexPath) -> CGPoint {
    return CGPoint(x:CGFloat(index.section) * itemWidth, y: CGFloat(index.row) * itemHeight)
}

class RippleVC: UICollectionViewController {
    
    // MARK: CollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ytRows
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytCols
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RippleCell
        cell.label.text = indexPath.description
        return cell
    }
    
    // MARK: VC
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.scrollToItem(at: initialItem, at: [.centeredHorizontally, .centeredVertically], animated: false)
        var i = 2
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let index = IndexPath(row: i, section: 2)
            let layout = RippleLayout(theCenter: index, theCenterPosition: CGPoint(x: Template.default2.dXOf(dCol: index.section, dRow: index.row), y: Template.default2.dYOf(index.section)))
            self.collectionView.setCollectionViewLayout(layout, animated: true)
            i = (i == 2) ? 3 : 2
        }
    }
    
//    // MARK: Interaction
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let viewCenter = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
//        let centralBlock = layout.getCurrentAndNextCentralItem(viewCenter: viewCenter)
//        animateTo(centralBlock: centralBlock)
//    }
//
//    var lastCentralBlock: CentralBlock
//
//    var lastTransition: UICollectionViewTransitionLayout
    
//    func animateTo(centralBlock: CentralBlock) {
//        if lastCentralBlock.sameBlockAs(centralBlock) {
//            lastTransition.transitionProgress = timingFrom(distanceToStart: lastCentralBlock.distanceToCurrent, distanceToEnd: lastCentralBlock.distanceToNext)
//            lastTransition.invalidateLayout()
//        } else {
//            collectionView.finishInteractiveTransition()
//            lastCentralBlock = centralBlock
//            lastTransition = collectionView.startInteractiveTransition(to: RippleLayout(center: centralBlock.next), completion: nil)
//        }
//    }
    
//    @objc func handlePanning(_ recognizer: UIPanGestureRecognizer) {
//        switch recognizer.state {
//        case .began:
//            collectionView.setCollectionViewLayout(RippleLayout(theCenter: IndexPath(row: initialItem.row - 1, section: initialItem.section), theCenterPosition: CGPoint(x: initialPosition.x - itemHeight, y: initialPosition.y)), animated: true)
//        default:
//            return
//        }
//    }
    
    var layout: RippleLayout {
        return collectionView.collectionViewLayout as! RippleLayout
    }
}

//extension RippleVC {
//    func timingFrom(distanceToStart: CGFloat, distanceToEnd: CGFloat) -> CGFloat {
//
//    }
//}

