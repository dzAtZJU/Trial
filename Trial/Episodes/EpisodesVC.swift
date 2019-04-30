////
////  EpisodesVC.swift
////  Trial
////
////  Created by 周巍然 on 2019/4/28.
////  Copyright © 2019 周巍然. All rights reserved.
////
//
//import Foundation
//import UIKit
//import ReSwift
//
//class EpisodesVC: UIViewController {
//    var collectionView: UICollectionView!
//
//    override func loadView() {
//        super.loadView()
//        view.backgroundColor = UIColor.black
//
//        let layout = EpisodesLayout.watching
//
//        collectionView = EpisodesView(frame: .zero, collectionViewLayout: layout)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(EpisodsCell.self, forCellWithReuseIdentifier: "episode")
//
//        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        view.addSubview(collectionView)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.frame = view.bounds
//    }
//
//    var sceneState = EpisodesSceneState.sliding
//
//    var inFocusItem: IndexPath!
//}
//
//extension EpisodesVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        guard indexPath == inFocusItem else {
////            return CGSize(width: 120, height: 225)
////        }
//
//        let layout = collectionViewLayout as! EpisodesLayout
//        switch layout.sceneState {
//        case .watching, .watching2Full:
//            return CGSize(width: 220, height: 225)
////            return CGSize(width: 432, height: 243)
//        case .full:
//            return CGSize(width: 667, height: 375)
//        case .full2Watching:
//            return CGSize(width: 518, height: 292)
////            return CGSize(width: 267, height: 375)
//        case .sliding:
//            return CGSize(width: 120, height: 225)
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        let layout = collectionViewLayout as! EpisodesLayout
//        switch layout.sceneState {
//        case .sliding:
//            return CGFloat(10)
//        case .watching:
//            return CGFloat(10)
////            return CGFloat(25)
//        case .full, .full2Watching:
//            return CGFloat(200)
//        case .watching2Full:
//            return CGFloat(100)
//        default:
//            fatalError()
//        }
//    }
//}
//
//extension EpisodesVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        inFocusItem = indexPath
//        episodesViewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
//    }
//
//    func runFull2WatchAnimation() {
//        let layout = EpisodesLayout.watching
//        UIView.animate(withDuration: 2) {
////            self.collectionView.collectionViewLayout = layout
//            (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 200, height: 200)
//        }
////        collectionView.setCollectionViewLayout(layout, animated: true) { _ in
////            self.sceneState = .watching
////            let layout = EpisodesLayout()
////            layout.sceneState = self.sceneState
////            layout.inFocusItem = self.inFocusItem
////            layout.scrollDirection = .horizontal
////            self.collectionView.setCollectionViewLayout(layout, animated: true)
////        }
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        episodesViewStore.dispatch(EpisodesViewState.SceneAction.scroll)
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        episodesViewStore.dispatch(EpisodesViewState.SceneAction.scroll)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        for cell in collectionView.visibleCells {
//            if cell.frame.contains(collectionView.bounds.center) {
//                inFocusItem = collectionView.indexPath(for: cell)
//            }
//        }
//    }
//}
//
//extension EpisodesVC: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episode", for: indexPath) as! EpisodsCell
//        cell.label.text = "\(indexPath.row)"
//
//        return cell
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 200
//    }
//}
//
//extension EpisodesVC: StoreSubscriber {
//    func newState(state: EpisodesSceneState) {
//        switch state {
//        case .sliding:
//            collectionView.setCollectionViewLayout(EpisodesLayout.sliding, animated: true)
//        case .watching:
//            collectionView.setCollectionViewLayout(EpisodesLayout.watching, animated: true)
//        default:
//            return
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        episodesViewStore.subscribe(self) { subcription in
//            subcription.select { viewState in
//                viewState.scene
//            }
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        episodesViewStore.unsubscribe(self)
//    }
//}
