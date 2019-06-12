//
//  PlayerView.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class PlayerControlView: UIView {
    
    static let dateFormatter: DateComponentsFormatter = {
        let r = DateComponentsFormatter()
        r.unitsStyle = .positional
        r.allowedUnits = [.hour, .minute, .second]
        r.zeroFormattingBehavior = .pad
        return r
    }()
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    var delegate: VideoWithPlayerView?
    
    static let playIcon = UIImage(named: "play")
    
    static let pauseIcon = UIImage(named: "pause")
    
    static let thumbIcon = UIImage(named: "thumb")
    
    var isPlaying: Bool! = nil {
        didSet {
            playButton.setImage(isPlaying ? PlayerControlView.pauseIcon : PlayerControlView.playIcon, for: .normal)
        }
    }
    
    var isSliding = false
    
    var current: Float {
        get {
            return 0
        }
        set(newValue) {
            let currentString = PlayerControlView.dateFormatter.string(from: TimeInterval(newValue))!.stripZeroHour()
            let slashIndex = progressLabel.text!.firstIndex(of: "/")!
            progressLabel.text!.replaceSubrange(progressLabel.text!.startIndex..<slashIndex, with: currentString + " ")
            slider.value = newValue
        }
    }
    
    func preparePresent(isPlaying: Bool, duration: Float, current: Float) {
        slider.setThumbImage(PlayerControlView.thumbIcon, for: .normal)
        self.isPlaying = isPlaying
        slider.minimumValue = 0
        slider.maximumValue = duration
        slider.value = current
        
        let currentString = PlayerControlView.dateFormatter.string(from: TimeInterval(current))!
        let durationString = PlayerControlView.dateFormatter.string(from: TimeInterval(duration))!
        progressLabel.text =  currentString.stripZeroHour() + " / " + durationString.stripZeroHour()
    }
    
    @IBAction func togglePlay(_ sender: UIButton) {
        isPlaying ? delegate?.pause() : delegate?.play()
        isPlaying = !isPlaying
    }
    
    @IBAction func didSlide(_ sender: UISlider, forEvent event: UIEvent) {
        isSliding = event.allTouches!.first!.phase != .ended
        let newValue = round(sender.value)
        current = newValue
        delegate?.videoView.seek(toSeconds: newValue, allowSeekAhead: !isSliding)
        
        if !isSliding {
            delegate?.play()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromSuperview()
    }
    //    var exitButton: UIButton!
//
//    var episodesButton: UIButton!
//
//    var label: UILabel!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupView() {
//        label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 375, height: 30)))
//        label.backgroundColor = UIColor.white
//        label.isHidden = true
//        addSubview(label)
//
//        exitButton = UIButton(type: .roundedRect)
//        exitButton.backgroundColor = UIColor.red
//        addSubview(exitButton)
//        exitButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: exitButton, attribute: .top, multiplier: 1, constant: 8),
//                                     NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: exitButton, attribute: .right, multiplier: 1, constant: 8),
//                                     NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: exitButton, attribute: .width, multiplier: 7, constant: 0),
//                                     NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: exitButton, attribute: .height, multiplier: 7, constant: 0)])
//        exitButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
//
//        episodesButton = UIButton(type: .roundedRect)
//        episodesButton.backgroundColor = UIColor.blue
//        addSubview(episodesButton)
//        episodesButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: episodesButton, attribute: .top, multiplier: 1, constant: 8),
//                                     NSLayoutConstraint(item: episodesButton, attribute: .right, relatedBy: .equal, toItem: exitButton, attribute: .left, multiplier: 1, constant: 8),
//                                     NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: episodesButton, attribute: .width, multiplier: 7, constant: 0),
//                                     NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: episodesButton, attribute: .height, multiplier: 7, constant: 0)])
//        episodesButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
//    }
//
//    @objc func handleButton(_ sender: UIButton) {
//        let notification = sender == exitButton ? Notification.Name.exitFullscreen : .goToEpisodesView
//        NotificationCenter.default.post(name: notification, object: self)
//    }
}
