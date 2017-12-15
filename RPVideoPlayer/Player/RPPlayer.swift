//
//  RPPlayer.swift
//  RPVideoPlayer
//
//  Created by Rin Pham on 12/12/17.
//  Copyright © 2017 Rin Pham. All rights reserved.
//

import UIKit

struct RPPlayer {
    
    public static func initRPPlayer(with url: String) {
        guard let videoURL = URL(string: url) else {
            return
        }
        RPPlayerViewController.shared.videoURL = videoURL
        //RPPlayerViewController.shared.setupPlayer()
    }
    
    public static func showRPPlayer(viewController: UIViewController) {
        RPPlayerViewController.shared.view.frame = viewController.view.frame
        RPPlayerViewController.shared.view.alpha = 0
        RPPlayerViewController.shared.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        UIApplication.shared.keyWindow?.addSubview(RPPlayerViewController.shared.view)
        UIView.animate(withDuration: 0.5, animations: {
            RPPlayerViewController.shared.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            RPPlayerViewController.shared.view.alpha = 1.0
            
            RPPlayerViewController.shared.view.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.keyWindow!.bounds.width, height: UIApplication.shared.keyWindow!.bounds.height)
        }) { (completed) in
            RPPlayerViewController.shared.play()
        }
    }
}

