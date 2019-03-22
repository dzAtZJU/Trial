//
//  ViewController.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/12.
//  Copyright © 2019 周巍然. All rights reserved.
//

import UIKit

func positionFromIndex(_ index: IndexPath) -> CGPoint {
    return CGPoint(x:CGFloat(index.section) * itemWidth, y: CGFloat(index.row) * itemHeight)
}
enum SceneState {
    case surfing
    case watching
    case initial
}

class RippleVC: UICollectionViewController {
    
    var sceneState: SceneState = .initial
    func updateSceneState() {
        switch sceneState {
            case .surfing, .initial:
                sceneState = .watching
                collectionView.panGestureRecognizer.addTarget(self, action: #selector(handlePanning(_:)))
            case .watching:
                sceneState = .surfing
                collectionView.panGestureRecognizer.removeTarget(self, action: #selector(handlePanning(_:)))
        }
    }
    
    var transitionLayoutForWatching: UICollectionViewTransitionLayout?
    @objc func handlePanning(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
            case .began:
                collectionView.startInteractiveTransition(to: layoutForWatching!.nextLayoutOn(direction: Direction.fromVelocity(pan.velocity(in: collectionView))), completion: nil)
            case .changed:
                transitionLayoutForWatching?.transitionProgress = timingFromPanningTranslation(pan.translation(in: collectionView))
            case .ended:
                collectionView.finishInteractiveTransition()
            default:
                return
            }
    }
    
    func timingFromPanningTranslation(_ translation: CGPoint) -> CGFloat {
        let distance = hypot(translation.x, translation.y)
        return min(distance / (itemWidthForWatching / 2), 1)
    }
    
    // MARK: CollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ytRows
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytCols
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RippleCell
        cell.embedYTPlayer(YoutubeManager.shared.videos[indexPath]!)
        return cell
    }
    
    // MARK: VC
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSceneState()
        collectionView.scrollToItem(at: initialCenter1, at: [.centeredHorizontally, .centeredVertically], animated: false)
//        var i = 1
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//            let index = IndexPath(row: i, section: 2)
//            let layout = RippleLayout(theCenter: index, theCenterPosition: CGPoint(x: Template.default2.dXOf(dCol: index.section, dRow: index.row), y: Template.default2.dYOf(index.section)))
//            self.collectionView.setCollectionViewLayout(layout, animated: true)
//            i = (i == 2) ? 1 : 2
//        }
    }
    
    // MARK: Interaction
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let viewCenter = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
        layoutForSurfing?.viewCenterChanged(viewCenter)
//        let centralBlock = layout.getCurrentAndNextCentralItem(viewCenter: viewCenter)
//        animateTo(centralBlock: centralBlock)
    }
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
    
    var layoutForWatching: RippleLayout? {
        if sceneState == .watching {
            return collectionView.collectionViewLayout as! RippleLayout
        }
        return nil
    }
    
    var layoutForSurfing: RippleTransitionLayout? {
        if sceneState == .surfing {
            return collectionView.collectionViewLayout as! RippleTransitionLayout
        }
        return nil
    }
}

//extension RippleVC {
//    func timingFrom(distanceToStart: CGFloat, distanceToEnd: CGFloat) -> CGFloat {
//
//    }
//}

