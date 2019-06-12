//
//  ScreenshotCell.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/4.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class ThumbnailCell: UICollectionViewCell {
    let thumbnailView: UIImageView
    
    let gradientView: UIImageView
    
    override init(frame: CGRect) {
        thumbnailView = UIImageView()
        gradientView = UIImageView()
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.clipsToBounds = true
        setupImageView(thumbnailView, at: 0, contentMode: .center)
        setupImageView(gradientView, at: 1, contentMode: .scaleAspectFill)
    }
    
    func setupImageView(_ imageView: UIImageView, at index: Int, contentMode: UIView.ContentMode) {
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
        contentView.insertSubview(imageView, at: index)
        setupFillConstraintsFor(view: imageView)
    }
    
    private func setupFillConstraintsFor(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)])
    }
}
