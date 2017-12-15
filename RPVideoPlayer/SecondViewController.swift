//
//  SecondViewController.swift
//  RPVideoPlayer
//
//  Created by Rin Pham on 12/14/17.
//  Copyright © 2017 Rin Pham. All rights reserved.
//

import UIKit
import AVKit

class SecondViewController: UIViewController {

    var statusBarHidden = false
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addPlayer()
    }
    
    func addPlayer() {
        let playerView = RPPlayerView.initWith(frame: CGRect(x: 0, y: 200, width: self.view.bounds.width, height: self.view.bounds.width*9/16), videoURL: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!, titleVideo: "Video Hay", autorotate: true, viewController: self)
        playerView.playerViewDelegate = self
        playerView.setPlayerToSmallFullScreenAutorotate()
        self.view.addSubview(playerView)
    }
    
}

extension SecondViewController: RPPlayerViewDelegate {
    func togglePlayButtonTapped(_ playerView: RPPlayerView, senderButton: UIButton) {
        if playerView.isPlaying {
            playerView.pause()
        } else {
            playerView.play()
        }
    }
    
    func sliderValueChanged(_ playerView: RPPlayerView, senderSlider: UISlider) {
        guard let currentItem = playerView.player.currentItem else {
            return
        }
        let seconds = Double(senderSlider.value)*currentItem.duration.seconds
        playerView.player.seek(to: CMTime(seconds: seconds, preferredTimescale: 1))
    }
    
    func fullScreenButtonTapped(_ playerView: RPPlayerView, senderButton: UIButton) {
        if playerView.isFullScreen {
            playerView.setPlayerToSmallFullScreenAutorotate()
            self.statusBarHidden = false
        } else {
            playerView.setPlayerToFullScreenAutorotate()
            self.statusBarHidden = true
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func replayButtonTapped(_ playerView: RPPlayerView, senderButton: UIButton) {
        playerView.replay()
    }
    
    func handleTapGesturePlayer(_ playerView: RPPlayerView) {
        
    }
    
    func deviceDidRotate(_ playerView: RPPlayerView, currentDeviceOrientation: UIInterfaceOrientation) {
        switch currentDeviceOrientation {
        case .landscapeLeft:
            playerView.setPlayerToFullScreenAutorotate()
            self.statusBarHidden = true
        case .landscapeRight:
            playerView.setPlayerToFullScreenAutorotate()
            self.statusBarHidden = true
        case .portrait:
            playerView.setPlayerToSmallFullScreenAutorotate()
            self.statusBarHidden = false
        default:
            self.statusBarHidden = true
            break
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
