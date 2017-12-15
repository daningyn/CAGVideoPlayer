//
//  ViewController.swift
//  RPVideoPlayer
//
//  Created by Rin Pham on 12/12/17.
//  Copyright © 2017 Rin Pham. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var statusBarHidden = false
    var playerView: RPPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         self.addPlayerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }
    
    func addPlayerView() {
        playerView = RPPlayerView.initWith(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: self.view.bounds.width*9/16), videoURL: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!, titleVideo: "Video Hay", autorotate: false, viewController: self)
        playerView.setupProgressView(gradientColors: [UIColor(hexString:"#FF2E53").cgColor, UIColor(hexString:"#FF2E8E").cgColor, UIColor(hexString: "#FF2EE9").cgColor])
        playerView.playerViewDelegate = self
        self.view.addSubview(playerView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSecondVC" {
            self.playerView.pause()
        }
    }
}


//#MARK: - PlayerViewDelegate
extension ViewController: RPPlayerViewDelegate {
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
            playerView.showNormalScreen()
            self.statusBarHidden = false
            self.navigationController?.navigationBar.isHidden = false
        } else {
            playerView.showFullScreen()
            self.statusBarHidden = true
            self.navigationController?.navigationBar.isHidden = true
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func replayButtonTapped(_ playerView: RPPlayerView, senderButton: UIButton) {
        playerView.replay()
    }
    
    func handleTapGesturePlayer(_ playerView: RPPlayerView) {
        
    }
}




