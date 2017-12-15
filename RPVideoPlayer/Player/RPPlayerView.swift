//
//  RPPlayerView.swift
//  RPVideoPlayer
//
//  Created by Rin Pham on 12/12/17.
//  Copyright © 2017 Rin Pham. All rights reserved.
//

import UIKit
import AVKit

@objc protocol RPPlayerViewDelegate: class {
    
    func togglePlayButtonTapped(_ playerView: RPPlayerView, senderButton: UIButton)
    func sliderValueChanged(_ playerView: RPPlayerView, senderSlider: UISlider)
    func fullScreenButtonTapped(_ playerView: RPPlayerView, senderButton: UIButton)
    func replayButtonTapped(_ playerView: RPPlayerView, senderButton: UIButton)
    func handleTapGesturePlayer(_ playerView: RPPlayerView)
    
    @objc optional func deviceDidRotate(_ playerView: RPPlayerView, currentDeviceOrientation: UIInterfaceOrientation)
}

class RPPlayerView: UIView {

    //MARK: - IBOutlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var togglePlayButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var entireTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: CustomSliderView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var playerControlView: UIView!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Properties
    weak var playerViewDelegate: RPPlayerViewDelegate?
    weak var viewController: UIViewController!
    
    var videoURL: URL!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying: Bool {
        return self.player.rate != 0 && self.player.error == nil
    }
    var timer: Timer! = nil
    var currentDeviceOrientation: () -> UIInterfaceOrientation = {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portrait:
            return .portrait
        default:
            return .unknown
        }
    }
    var normalFrame: CGRect!
    var isFullScreen = false
    
    //MARK: - Init override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerControlView.setGradientBackground(from: UIColor.black.withAlphaComponent(0.5), to: .clear)
        self.titleView.setGradientBackground(from: .clear, to: UIColor.black.withAlphaComponent(0.5))
    }

    deinit {
        print("DEINIT PlayerView")
        self.timer.invalidate()
        self.timer = nil
    }
    
    //MARK: -IBAction
    @IBAction func togglePlayButtonTapped(_ sender: UIButton) {
        self.playerViewDelegate?.togglePlayButtonTapped(self, senderButton: sender)
    }
    @IBAction func fullScreenButtonTapped(_ sender: UIButton) {
        self.playerViewDelegate?.fullScreenButtonTapped(self, senderButton: sender)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.playerViewDelegate?.sliderValueChanged(self, senderSlider: sender)
    }
    
    @IBAction func replayButtonTapped(_ sender: UIButton) {
        self.playerViewDelegate?.replayButtonTapped(self, senderButton: sender)
    }
    
    //MARK: - Init func
    class func shared() -> RPPlayerView {
        return UINib( nibName: "RPPlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RPPlayerView
    }
    
    public static func initWith(frame: CGRect, videoURL: URL, titleVideo: String, autorotate: Bool, viewController: UIViewController) -> RPPlayerView {
        let rpPlayerView = UINib( nibName: "RPPlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RPPlayerView
        rpPlayerView.indicatorView.startAnimating()
        
        rpPlayerView.frame = frame
        rpPlayerView.videoURL = videoURL
        rpPlayerView.titleLabel.text = titleVideo
        rpPlayerView.normalFrame = frame
        rpPlayerView.replayButton.isHidden = true
        rpPlayerView.player = AVPlayer(url: videoURL)
        rpPlayerView.playerLayer = AVPlayerLayer(player: rpPlayerView.player)
        rpPlayerView.playerLayer.frame.size = frame.size
        rpPlayerView.playerLayer.frame.origin = CGPoint(x: 0, y: 0)
        rpPlayerView.playerView.layer.addSublayer(rpPlayerView.playerLayer)
        rpPlayerView.play()
        
        rpPlayerView.timer = Timer.scheduledTimer(timeInterval: 0.5, target: rpPlayerView, selector: #selector(rpPlayerView.updateProgressBarAndTime), userInfo: rpPlayerView, repeats: true)
        rpPlayerView.playerView.addGestureRecognizer(UITapGestureRecognizer(target: rpPlayerView, action: #selector(rpPlayerView.handleTapGesturePlayer)))
        
        if autorotate {
            NotificationCenter.default.addObserver(rpPlayerView, selector: #selector(rpPlayerView.deviceDidRotate), name: .UIDeviceOrientationDidChange, object: nil)
        }
        
        rpPlayerView.viewController = viewController
        return rpPlayerView
    }
    
    //MARK: - Support method
    
    open func setupProgressView(gradientColors: [CGColor]) {
        self.progressSlider.gradientLayer.colors = gradientColors
    }
    
    open func setupPlayerAndPlayVideo(frame: CGRect, videoURL: URL, titleVideo: String) {
        self.indicatorView.startAnimating()
        
        self.frame = frame
        self.videoURL = videoURL
        self.titleLabel.text = titleVideo
        self.normalFrame = self.frame
        self.replayButton.isHidden = true
        self.player = AVPlayer(url: videoURL)
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.frame.size = self.frame.size
        self.playerLayer.frame.origin = CGPoint(x: 0, y: 0)
        self.playerView.layer.addSublayer(playerLayer)
        self.play()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateProgressBarAndTime), userInfo: nil, repeats: true)
        self.playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesturePlayer)))
        
        //NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate), name: .UIDeviceOrientationDidChange, object: nil) // Autorotate option
    }
    
    //MARK: - Video Action
    func play() {
        self.player.play()
        self.togglePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        self.hidePlayerControlsAfter(seconds: DispatchTime(uptimeNanoseconds: 4))
    }
    
    func pause() {
        self.player.pause()
        self.togglePlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
    }
    
    func replay() {
        self.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        self.play()
    }
    
    func handleSliderValueChange(_ senderSlider: UISlider) {
        guard let currentItem = self.player.currentItem else {
            return
        }
        let seconds = Double(senderSlider.value)*currentItem.duration.seconds
        self.player.seek(to: CMTime(seconds: seconds, preferredTimescale: 1))
    }
    
    @objc func handleTapGesturePlayer() {
        self.showPlayerControlsThenHide()
        self.playerViewDelegate?.handleTapGesturePlayer(self)
    }
    
    //MARK: - Toggle Screen with not autorotate opption
    func showFullScreen() {
        self.frame.size.height = UIScreen.main.bounds.size.width
        self.frame.size.width = UIScreen.main.bounds.size.height
        self.center = self.viewController.view.center
        self.playerLayer.frame = self.frame
        self.playerLayer.frame.origin = CGPoint(x: 0, y: 0)
        self.transform = CGAffineTransform(rotationAngle: .pi/2)
        self.fullScreenButton.setImage(#imageLiteral(resourceName: "unfullscreen"), for: .normal)
        self.isFullScreen = true
        self.viewController.navigationController?.navigationBar.isHidden = true
    }
    
    func showNormalScreen() {
        self.transform = CGAffineTransform(rotationAngle: 0)
        self.frame.size.width = self.normalFrame.size.width
        self.frame.size.height = self.normalFrame.size.height
        self.frame.origin = self.normalFrame.origin
        self.playerLayer.frame.size = self.frame.size
        self.playerLayer.frame.origin = CGPoint(x: 0, y: 0)
        self.fullScreenButton.setImage(#imageLiteral(resourceName: "fullscreen"), for: .normal)
        self.isFullScreen = false
        self.viewController.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Toggle Screen with autorotate opption
    func toggleFullScreenAutorotate() {
        if self.isFullScreen {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }
    
    func setPlayerToNormalScreenAutorotate() {
        self.frame.size.width = self.normalFrame.size.width
        self.frame.size.height = self.normalFrame.size.height
        self.frame.origin = self.normalFrame.origin
        self.playerView.frame.size = self.frame.size
        self.playerView.frame.origin = CGPoint(x: 0, y: 0)
        self.playerLayer.frame = self.frame
        self.playerLayer.frame.origin = CGPoint(x: 0, y: 0)
        self.transform = CGAffineTransform(rotationAngle: 0)
        self.fullScreenButton.setImage(#imageLiteral(resourceName: "fullscreen"), for: .normal)
        self.isFullScreen = false
        self.viewController.navigationController?.navigationBar.isHidden = false
    }
    
    func setPlayerToFullScreenAutorotate() {
        if currentDeviceOrientation() == .landscapeLeft {
            self.transform = CGAffineTransform(rotationAngle: .pi/2)
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
        } else {
            self.frame.size.height = UIScreen.main.bounds.size.width
            self.frame.size.width = UIScreen.main.bounds.size.height
            self.center = self.viewController.view.center
            self.playerLayer.frame = self.frame
            self.playerLayer.frame.origin = CGPoint(x: 0, y: 0)
            self.transform = CGAffineTransform(rotationAngle: -.pi/2)
        }
        self.fullScreenButton.setImage(#imageLiteral(resourceName: "unfullscreen"), for: .normal)
        self.isFullScreen = true
        self.viewController.navigationController?.navigationBar.isHidden = true
    }
    
    func setPlayerToSmallFullScreenAutorotate() {
        self.transform = CGAffineTransform(rotationAngle: 0)
        self.frame.size.height = UIScreen.main.bounds.size.height
        self.frame.size.width = UIScreen.main.bounds.size.width
        self.center = self.viewController.view.center
        
        self.playerView.frame.size = self.normalFrame.size
        self.playerView.frame.origin = self.normalFrame.origin
        self.playerLayer.frame = self.playerView.frame
        self.playerLayer.frame.origin = self.playerView.frame.origin
        
        self.fullScreenButton.setImage(#imageLiteral(resourceName: "fullscreen"), for: .normal)
        self.isFullScreen = false
        self.viewController.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func deviceDidRotate() {
        if self.isFullScreen && currentDeviceOrientation() == .landscapeRight {
            return
        }
        self.playerViewDelegate?.deviceDidRotate!(self, currentDeviceOrientation: currentDeviceOrientation())
    }
    
    func handleDeviceDidRotate() {
        switch currentDeviceOrientation() {
        case .landscapeLeft:
            setPlayerToFullScreenAutorotate()
        case .landscapeRight:
            setPlayerToFullScreenAutorotate()
        case .portrait:
            setPlayerToSmallFullScreenAutorotate()
        default:
            break
        }
    }
    
    //MARK: - Setup and update time
    func setEntireTime() {
        guard let currentItem = player.currentItem else {
            return
        }
        let entireTimeInSecond = CMTimeGetSeconds(currentItem.duration)
        
        let mins = entireTimeInSecond/60
        let seconds = entireTimeInSecond.truncatingRemainder(dividingBy: 60)
        
        let timeFormater = NumberFormatter()
        timeFormater.minimumIntegerDigits = 2
        timeFormater.minimumFractionDigits = 0
        timeFormater.roundingMode = .down
        
        guard let minsString = timeFormater.string(from: NSNumber(value: mins)), let secondsString = timeFormater.string(from: NSNumber(value: seconds)) else {
            return
        }
        self.entireTimeLabel.text = "\(minsString):\(secondsString)"
    }
    
    @objc func updateProgressBarAndTime() {
        guard let currentItem = player.currentItem else {
            return
        }
        let currentTimeInSecond = CMTimeGetSeconds(player.currentTime())
        
        let mins = currentTimeInSecond/60
        let seconds = currentTimeInSecond.truncatingRemainder(dividingBy: 60)
        
        let timeFormater = NumberFormatter()
        timeFormater.minimumIntegerDigits = 2
        timeFormater.minimumFractionDigits = 0
        timeFormater.roundingMode = .down
        
        guard let minsString = timeFormater.string(from: NSNumber(value: mins)), let secondsString = timeFormater.string(from: NSNumber(value: seconds)) else {
            return
        }
        
        self.currentTimeLabel.text = "\(minsString):\(secondsString)"
        
        self.progressSlider.value = Float(CMTimeGetSeconds(player.currentTime())/CMTimeGetSeconds(currentItem.duration))
        self.setEntireTime()
        
        if player.status == AVPlayerStatus.readyToPlay {
            self.indicatorView.stopAnimating()
        }
        //Show replay button
        if self.progressSlider.value == 1.0 {
            self.pause()
            self.showPlayerControls()
            self.replayButton.isHidden = false
        } else {
            self.replayButton.isHidden = true
        }
    }
    
    //MARK: - Animation player control view and title view
    func hidePlayerControlsAfter(seconds: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.hidePlayerControls()
        }
    }
    
    func hidePlayerControls() {
        if self.isPlaying {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
                self.playerControlView.alpha = 0.0
                self.titleView.alpha = 0.0
            }, completion: nil)
        }
    }
    
    func showPlayerControlsThenHide() {
        self.showPlayerControls()
        self.hidePlayerControlsAfter(seconds: DispatchTime(uptimeNanoseconds: 4))
    }
    
    func showPlayerControls() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            self.playerControlView.alpha = 1.0
            self.titleView.alpha = 1.0
        }, completion: nil)
    }
    
}
