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
    
    @IBOutlet weak var backButton1: UIButton!
    @IBOutlet weak var backButton2: UIButton!
    
    
    @IBOutlet weak var forwardButton1: UIButton!
    @IBOutlet weak var forwardButton2: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    var delegate: VideoWithPlayerView?
    
    static let playIcon = UIImage(named: "play")
    
    static let pauseIcon = UIImage(named: "pause")
    
    static let thumbIcon = UIImage(named: "thumb")
    
    static let backIcon = UIImage(named: "seek")!
    
    static let forwardIcon: UIImage = {
        let r = UIImage(cgImage: backIcon.cgImage!.copy()!, scale: 1, orientation: .down).withRenderingMode(.alwaysTemplate)
        return r
    }()
    
    static let xAnimation: CABasicAnimation = {
        let r = CABasicAnimation(keyPath: "position.x")
        r.duration = 0.33
        r.autoreverses = true
        r.repeatCount = 1
        return r
    }()
    
    var isPlaying: Bool! = nil {
        didSet {
            playButton.setImage(isPlaying ? PlayerControlView.pauseIcon : PlayerControlView.playIcon, for: .normal)
        }
    }
    
    var isSliding = false
    
    static func loadAnInstance() -> PlayerControlView {
        let r = (Bundle.main.loadNibNamed("PlayerControl", owner: nil, options: nil)!.first! as! PlayerControlView)
        r.installShadowLayer("shadow_player")
        r.backButton1.setImage(PlayerControlView.backIcon, for: .normal)
        r.backButton2.setImage(PlayerControlView.backIcon, for: .normal)
        r.forwardButton1.setImage(PlayerControlView.forwardIcon, for: .normal)
        r.forwardButton2.setImage(PlayerControlView.forwardIcon, for: .normal)
        r.backButton1.tintColor = UIColor.lightGray
        r.backButton2.tintColor = UIColor.lightGray
        r.forwardButton1.tintColor = UIColor.lightGray
        r.forwardButton2.tintColor = UIColor.lightGray
        return r
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
    
    @IBAction func didSlide(_ sender: UISlider, forEvent event: UIEvent) {
        let ended = event.allTouches!.first!.phase != .ended
        isSliding = !ended
        
        let newValue = round(sender.value)
        didSlideTo(newValue, ended: ended)
    }
    
    func didPlayedTo(_ seconds: Float) {
        if !isSliding {
            didSlideTo(seconds, ended: false)
        }
    }
    
    func slideTo(_ seconds: Float, ended: Bool) {
        isSliding = !ended
        didSlideTo(seconds, ended: ended)
    }
    
    func baseControlChanged(showed: Bool) {
        playButton.isHidden = showed
        forwardButton1.isHidden = showed
        forwardButton2.isHidden = showed
        backButton1.isHidden = showed
        backButton2.isHidden = showed
    }
    
    private func didSlideTo(_ seconds: Float, ended: Bool) {
        let currentString = PlayerControlView.dateFormatter.string(from: TimeInterval(seconds))!.stripZeroHour()
        let slashIndex = progressLabel.text!.firstIndex(of: "/")!
        progressLabel.text!.replaceSubrange(progressLabel.text!.startIndex..<slashIndex, with: currentString + " ")
        
        slider.value = seconds
        
        if ended {
            delegate?.videoView.seek(toSeconds: seconds, allowSeekAhead: true)
        }
    }
    
    @IBAction func togglePlay(_ sender: UIButton) {
        isPlaying ? delegate?.pause() : delegate?.play()
        isPlaying = !isPlaying
    }
    
    
    @IBAction func didBack() {
        delegate?.seekBy(-10)
        animateBackOrForward = true
    }
    
    @IBAction func didForward() {
        delegate?.seekBy(10)
        animateBackOrForward = false
    }
    
    var animateBackOrForward: Bool {
        get {
            return true
        }
        set(newValue) {
            let quicker = newValue ? backButton2 : forwardButton2
            let slower = newValue ? backButton1 : forwardButton1
            
            let translateX: CGFloat  = newValue ? -15 : 15
            
            PlayerControlView.xAnimation.byValue = translateX
            quicker?.layer.add(PlayerControlView.xAnimation, forKey: PlayerControlView.xAnimation.keyPath)
            
            PlayerControlView.xAnimation.byValue = translateX / 1.2
            slower?.layer.add(PlayerControlView.xAnimation, forKey: PlayerControlView.xAnimation.keyPath)
            
            UIView.animate(withDuration: PlayerControlView.xAnimation.duration, animations: {
                slower?.tintColor = UIColor.white
                quicker?.tintColor = UIColor.white
            }) { _ in
                UIView.animate(withDuration: PlayerControlView.xAnimation.duration, animations: {
                    slower?.tintColor = UIColor.lightGray
                    quicker?.tintColor = UIColor.lightGray
                })
            }
        }
    }
    
    @IBAction func exit() {
        removeFromSuperview()
        NotificationCenter.default.post(name: Notification.Name.exitFullscreen, object: self)
    }
    
    @IBAction func gotoEpisodes() {
        removeFromSuperview()
        NotificationCenter.default.post(name: Notification.Name.goToEpisodesView, object: self)
    }
    
    @IBAction func didTap(_ sender: Any) {
        removeFromSuperview()
    }
}
