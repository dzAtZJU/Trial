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
    
    var delegate: VideoWithPlayerView?
    
    @IBOutlet weak var rippleButton: UIButton!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var episodesButton: UIButton!

    @IBOutlet weak var backer: UIView!
    @IBOutlet weak var backer2: UIImageView!
    @IBOutlet weak var backer1: UIImageView!
    @IBOutlet weak var backTip: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
 
    @IBOutlet weak var forwarder: UIView!
    @IBOutlet weak var forwarder1: UIImageView!
    @IBOutlet weak var forwarder2: UIImageView!
    @IBOutlet weak var forwardTip: UILabel!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    private lazy var playIcon = UIImage(named: "play")
    
    private lazy var pauseIcon = UIImage(named: "pause")
    
    private let thumbIcon = UIImage(named: "thumb")
  
    private lazy var xAnimation: CABasicAnimation = {
        let r = CABasicAnimation(keyPath: "position.x")
        r.duration = 0.33
        r.autoreverses = true
        r.repeatCount = 1
        return r
    }()
    
    private var durationString = "00:00"
    
    private var sliderValue: Float = 0 {
        didSet {
            slider.value = sliderValue
            let currentString = dateFormatter.string(from: TimeInterval(sliderValue))!
            progressLabel.text =  currentString.stripZeroHour() + " / " + durationString.stripZeroHour()
        }
    }
    
    private let dateFormatter: DateComponentsFormatter = {
        let r = DateComponentsFormatter()
        r.unitsStyle = .positional
        r.allowedUnits = [.hour, .minute, .second]
        r.zeroFormattingBehavior = .pad
        return r
    }()

    static let shared: PlayerControlView = {
        let r = (Bundle.main.loadNibNamed("PlayerControl", owner: nil, options: nil)!.first! as! PlayerControlView)
        r.installShadowLayer("shadow_player")
        return r
    }()

    func preparePresent(isPlaying: Bool, current: Float, duration: Float?, title: String) {
        slider.setThumbImage(thumbIcon, for: .normal)
        playIconOrPause = isPlaying
        slider.minimumValue = 0
        sliderValue = current
        self.title.text = title
        videoDidReady(duration: duration ?? 0)
    }
    
    func beforeTransition() {
        rippleButton.transform = CGAffineTransform(translationX: 0, y: -5).concatenating(CGAffineTransform(scaleX: 1.02, y: 1.02))
        title.transform = rippleButton.transform
        episodesButton.transform = rippleButton.transform
        
        backer.transform = .init(translationX: -5, y: 0)
        playButton.transform = .init(scaleX: 1.05, y: 1.05)
        forwarder.transform = .init(translationX: 5, y: 0)
    }
    
    func runTransition() {
        rippleButton.transform = .identity
        title.transform = .identity
        episodesButton.transform = .identity
        
        backer.transform = .identity
        playButton.transform = .identity
        forwarder.transform = .identity
    }
    
    func videoDidReady(duration: Float) {
        slider.maximumValue = duration
        durationString = dateFormatter.string(from: TimeInterval(duration))!
    }
    
    @IBAction func exit() {
        delegate?.removePlayerControl(animated: false)
        NotificationCenter.default.post(name: Notification.Name.exitFullscreen, object: self)
    }
    
    @IBAction func gotoEpisodes() {
        delegate?.removePlayerControl(animated: false)
        NotificationCenter.default.post(name: Notification.Name.goToEpisodesView, object: self)
    }
    
    lazy var playAnimator: UIViewPropertyAnimator = {
        let r = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: nil)
        r.pausesOnCompletion = true
        r.addObserver(self, forKeyPath: "running", options: NSKeyValueObservingOptions.new, context: nil)
        return r
    }()
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? UIViewPropertyAnimator == playAnimator && keyPath == "running", let newValue = change?[.newKey] as? Bool, !newValue, playAnimator.isReversed {
            playAnimator.stopAnimation(true)
        }
    }
    
    @IBAction func playTouchedUp() {
        playAnimator.isReversed = true
        playIconOrPause ? delegate?.pause() : delegate?.play()
        playIconOrPause = !playIconOrPause
    }
    
    @IBAction func playTouchedDown() {
        playAnimator.addAnimations {
            self.playButton.transform = .init(scaleX: 0.9, y: 0.9)
        }
        playAnimator.startAnimation()
    }
    
    private var playIconOrPause: Bool! = nil {
        didSet {
            playButton.setImage(playIconOrPause ? pauseIcon : playIcon, for: .normal)
        }
    }
    
    @IBAction func didSlide(_ sender: UISlider, forEvent event: UIEvent) {
        let ended = event.allTouches!.first!.phase != .ended
        isSliding = !ended
        
        let newValue = round(sender.value)
        didSlideTo(newValue, ended: ended)
    }
    
    func slideTo(_ seconds: Float, ended: Bool) {
        isSliding = !ended
        didSlideTo(seconds, ended: ended)
    }
    
    func didPlayedTo(_ seconds: Float) {
        if !isSliding {
            didSlideTo(seconds, ended: false)
        }
    }
    
    private var isSliding = false
    
    private func didSlideTo(_ seconds: Float, ended: Bool) {
        sliderValue = seconds
        
        if ended {
            delegate?.videoView.seek(toSeconds: seconds, allowSeekAhead: true)
        }
    }
    
    @IBAction func didForward(_ sender: Any) {
        animateBackOrForward = false
        delegate?.seekBy(10)
    }
    
    @IBAction func didBack(_ sender: Any) {
        animateBackOrForward = true
        delegate?.seekBy(-10)
    }
    
    private var animateBackOrForward: Bool {
        get {
            return true
        }
        set(newValue) {
            let quicker = newValue ? backer2 : forwarder2
            let slower = newValue ? backer1 : forwarder1
            let tip = newValue ? backTip : forwardTip
            let seeker = newValue ? backer : forwarder
            let translateX: CGFloat  = newValue ? -12 : 12
            
            xAnimation.byValue = translateX * 1.2
            quicker?.layer.add(xAnimation, forKey: xAnimation.keyPath)
            
            xAnimation.byValue = translateX
            slower?.layer.add(xAnimation, forKey: xAnimation.keyPath)
            
            UIView.animate(withDuration: xAnimation.duration, animations: {
                seeker?.alpha = 1
                tip?.alpha = 1
                tip?.transform = .init(translationX: translateX, y: 0)
            }) { _ in
                UIView.animate(withDuration: self.xAnimation.duration, animations: {
                    seeker?.alpha = 0.5
                    tip?.alpha = 0.5
                    tip?.transform = .identity
                })
            }
        }
    }
    
    func baseControlChanged(showed: Bool) {
        playButton.isHidden = showed
        forwarder.isHidden = showed
        backer.isHidden = showed
        backTip.isHidden = showed
        forwardTip.isHidden = showed
    }
}
