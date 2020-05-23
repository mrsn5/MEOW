//
//  CatWalk.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 20.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class CatWalk: UIView {
    
    @IBOutlet weak var paw1: UIImageView!
    @IBOutlet weak var paw2: UIImageView!
    @IBOutlet weak var paw3: UIImageView!
    @IBOutlet weak var paw4: UIImageView!
    
    private var paws: [UIImageView] = []
    private var startPositions: [CGRect] = []
    private var pawTimers: [Timer] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        paws = [paw1, paw2, paw3, paw4]
        for p in paws {
            p.alpha = 0
            startPositions.append(p.frame)
        }
    }
    
    func setPaws(type: Int = Int.random(in: 1...4)) {
        for p in paws {
            p.image = UIImage(named: "paw\(type)")
        }
    }
    
    func startPawAnimation() {
        let now: DispatchTime = .now()
        windUpTimer(for: paw1, withDelay: now + .milliseconds(400))
        windUpTimer(for: paw2, withDelay: now + .milliseconds(500))
        windUpTimer(for: paw3, withDelay: now + .milliseconds(900))
        windUpTimer(for: paw4, withDelay: now + .milliseconds(1000))
    }
    
    func stopAnimation() {
        for t in pawTimers {
            t.invalidate()
        }
        pawTimers.removeAll()
        for p in paws {
            p.alpha = 0
        }
    }
    
    func resetPostion() {
        for pp in zip(paws, startPositions) {
            pp.0.frame = pp.1
        }
    }
    
    
    func windUpTimer(for imageView: UIImageView, withDelay delay: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            guard let self = self else {return}
            self.pawTimers.append(
                Timer.scheduledTimer(
                    timeInterval: 1.0,
                    target: self,
                    selector: #selector(self.showPaw(timer:)),
                    userInfo: ["paw": imageView],
                    repeats: true)
            )
        }
    }
    
    @objc func showPaw(timer: Timer) {
        if  let userInfo = timer.userInfo as? [String: UIImageView],
            let imageView = userInfo["paw"] {
            imageView.alpha = 1.0
//            UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveLinear, animations: {
//                imageView.alpha = 0.0
//            }) { _ in
//                let frame = imageView.frame
//                let y = frame.minY - 80 + (frame.minY < 0 ? self.frame.height + 80 : 0)
//                imageView.frame = CGRect(x: frame.minX, y: y, width: frame.width, height: frame.height)
//            }
            
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750)) {
                            imageView.alpha = 0.0
                            let frame = imageView.frame
                            let y = frame.minY - 80 + (frame.minY < 0 ? self.frame.height + 80 : 0)
                            imageView.frame = CGRect(x: frame.minX, y: y, width: frame.width, height: frame.height)
                        }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        startPositions.removeAll()
        for p in paws {
            startPositions.append(p.frame)
        }
    }
}
