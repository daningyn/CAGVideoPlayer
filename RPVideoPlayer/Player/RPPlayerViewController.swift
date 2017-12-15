//
//  RPPlayerViewController.swift
//  RPVideoPlayer
//
//  Created by Rin Pham on 12/12/17.
//  Copyright © 2017 Rin Pham. All rights reserved.
//

import UIKit
import AVKit

class RPPlayerViewController: UIViewController {

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var togglePlayButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var entireTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    var videoURL: URL!
    var player: AVPlayer!
    
    static let shared = RPPlayerViewController(nibName: "RPPlayerViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupPlayer()
    }
    
    
    @IBAction func togglePlayButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func fullScreenButtonTapped(_ sender: UIButton) {
        
    }
    
    func setupPlayer() {
        player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.playerView.bounds
        self.playerView.layer.addSublayer(playerLayer)
    }
    
    func play() {
         player.play()
    }
}
