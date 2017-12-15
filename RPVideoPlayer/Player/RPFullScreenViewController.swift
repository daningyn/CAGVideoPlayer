//
//  RPFullScreenViewController.swift
//  RPVideoPlayer
//
//  Created by Rin Pham on 12/12/17.
//  Copyright © 2017 Rin Pham. All rights reserved.
//

import UIKit
import AVKit

class RPFullScreenViewController: UIViewController {

    //MARK: -IBOutlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var togglePlayButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var entireTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    //MARK: -Properties
    var videoURL: URL!
    var player: AVPlayer!
    var isPlaying: Bool {
        return self.player.rate != 0 && self.player.error == nil
    }
    var timer: Timer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
