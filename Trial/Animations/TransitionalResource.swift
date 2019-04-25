//
//  TransitionalResource.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/18.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

protocol TransitionalResource {
    associatedtype Item
    func nextOnScene() -> Item
    func nextOnRotate() -> Item
}

