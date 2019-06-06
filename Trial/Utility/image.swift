//
//  image.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/6.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import func AVFoundation.AVMakeRect


func resizedImage(image: UIImage, for size: CGSize) -> UIImage {
    let size = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: .zero, size: size)).size
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
        image.draw(in: CGRect(origin: .zero, size: size))
    }
}
