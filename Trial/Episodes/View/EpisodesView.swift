//
//  EpisodesView.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/24.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class EpisodesView: UICollectionView, UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view?.isKind(of: EpisodesView.self) ?? true
    }
}
