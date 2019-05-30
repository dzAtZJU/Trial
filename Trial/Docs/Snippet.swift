//////
//////  Snippet.swift
//////  Trial
//////
//////  Created by 周巍然 on 2019/5/29.
//////  Copyright © 2019 周巍然. All rights reserved.
//////
////
//////import Foundation
//////
//////func preFetchVideoForTwoNeighborItems() {
//////    twoNeighborsOfInFocusItem().forEach { item in
//////        YoutubeManagers.shared.fetchVideoForItem(item) { video, cached in
//////            guard !cached else {
//////                return
//////            }
//////
//////            let cell = self.collectionView.cellForItem(at: item) as! RippleCellV2
//////            cell.mountVideoForBuffering(video)
//////        }
//////    }
//////}
//////
//////func cancelPreFetchVideoForTwoNeighborItems() {
//////    twoNeighborsOfInFocusItem().forEach { item in
//////        YoutubeManagers.shared.fetchVideoForItem(item) { video, cached in
//////            guard !cached else {
//////                return
//////            }
//////
//////            let cell = self.collectionView.cellForItem(at: item) as! RippleCellV2
//////            cell.unmountVideoForBuffering()
//////        }
//////    }
//////}
////
//////for (videoId, thumbnailUrl) in self.videoId2Thumbnail {
//////    let operation = ImageFetchOperation(imageUrl: thumbnailUrl)
//////    operation.completionBlock = {
//////        let data = YoutubeVideoData()
//////        data.videoId = videoId
//////        data.thumbnail = operation.image
//////        self.videoId2Data[videoId] = data
//////        DispatchQueue.main.sync {
//////            self.invokeCompletionHandlers(for: videoId, with: data)
//////        }
//////    }
//////    YoutubeOperationQueue.addOperation(operation)
//////}
////
////// Collectionview Level
//////func batchRequestFor(items: [IndexPath]) {
//////    for item in items {
//////        let videoId = indexPath2videoId[item]!
//////        requestFor(videoId: videoId) { youtubeVideoData in
//////            self.videoId2Data[videoId] = youtubeVideoData
//////            DispatchQueue.main.sync {
//////                self.invokeCompletionHandlers(for: videoId, with: youtubeVideoData)
//////            }
//////        }
//////    }
//////}
////
//////let handlers = videoId2CompletionHandlers[videoId, default: []]
//////videoId2CompletionHandlers[videoId] = handlers + [completionHandler]
//////if let data = videoId2Data[videoId] {
//////    invokeCompletionHandlers(for: videoId, with: data)
//////    return
//////}
////
//////
//////  RippleTransitionLayout.swift
//////  Trial
//////
//////  Created by 周巍然 on 2019/3/22.
//////  Copyright © 2019 周巍然. All rights reserved.
//////
////
////import Foundation
////import UIKit
////
////class RippleTransitionLayout: UICollectionViewLayout {
////    var estimatedContentSize: CGSize = .zero
////    
////    var vertex2Layout: [IndexPath: (CGFloat, RippleLayout)]
////
////    var centerItem: IndexPath {
////        let (key, _) = self.vertex2Layout.max { (l1, l2) -> Bool in
////            return l1.value.0 < l2.value.0
////            }!
////
////        return key
////    }
////
////    private var triangle: [IndexPath] {
////        return Array(vertex2Layout.keys)
////    }
////
////    var uiTemplates: UIMetricTemplate
////
////    var shouldPagedMove: Bool {
////        return rippleViewStore.state.scene == .watching
////    }
////
////    static var genesisLayout: RippleTransitionLayout {
////        let triangle = defaultIndexTriangleAround(IndexPath(row: 2, section: 2), maxRow: ytRows, maxCol: ytCols)
////
////        let isPortrait = UIScreen.main.bounds.height > UIScreen.main.bounds.width
////        let calcu = isPortrait ? LayoutCalcuTemplate.surf : LayoutCalcuTemplate.surfLand
////        let template = isPortrait ? UIMetricTemplate.surf : UIMetricTemplate.surfLand
////
////        let newCenterPosition = calcu.minimumCenterOf(row: triangle.0.row, col: triangle.0.section)
////        let layoutP1 = RippleLayout(theCenter: triangle.0, theCenterPosition: newCenterPosition, theTemplate: calcu)
////        let layoutP2 = RippleLayout(theCenter: triangle.1, theCenterPosition: layoutP1.centerOf(triangle.1), theTemplate: calcu)
////        let layoutP3 = RippleLayout(theCenter: triangle.2, theCenterPosition: layoutP1.centerOf(triangle.2), theTemplate: calcu)
////
////
////        return RippleTransitionLayout(layoutP1: layoutP1, layoutP2: layoutP2, layoutP3: layoutP3, uiTemplates: template)
////    }
////
////    init(layoutP1: RippleLayout, layoutP2: RippleLayout, layoutP3: RippleLayout, uiTemplates: UIMetricTemplate) {
////        self.lastCenterP = layoutP1.center
////        self.uiTemplates = uiTemplates
////
////        self.vertex2Layout = [IndexPath: (CGFloat, RippleLayout)]()
////        self.vertex2Layout[layoutP1.center] = (1, layoutP1)
////        self.vertex2Layout[layoutP2.center] = (0, layoutP2)
////        self.vertex2Layout[layoutP3.center] = (0, layoutP3)
////
////        super.init()
////    }
////
////    required init?(coder aDecoder: NSCoder) {
////        fatalError()
////    }
////
////    // 中心的 item
////    @objc var lastCenterP: IndexPath
////
////    func viewPortCenterChanged() {
////        if let (newCenterTriangle, newbary) = reComputeCenterTriangle() {
////            if Set(Array(self.vertex2Layout.keys)) != Set(Array(newCenterTriangle.map{IndexPath($0)})) {
////                updateCenterTriangle(newCenterTriangle, bary: newbary)
////            } else {
////                self.vertex2Layout[IndexPath(newCenterTriangle[0])]!.0 = newbary[0]
////                self.vertex2Layout[IndexPath(newCenterTriangle[1])]!.0 = newbary[1]
////                self.vertex2Layout[IndexPath(newCenterTriangle[2])]!.0 = newbary[2]
////            }
////        }
////    }
////
////    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
////        let result = LayoutAttributes(forCellWith: indexPath)
////
////        result.frame = frameForItem(at: indexPath)
////        result.timing = timingForItem(at: indexPath)
////
////        result.titleFontSize = uiTemplates.titleFontSize
////        result.subtitleFontSize = uiTemplates.subtitleFontSize
////        result.titlesBottom = uiTemplates.titlesBottom
////        result.radius = uiTemplates.radius
////        result.sceneState = rippleViewStore.state.scene
////        result.zIndex = centerItem == indexPath ? 1 : 0
////        return result
////    }
////
////    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
////        var r = [UICollectionViewLayoutAttributes]()
////        for row in 0..<ytRows {
////            for col in 0..<ytCols {
////                let l = layoutAttributesForItem(at: IndexPath(row: row, section: col))
////                if l != nil {
////                    r.append(l!)
////                }
////            }
////        }
////        return r
////
////        //        var visited = Set<IndexPath>()
////        //        var attributes = [UICollectionViewLayoutAttributes]()
////        //        dfs(node: centerItem, maxRow: maxRow, maxCol: maxCol, visited: &visited, rect: rect, attributes: &attributes)
////        //        return attributes
////    }
////
////    func dfs(node: IndexPath, maxRow: Int, maxCol: Int, visited: inout Set<IndexPath>, rect: CGRect, attributes: inout [UICollectionViewLayoutAttributes]) {
////        visited.insert(node)
////
////        let frame = frameForItem(at: node)
////        if !rect.intersects(frame) {
////            return
////        }
////
////        if let attribute = layoutAttributesForItem(at: node) {
////            attributes.append(attribute)
////        }
////
////        for neighbor in eightNeighborsOf(item: node, maxRow: maxRow, maxCol: maxCol) {
////            if !visited.contains(neighbor) {
////                dfs(node: neighbor, maxRow: maxRow, maxCol: maxCol, visited: &visited, rect: rect, attributes: &attributes)
////            }
////        }
////    }
////
////    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
////        return true
////    }
////
////    func isViewCenterIn(indexTriangle: [CGPoint]) -> [CGFloat]? {
////        let triangle = (centerForItem(at: IndexPath(indexTriangle[0])), centerForItem(at: IndexPath(indexTriangle[1])), centerForItem(at: IndexPath(indexTriangle[2])))
////        let newBarycentric = barycentricOf(collectionView!.viewPortCenter, P1: triangle.0, P2: triangle.1, P3: triangle.2)
////        let threshold: CGFloat = rippleViewStore.state.scene == .watching ? -0.02 : 0 // To soften Numeric effect
////        if newBarycentric.allSatisfy({ $0 >= threshold }) {
////            return newBarycentric
////        }
////
////        return nil
////    }
////
////    private func reComputeCenterTriangle() -> ([CGPoint], [CGFloat])? {
////        var nextCenterTriangle: [CGPoint]?
////
////        for indexTriangle in eightTrianglesAround(triangle) {
////            if let newBarycentric = isViewCenterIn(indexTriangle: indexTriangle) {
////                nextCenterTriangle = indexTriangle
////                return (nextCenterTriangle!, newBarycentric)
////            }
////        }
////
////        var nextbaryCentrics = [CGFloat]()
////        doIn2DRange(maxRow: maxRow, maxCol: maxCol) {
////            (row, col, stop) in
////            for indexTriangle in indexTrianglesAround(CGPoint(x: row, y: col), maxRow: ytRows, maxCol: ytCols) {
////                if let newBarycentric = isViewCenterIn(indexTriangle: indexTriangle) {
////                    nextCenterTriangle = indexTriangle
////                    nextbaryCentrics = newBarycentric
////                    stop = true
////                    break
////                }
////            }
////        }
////
////        if nextCenterTriangle != nil {
////            return (nextCenterTriangle!, nextbaryCentrics)
////        }
////
////        return nil
////    }
////
////    //    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
////    //        if !shouldPagedMove {
////    //            return proposedContentOffset
////    //        }
////    //
////    //        let proposedCenter = proposedContentOffset + CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
////    //        var minDistance = CGFloat(Int.max)
////    //        var minCenter = CGPoint.zero
////    //        var minIndex = lastCenterP
////    //        let candidates = nearestFiveTo(lastCenterP, maxRow: ytRows, maxCol: ytCols) + fourDiagonalNeighborsOf(lastCenterP, maxRow: ytRows, maxCol: ytCols)
////    //        for indexPath in candidates {
////    //            let center = centerForItem(at: indexPath)
////    //            let distance = distanceBetween(left: center, right: proposedCenter)
////    //            if distance < minDistance {
////    //                minDistance = distance
////    //                minCenter = center
////    //                minIndex = indexPath
////    //            }
////    //        }
////    //
////    //        let r = minCenter - CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
////    //        lastCenterP = minIndex
////    //        return r
////    //    }
////
////    func centerForItem(at indexPath: IndexPath) -> CGPoint {
////        var center = CGPoint.zero
////        for (weight, layout) in self.vertex2Layout.values {
////            center = center + layout.centerOf(indexPath) * weight
////        }
////
////        return center
////    }
////
////    func frameForItem(at indexPath: IndexPath) -> CGRect {
////        var frame = CGRect.zero
////        for (weight, layout) in self.vertex2Layout.values {
////            frame = frame + layout.frameOf(indexPath) * weight
////        }
////
////        return frame
////    }
////
////    func timingForItem(at indexPath: IndexPath) -> CGFloat {
////        var timing: CGFloat = 0
////        for (weight, layout) in self.vertex2Layout.values {
////            timing = timing + layout.timingOf(indexPath) * weight
////        }
////
////        return timing
////    }
////
////    private var maxRow: Int {
////        return collectionView!.numberOfItems(inSection: 0)
////    }
////
////    private var maxCol: Int {
////        return collectionView!.numberOfSections
////    }
////}
////
////
////
////  RippleTransitionLayout+Transform.swift
////  Trial
////
////  Created by 周巍然 on 2019/5/22.
////  Copyright © 2019 周巍然. All rights reserved.
////
//
//import Foundation
//import CoreGraphics
//import UIKit
//
//extension RippleTransitionLayout {
//    override var collectionViewContentSize: CGSize {
//        return estimatedContentSize
//    }
//    
//    private var calcuTemplate: LayoutCalcuTemplate {
//        return self.vertex2Layout.first!.value.1.template
//    }
//    
//    override func prepare() {
//        let frameOfLastItem = frameForItem(at: IndexPath(row: ytRows-1, section: ytCols-1))
//        estimatedContentSize = CGSize(width: frameOfLastItem.maxX, height: frameOfLastItem.maxY)
//    }
//    
//    func updateCenterTriangle(_ new: [CGPoint], bary: [CGFloat]) {
//        let P1 = new[0], P2 = new[1], P3 = new[2]
//        
//        let center1 = IndexPath(row: Int(P1.y), section: Int(P1.x))
//        let layoutP1 = RippleLayout(theCenter: center1, theCenterPosition: centerForItem(at: center1), theTemplate: calcuTemplate)
//        
//        let center2 = IndexPath(row: Int(P2.y), section: Int(P2.x))
//        let layoutP2 = RippleLayout(theCenter: center2, theCenterPosition: centerForItem(at: center2), theTemplate: layoutP1.template)
//        
//        let center3 = IndexPath(row: Int(P3.y), section: Int(P3.x))
//        let layoutP3 = RippleLayout(theCenter: center3, theCenterPosition: centerForItem(at: center3), theTemplate: layoutP1.template)
//        
//        self.vertex2Layout.removeAll()
//        self.vertex2Layout[layoutP1.center] = (bary[0], layoutP1)
//        self.vertex2Layout[layoutP2.center] = (bary[1], layoutP2)
//        self.vertex2Layout[layoutP3.center] = (bary[2], layoutP3)
//    }
//    
//    func assembleThreeNewLayouts(moveTo: IndexPath?, layoutTemplate: LayoutCalcuTemplate) -> RippleTransitionLayout {
//        var layouts = Array(self.vertex2Layout.values.map {$0.1})
//        var layoutP1 = layouts[0], layoutP2 = layouts[1], layoutP3 = layouts[2]
//        if centerItem == layoutP2.center {
//            swap(&layoutP1, &layoutP2)
//        } else if centerItem == layoutP3.center {
//            swap(&layoutP1, &layoutP3)
//        }
//        
//        var center1, center2, center3: IndexPath
//        if let moveTo = moveTo {
//            (center1, center2, center3) = defaultIndexTriangleAround(moveTo, maxRow: ytRows, maxCol: ytCols)
//        } else {
//            (center1, center2, center3) = (layoutP1.center, layoutP2.center, layoutP3.center)
//        }
//        
//        let newPositionForCenter1 = layoutTemplate.minimumCenterOf(row: center1.row, col: center1.section)
//        let toggledLayoutP1 = RippleLayout(theCenter: center1, theCenterPosition: newPositionForCenter1, theTemplate: layoutTemplate)
//        let toggledLayoutP2 = RippleLayout(theCenter: center2, theCenterPosition: toggledLayoutP1.centerOf(center2), theTemplate: layoutTemplate)
//        let toggledLayoutP3 = RippleLayout(theCenter: center3, theCenterPosition: toggledLayoutP1.centerOf(center3), theTemplate: layoutTemplate)
//        
//        return RippleTransitionLayout(layoutP1: toggledLayoutP1, layoutP2: toggledLayoutP2, layoutP3: toggledLayoutP3, uiTemplates: layoutTemplate.uiTemplates)
//    }
//    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
//        return centerForItem(at: centerItem) - CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
//    }
//    
//    // Wrapper for LayoutCalcuTemplate
//    // Assembler for three rippple layouts
//    func nextOnScene() -> RippleTransitionLayout {
//        let toggledLayoutTemplate = calcuTemplate.nextOnScene()
//        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
//    }
//    
//    func nextOnRotate() -> RippleTransitionLayout {
//        let toggledLayoutTemplate = calcuTemplate.nextOnRotate()
//        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
//    }
//    
//    func nextOnFullPortrait() -> RippleTransitionLayout {
//        let toggledLayoutTemplate = calcuTemplate.nextOnFullPortrait()
//        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
//    }
//    
//    func nextOnFullLandscape() -> RippleTransitionLayout {
//        let toggledLayoutTemplate = calcuTemplate.nextOnFullLandscape()
//        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
//    }
//    
//    func nextOnMove(_ index: IndexPath?) -> RippleTransitionLayout {
//        return assembleThreeNewLayouts(moveTo: index, layoutTemplate: calcuTemplate)
//    }
//}
