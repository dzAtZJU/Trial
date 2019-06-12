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
    
    var initialValue: Float = 0
    
    var playerControl: PlayerControlView?
    
    var volumeObserver: NSKeyValueObservation?
    
    lazy var mpVolume = MPVolumeView()
    
    lazy var volumeSlider = (mpVolume.subviews.first { ($0 as? UISlider) != nil }) as! UISlider
    
    lazy var backLayer: CALayer = {
        let r = CALayer()
        r.bounds = CGRect(origin: bounds.center, size: CGSize(width: 160, height: 3))
        r.frame.origin = CGPoint(x: bounds.center.x - 80, y: 160)
        r.cornerRadius = 4.5
        r.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        return r
    }()
    
    lazy var frontLayer: CALayer = {
        let r = CALayer()
        r.anchorPoint = .zero
        r.bounds = CGRect(origin: bounds.center, size: CGSize(width: 160, height: 3))
        r.frame.origin = backLayer.frame.origin
        r.cornerRadius = 4.5
        r.backgroundColor =  UIColor.white.cgColor
        return r
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        mpVolume.frame = .zero
        addSubview(mpVolume)
        volumeObserver = AVAudioSession.sharedInstance().observe(\.outputVolume, options: [.new]) { (_, change) in
            if self.frontLayer.superlayer == nil {
                self.showControl()
            }
            self.runVolumeAnimation(CGFloat(change.newValue!))
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
            print("diff: \(diff)")
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
        initialValue = AVAudioSession.sharedInstance().outputVolume
        print("initial: \(initialValue)")
        runVolumeAnimation(CGFloat(initialValue))
        layer.addSublayer(backLayer)
        layer.addSublayer(frontLayer)
    }
    
    private func adjustControl(diff: CGFloat) {
        volumeSlider.value = (volumeSlider.value + Float(diff)).limitInOne()
        print("new: \(volumeSlider.value)")
    }
    
    private func removeControl() {
        backLayer.removeFromSuperlayer()
        frontLayer.removeFromSuperlayer()
    }
    
    private func runVolumeAnimation(_ value: CGFloat) {
        frontLayer.bounds.size.width = backLayer.bounds.size.width * value
    }

    override var next: UIResponder? {
        return nil
    }
}
