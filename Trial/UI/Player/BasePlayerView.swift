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

class BasePlayerView: UIView {
    var delegate: VideoWithPlayerView?
    
    var playerControl: PlayerControlView?
    
    var volumeObserver: NSKeyValueObservation?
    
    var brightObserver: NSKeyValueObservation?
    
    lazy var mpVolume = MPVolumeView()
    
    lazy var volumeSlider = (mpVolume.subviews.first { ($0 as? UISlider) != nil }) as! UISlider
    
    private var progressInSliding: Float!
    
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
        
        addGestureRecognizer(UIPanGestureRecognizer(target: panResponder, action: #selector(PlayerPanRecognizer.handlePan(_:))))
        panResponder.addTargert(self, action: #selector(handleBright(sender:)), purpose: .leftVertical)
        panResponder.addTargert(self, action: #selector(handleVolume(sender:)), purpose: .rightVertical)
        panResponder.addTargert(self, action: #selector(handleProgress(sender:)), purpose: .horizontal)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        mpVolume.frame = CGRect(origin: CGPoint(x: -1, y: -1), size: CGSize(width: 1, height: 1))
        mpVolume.alpha = 0.01
        addSubview(mpVolume)
        
        volumeObserver = AVAudioSession.sharedInstance().observe(\.outputVolume, options: .new) { (_, change) in
            self.didSlide(CGFloat(change.newValue!), icon: BasePlayerView.volumeIcon)
        }
        
        brightObserver = UIScreen.main.observe(\.brightness, options: .new) { (_ ,change) in
            self.didSlide(CGFloat(change.newValue!), icon: BasePlayerView.brightIcon)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleBright(sender: PlayerPanRecognizer) {
        switch sender.state {
        case .began:
            playerControl?.baseControlChanged(showed: true)
        case .changed:
            UIScreen.main.brightness += -sender.diff / 500
        case .ended:
            removeControl()
            playerControl?.baseControlChanged(showed: false)
        default:
            return
        }
    }
    
    @objc func handleVolume(sender: PlayerPanRecognizer) {
        switch sender.state {
        case .began:
            playerControl?.baseControlChanged(showed: true)
        case .changed:
            volumeSlider.value += Float( -sender.diff / 500)
        case .ended:
            removeControl()
            playerControl?.baseControlChanged(showed: false)
        default:
            return
        }
    }
    
    @objc func handleProgress(sender: PlayerPanRecognizer) {
        switch sender.state {
        case .began:
            progressInSliding = delegate?.current
        case .changed:
            progressInSliding = (progressInSliding + Float(sender.diff)).limitIn(max: delegate!.duration)
            playerControl?.slideTo(progressInSliding, ended: false)
        case .ended:
            playerControl?.slideTo(progressInSliding, ended: true)
            progressInSliding = nil
        default:
            return
        }
    }
    
    private func didSlide(_ newScale: CGFloat, icon: CALayer) {
        if icon.superlayer == nil {
            addSlider(icon: icon)
        }
        
        BasePlayerView.frontLayer.bounds.size.width = 160 * newScale
    }
    
    private func addSlider(icon: CALayer) {
        BasePlayerView.backLayer.bounds.size = CGSize(width: 160, height: 3)
        BasePlayerView.backLayer.frame.origin = CGPoint(x: bounds.center.x - 80, y: 220)
        layer.addSublayer(BasePlayerView.backLayer)
        
        BasePlayerView.frontLayer.bounds.size = CGSize(width: 160, height: 3)
        BasePlayerView.frontLayer.frame.origin = BasePlayerView.backLayer.frame.origin
        layer.addSublayer(BasePlayerView.frontLayer)
        
        icon.frame.origin = CGPoint(x: bounds.center.x - 17, y: 160)
        layer.addSublayer(icon)
    }
    
    private func adjustControl(panPuropse: PanPurpose, value: CGFloat) {
        
    }
    
    private func removeControl() {
        BasePlayerView.backLayer.removeFromSuperlayer()
        BasePlayerView.frontLayer.removeFromSuperlayer()
        BasePlayerView.volumeIcon.removeFromSuperlayer()
        BasePlayerView.mutedIcon.removeFromSuperlayer()
        BasePlayerView.brightIcon.removeFromSuperlayer()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if CGRect(origin: bounds.center, size: .zero).insetBy(dx: -20, dy: -20).contains(sender.location(in: self)) {
            togglePlay()
            return
        }
        
        if playerControl == nil {
            playerControl = PlayerControlView.loadAnInstance()
        }
        
        presentControl()
    }
    
    func togglePlay() {}
    
    func presentControl() {}

    override var next: UIResponder? {
        return nil
    }
}
