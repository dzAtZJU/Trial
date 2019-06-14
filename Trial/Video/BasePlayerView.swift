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
    
    var panAtLeft = true
    
    var playerControl: PlayerControlView?
    
    var volumeObserver: NSKeyValueObservation?
    
    lazy var mpVolume = MPVolumeView()
    
    lazy var volumeSlider = (mpVolume.subviews.first { ($0 as? UISlider) != nil }) as! UISlider
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        mpVolume.frame = CGRect(origin: CGPoint(x: -1, y: -1), size: CGSize(width: 1, height: 1))
        addSubview(mpVolume)
        volumeObserver = AVAudioSession.sharedInstance().observe(\.outputVolume, options: [.new]) { (_, change) in
            if BasePlayerView.frontLayer.superlayer == nil {
                self.showControl()
            }
            self.runValueAnimation(CGFloat(change.newValue!))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        struct PanData {
            static var lastTranslateY = CGFloat(0)
        }
        switch sender.state {
        case .began:
            PanData.lastTranslateY = sender.translation(in: self).y
            panAtLeft = sender.location(in: self).x < bounds.midX
            showControl()
        case .changed:
            let translateY = sender.translation(in: self).y
            let diff = -(translateY - PanData.lastTranslateY) / 800
            PanData.lastTranslateY = translateY
            adjustControl(diff: diff)
        case .ended:
            removeControl()
        default:
            return
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if CGRect(origin: bounds.center, size: .zero).insetBy(dx: -20, dy: -20).contains(sender.location(in: self)) {
            togglePlay()
            return
        }
        
        if playerControl == nil {
            playerControl = (Bundle.main.loadNibNamed("PlayerControl", owner: nil, options: nil)!.first! as! PlayerControlView)
        }
        
        presentControl()
    }
    
    func togglePlay() {}
    
    func presentControl() {}
    
    private func showControl() {
        BasePlayerView.backLayer.bounds.size = CGSize(width: 160, height: 3)
        BasePlayerView.backLayer.frame.origin = CGPoint(x: bounds.center.x - 80, y: 220)
        layer.addSublayer(BasePlayerView.backLayer)
        
        BasePlayerView.frontLayer.bounds.size = CGSize(width: 160, height: 3)
        BasePlayerView.frontLayer.frame.origin = BasePlayerView.backLayer.frame.origin
        layer.addSublayer(BasePlayerView.frontLayer)
        
        let initialValue = panAtLeft ? Float(UIScreen.main.brightness) : AVAudioSession.sharedInstance().outputVolume
        runValueAnimation(CGFloat(initialValue))
        
        let icon = panAtLeft ? BasePlayerView.brightIcon : initialValue == 0 ? BasePlayerView.mutedIcon : BasePlayerView.volumeIcon
        icon.frame.origin = CGPoint(x: bounds.center.x - 17, y: 160)
        layer.addSublayer(icon)
    }
    
    private func adjustControl(diff: CGFloat) {
        if panAtLeft {
            let newVal = UIScreen.main.brightness + diff
            UIScreen.main.brightness = newVal
            runValueAnimation(newVal)
        } else {
            volumeSlider.value += Float(diff)
        }
    }
    
    private func removeControl() {
        BasePlayerView.backLayer.removeFromSuperlayer()
        BasePlayerView.frontLayer.removeFromSuperlayer()
        BasePlayerView.volumeIcon.removeFromSuperlayer()
        BasePlayerView.mutedIcon.removeFromSuperlayer()
        BasePlayerView.brightIcon.removeFromSuperlayer()
    }
    
    private func runValueAnimation(_ value: CGFloat) {
        BasePlayerView.frontLayer.bounds.size.width = BasePlayerView.backLayer.bounds.size.width * value
        if !panAtLeft {
            let (newIcon, oldIcon) = value == 0 ? (BasePlayerView.mutedIcon, BasePlayerView.volumeIcon): (BasePlayerView.mutedIcon, BasePlayerView.volumeIcon)
            layer.addSublayer(newIcon)
            oldIcon.removeFromSuperlayer()
        }
    }

    override var next: UIResponder? {
        return nil
    }
}
