////
////  ViewController.swift
////  Trial
////
////  Created by 周巍然 on 2019/3/12.
////  Copyright © 2019 周巍然. All rights reserved.
////
//
//import UIKit
//
//func positionFromIndex(_ index: IndexPath) -> CGPoint {
//    return CGPoint(x:CGFloat(index.section) * itemWidth, y: CGFloat(index.row) * itemHeight)
//}
//enum SceneState {
//    case surfing
//    case watching
//    case initial
//}
//
//class RippleVC: UICollectionViewController {
//    
//    var sceneState: SceneState = .initial
//    func updateSceneState() {
//        switch sceneState {
//            case .surfing, .initial:
////                collectionView.panGestureRecognizer.addTarget(self, action: #selector(handlePanning(_:)))
//                press?.addTarget(self, action: #selector(handlePress(_:)))
//                if sceneState == .initial {
//                    collectionView.setCollectionViewLayout(RippleTransitionLayout.initialLayoutForWatch(centerLayout: initialLayout1), animated: false)
//                } else {
//                    let centerItem = layoutForSurfing!.centerItem
////                    let newLayout = RippleLayout(theCenter: centerItem, theCenterPosition: initialLayout1.centerOf(centerItem), theTemplate: Template.watch)
//                    let newLayout = RippleTransitionLayout.nextLayoutForWatch(center: centerItem, centerPosition: initialLayout1.centerOf(centerItem))
//                    collectionView.setCollectionViewLayout(newLayout, animated: false)
//                }
//                sceneState = .watching
//            case .watching:
////                collectionView.panGestureRecognizer.removeTarget(self, action: #selector(handlePanning(_:)))
//                press?.addTarget(self, action: #selector(handlePress(_:)))
//                collectionView.setCollectionViewLayout(RippleTransitionLayout.nextLayoutForSurf(center: layoutForWatching!.centerItem), animated: false)
//                sceneState = .surfing
//        }
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//    
//    // MARK: Interaction
//    var press: UILongPressGestureRecognizer?
//    @objc func handlePress(_ press: UILongPressGestureRecognizer) {
//        switch press.state {
//        case .began, .ended:
//            collectionView.isDirectionalLockEnabled = press.state == .began ? false : true
//            if layoutForWatching != nil || layoutForSurfing != nil {
//                updateSceneState()
//            }
//        default:
//            print("press change")
//            return
//        }
//        return
//    }
//    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let viewCenter = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
//        layoutForSurfing?.viewCenterChanged(viewCenter)
//        layoutForWatching?.viewCenterChanged(viewCenter)
//    }
//    
//    var transitionLayoutForWatching: UICollectionViewTransitionLayout?
////    @objc func handlePanning(_ pan: UIPanGestureRecognizer) {
////        switch pan.state {
////            case .began:
////                if let layoutForWatching = layoutForWatching {
////                    let direction = Direction.fromVelocity(pan.velocity(in: collectionView))
////                    (collectionView as! RippleCollectionView).transitionDirection = direction
////                    transitionLayoutForWatching = collectionView.startInteractiveTransition(to: layoutForWatching.nextLayoutOn(direction: direction), completion: nil)
////                }
////            case .changed:
////                let timing = timingFromPanningTranslation(pan.translation(in: collectionView))
////                transitionLayoutForWatching?.transitionProgress = timing
////            case .ended:
////                collectionView.finishInteractiveTransition()
////            default:
////                return
////            }
////    }
//    
//    func timingFromPanningTranslation(_ translation: CGPoint) -> CGFloat {
//        let distance = hypot(translation.x, translation.y)
//        return min(distance / (itemWidthForWatching / 2), 1)
//    }
//    
//    // MARK: CollectionViewDataSource
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return ytRows
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return ytCols
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RippleCell
//        cell.label.text = indexPath.description + "\(cell.frame.midX) \(cell.frame.midY)"
////        YoutubeManager.shared.fetchThumbnail(indexPath, completion: { image in
////            DispatchQueue.main.async {
////                cell.loadImage(image)
////            }
////        })
////        cell.embedYTPlayer(YoutubeManager.shared.videos[indexPath]!)
//        return cell
//    }
//    
//    // MARK: VC
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        press = UILongPressGestureRecognizer(target: nil, action: nil)
//        collectionView.addGestureRecognizer(press!)
//        updateSceneState()
//        collectionView.scrollToItem(at: initialCenter1, at: [.centeredHorizontally, .centeredVertically], animated: false)
//        collectionView.panGestureRecognizer.delegate = collectionView as! RippleCollectionView
//        
////        var i = 1
////        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
////            let index = IndexPath(row: i, section: 2)
////            let layout = RippleLayout(theCenter: index, theCenterPosition: CGPoint(x: Template.default2.dXOf(dCol: index.section, dRow: index.row), y: Template.default2.dYOf(index.section)))
////            self.collectionView.setCollectionViewLayout(layout, animated: true)
////            i = (i == 2) ? 1 : 2
////        }
//    }
//    
////
////    var lastCentralBlock: CentralBlock
////
////    var lastTransition: UICollectionViewTransitionLayout
//    
////    func animateTo(centralBlock: CentralBlock) {
////        if lastCentralBlock.sameBlockAs(centralBlock) {
////            lastTransition.transitionProgress = timingFrom(distanceToStart: lastCentralBlock.distanceToCurrent, distanceToEnd: lastCentralBlock.distanceToNext)
////            lastTransition.invalidateLayout()
////        } else {
////            collectionView.finishInteractiveTransition()
////            lastCentralBlock = centralBlock
////            lastTransition = collectionView.startInteractiveTransition(to: RippleLayout(center: centralBlock.next), completion: nil)
////        }
////    }
//    
////    @objc func handlePanning(_ recognizer: UIPanGestureRecognizer) {
////        switch recognizer.state {
////        case .began:
////            collectionView.setCollectionViewLayout(RippleLayout(theCenter: IndexPath(row: initialItem.row - 1, section: initialItem.section), theCenterPosition: CGPoint(x: initialPosition.x - itemHeight, y: initialPosition.y)), animated: true)
////        default:
////            return
////        }
////    }
//    
//    var layoutForWatching: RippleTransitionLayout? {
//        if sceneState == .watching {
//            return collectionView.collectionViewLayout as? RippleTransitionLayout
//        }
//        return nil
//    }
//    
//    var layoutForSurfing: RippleTransitionLayout? {
//        if sceneState == .surfing {
//            return collectionView.collectionViewLayout as? RippleTransitionLayout
//        }
//        return nil
//    }
//}
//
////extension RippleVC {
////    func timingFrom(distanceToStart: CGFloat, distanceToEnd: CGFloat) -> CGFloat {
////
////    }
////}
//
