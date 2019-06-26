//
//  BasePlayerControl.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/11.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class BasePlayerView: UIView, UIGestureRecognizerDelegate {
    var playerControl: PlayerControlView?
    
    var volumeObserver: NSKeyValueObservation?
    
    var brightObserver: NSKeyValueObservation?
    
    lazy var mpVolume = MPVolumeView()
    
    lazy var volumeSlider = (mpVolume.subviews.first { ($0 as? UISlider) != nil }) as! UISlider
    
    private var progressInSliding: Float!
    
    static let valueProgress: UIProgressView = {
        let r = UIProgressView()
        r.progressTintColor = UIColor.white
        r.trackTintColor = UIColor.clear
        return r
    }()
    
    static let backLayer: CALayer = {
        let r = CALayer()
        r.cornerRadius = 4.5
        r.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        return r
    }()
    
    static let frontLayer: CALayer = {
        let r = CALayer()
        r.anchorPoint = .zero
        r.cornerRadius = 4.5
        r.backgroundColor =  UIColor.white.cgColor
        return r
    }()
    
    static let volumeIcon: CALayer = {
        let r = CALayer()
        r.contents = UIImage(named: "volume")!.cgImage
        r.bounds.size = CGSize(width: 35, height: 27)
        return r
    }()
    
    static let mutedIcon: CALayer = {
        let r = CALayer()
        r.contents = UIImage(named: "muted")!.cgImage
        r.bounds.size = CGSize(width: 35, height: 27)
        return r
    }()
    
    static let brightIcon: CALayer = {
        let r = CALayer()
        r.contents = UIImage(named: "bright")!.cgImage
        r.bounds.size = CGSize(width: 35, height: 35)
        return r
    }()
    
    let panResponder = PlayerPanRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let pan = UIPanGestureRecognizer(target: panResponder, action: #selector(PlayerPanRecognizer.handlePan(_:)))
        addGestureRecognizer(pan)
        pan.delegate = self
        panResponder.deleagte = self
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.delegate = self
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)
        addGestureRecognizer(doubleTap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        addGestureRecognizer(pinch)
        
        mpVolume.frame = CGRect(origin: CGPoint(x: -1, y: -1), size: CGSize(width: 1, height: 1))
        mpVolume.alpha = 0.01
        addSubview(mpVolume)
        
        volumeObserver = AVAudioSession.sharedInstance().observe(\.outputVolume, options: .new) { (_, change) in
            let newValue = CGFloat(change.newValue!)
            self.didSlide(newValue, icon: newValue != 0 ? BasePlayerView.volumeIcon : BasePlayerView.mutedIcon)
        }
        
        brightObserver = UIScreen.main.observe(\.brightness, options: .new) { (_ ,change) in
            self.didSlide(CGFloat(change.newValue!), icon: BasePlayerView.brightIcon)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func oppositeIcon(of icon: CALayer) -> [CALayer] {
        if icon == BasePlayerView.mutedIcon {
            return [BasePlayerView.volumeIcon, BasePlayerView.brightIcon]
        } else if icon == BasePlayerView.volumeIcon {
            return [BasePlayerView.mutedIcon, BasePlayerView.brightIcon]
        } else {
            return [BasePlayerView.volumeIcon, BasePlayerView.mutedIcon]
        }
    }
    
    @objc func handleBright(sender: PlayerPanRecognizer) {
        switch sender.state {
        case .began:
            playerControl?.baseControlChanged(showed: true)
        case .changed:
            UIScreen.main.brightness += -sender.diff / 200
        default:
            return
        }
    }
    
    @objc func handleVolume(sender: PlayerPanRecognizer) {
        switch sender.state {
        case .began:
            playerControl?.baseControlChanged(showed: true)
        case .changed:
            volumeSlider.value += Float( -sender.diff / 200)
        default:
            return
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !((touch.view?.isKind(of: UISlider.self) ?? false) || (touch.view?.isKind(of: UIButton.self) ?? false))
    }
    
    @objc func handleProgress(sender: PlayerPanRecognizer) {
//        switch sender.state {
//        case .began:
//            progressInSliding = delegate?.current
//        case .changed:
//            progressInSliding = (progressInSliding + Float(sender.diff)).limitIn(max: delegate!.duration)
//            playerControl?.slideTo(progressInSliding, ended: false)
//        case .ended:
//            playerControl?.slideTo(progressInSliding, ended: true)
//            progressInSliding = nil
//        default:
//            return
//        }
    }
    
    private func didSlide(_ newScale: CGFloat, icon: CALayer) {
        playerControl?.baseControlChanged(showed: true)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            BasePlayerView.valueProgress.removeFromSuperview()
            BasePlayerView.volumeIcon.removeFromSuperlayer()
            BasePlayerView.mutedIcon.removeFromSuperlayer()
            BasePlayerView.brightIcon.removeFromSuperlayer()
            self.playerControl?.baseControlChanged(showed: false)
        })
        
        if icon.superlayer == nil {
            addSlider(icon: icon)
        }
        
        BasePlayerView.valueProgress.progress = Float(newScale)
    }
    
    private func addSlider(icon: CALayer) {
        BasePlayerView.valueProgress.frame = CGRect(origin: CGPoint(x: bounds.center.x - 80, y: 220), size: CGSize(width: 160, height: 3))
        addSubview(BasePlayerView.valueProgress)
        
        icon.frame.origin = CGPoint(x: bounds.center.x - 17, y: 160)
        layer.addSublayer(icon)
        
        oppositeIcon(of: icon).forEach {
            $0.removeFromSuperlayer()
        }
    }
    
    private func adjustControl(panPuropse: PanPurpose, value: CGFloat) {
        
    }
    
    var timer: Timer?
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if playerControl == nil {
            presentControl()
        } else {
            removePlayerControl()
        }
    }
    
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        pause()
        if playerControl == nil {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                self.presentControl()
            }
        }
    }
    
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            removePlayerControl()
            NotificationCenter.default.post(name: Notification.Name.exitFullscreen, object: self)
        }
    }
    
    func removePlayerControl() {
        UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.playerControl?.removeFromSuperview()
            self.playerControl = nil
        }, completion: nil)
        invalidatePlayerControlTimer()
    }
    
    var playerControlTimer: Timer?
    
    func invalidatePlayerControlTimer() {
        playerControlTimer?.invalidate()
    }
    
    func togglePlay() {}
    
    func presentControl() {}

    func pause() {}
    
    override var next: UIResponder? {
        return nil
    }
    
    func fullSizingSubview(_ subView: UIView) {
        subView.frame = self.bounds
        subView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
