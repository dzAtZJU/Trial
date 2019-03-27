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

// MARK: CollectionViewDatasource
extension RippleVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ytRows
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytCols
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RippleCell
        cell.label.text = indexPath.description + "\(cell.frame.midX) \(cell.frame.midY)"
        
//        cell.positionId = indexPath
//        YoutubeManager.shared.getData(indexPath: indexPath) { youtubeVideoData in
//            DispatchQueue.main.async {
//                guard cell.positionId == indexPath else { return }
//                cell.configure(with: youtubeVideoData)
//            }
//        }
        
        YoutubeManager.shared.fetchThumbnail(indexPath, completion: { image in
                        DispatchQueue.main.async {
                            cell.loadImage(image)
                        }
                    })
        return cell
    }
}

// MARK: CollectionViewDelegate
extension RippleVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController")
        self.present(vc, animated: true, completion: nil)
    }
}

class RippleVC: UICollectionViewController {

    // MARK: VC
    override func viewDidLoad() {
        super.viewDidLoad()
        press = UILongPressGestureRecognizer(target: nil, action: nil)
        press!.addTarget(self, action: #selector(handlePress(_:)))
        collectionView.addGestureRecognizer(press!)
        collectionView.panGestureRecognizer.delegate = collectionView as! RippleCollectionView
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.insetsLayoutMarginsFromSafeArea = false
        
        updateSceneState()
        collectionView.scrollToItem(at: initialCenter1, at: [.centeredHorizontally, .centeredVertically], animated: false)
    }
    
    let indexPath2VideoId = [IndexPath: String]()
    
    var currentPlayerView: UIView? {
        return collectionView.cellForItem(at: layoutForWatching!.centerItem)
    }
    
    var sceneState: SceneState = .initial
    func updateSceneState() {
        switch sceneState {
            case .surfing, .initial:
                if sceneState == .initial {
                    collectionView.setCollectionViewLayout(RippleTransitionLayout.initialLayoutForWatch(centerLayout: initialLayout1), animated: false)
                } else {
                    let centerItem = layoutForSurfing!.centerItem
                    let newLayout = RippleTransitionLayout.nextLayoutForWatch(center: centerItem, centerPosition: initialLayout1.centerOf(centerItem))
                    collectionView.setCollectionViewLayout(newLayout, animated: false)
                }
                sceneState = .watching
            case .watching:
                let centerItem = layoutForWatching!.centerItem
                collectionView.setCollectionViewLayout(RippleTransitionLayout.nextLayoutForSurf(center: centerItem, centerPosition: initialLayout1ForSurf.centerOf(centerItem)), animated: false)
                sceneState = .surfing
            }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Interaction
    var press: UILongPressGestureRecognizer?
    @objc func handlePress(_ press: UILongPressGestureRecognizer) {
        switch press.state {
        case .began, .ended:
            collectionView.isDirectionalLockEnabled = press.state == .began ? false : true
            if layoutForWatching != nil || layoutForSurfing != nil {
                updateSceneState()
            }
        default:
            print("press change")
            return
        }
        return
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let viewCenter = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
        layoutForSurfing?.viewCenterChanged(viewCenter)
        layoutForWatching?.viewCenterChanged(viewCenter)
    }
    
    var transitionLayoutForWatching: UICollectionViewTransitionLayout?
    //    @objc func handlePanning(_ pan: UIPanGestureRecognizer) {
    //        switch pan.state {
    //            case .began:
    //                if let layoutForWatching = layoutForWatching {
    //                    let direction = Direction.fromVelocity(pan.velocity(in: collectionView))
    //                    (collectionView as! RippleCollectionView).transitionDirection = direction
    //                    transitionLayoutForWatching = collectionView.startInteractiveTransition(to: layoutForWatching.nextLayoutOn(direction: direction), completion: nil)
    //                }
    //            case .changed:
    //                let timing = timingFromPanningTranslation(pan.translation(in: collectionView))
    //                transitionLayoutForWatching?.transitionProgress = timing
    //            case .ended:
    //                collectionView.finishInteractiveTransition()
    //            default:
    //                return
    //            }
    //    }
    
    func timingFromPanningTranslation(_ translation: CGPoint) -> CGFloat {
        let distance = hypot(translation.x, translation.y)
        return min(distance / (itemWidthForWatching / 2), 1)
    }
    
    var layoutForWatching: RippleTransitionLayout? {
        if sceneState == .watching {
            return collectionView.collectionViewLayout as? RippleTransitionLayout
        }
        return nil
    }
    
    var layoutForSurfing: RippleTransitionLayout? {
        if sceneState == .surfing {
            return collectionView.collectionViewLayout as? RippleTransitionLayout
        }
        return nil
    }
}

