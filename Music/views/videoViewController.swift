//
//  videoViewController.swift
//  Music
//
//  Created by Atheer on 2018-06-11.
//  Copyright © 2018 Atheer. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class videoViewController: UIViewController, UIWebViewDelegate{
    
    var videoID: String?
    var videoTitle: String?
    var videoChannelTitle: String?
    var VidHeight: CGFloat = 0.0
    var VidWidth: CGFloat = 0.0
    var isPlaying = true
    var timer:Timer!
    var playerIsNotDismissed = true
    var videosID: [String] = []
    var videosTitles: [String] = []
    var videosChannelTitle: [String] = []
    var i = Int()
    var hasSeeked = false
    
    // programmaticly creating everything that i need
    
    lazy var VideoWebView: UIWebView = {
        let webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.delegate = self
        webView.allowsInlineMediaPlayback = true
        webView.mediaPlaybackRequiresUserAction = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        return webView
    }()
    
    
    let SeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let currentTimeLabel = customLabel(startText: "00:00", isBold: true, fontSize: 13)
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .touchUpInside)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(handleVideoSlider), for: .valueChanged)
        
        return slider
    }()
    
    // getting video duration and converting it to float, we take our slider value times total duration how many seconds we need to seek, if we slider to the mid wau of the song then it 0.5 * videoduartion and we get how many seconds we need to seek to that time
    @objc func handleSliderChange() {


        guard let videoDuration = VideoWebView.stringByEvaluatingJavaScript(from: "ytplayer.getDuration()")else { return }
        
        let videoDurationInFloat = (videoDuration as NSString).floatValue

        let value = videoSlider.value * videoDurationInFloat
        
        VideoWebView.stringByEvaluatingJavaScript(from: "ytplayer.seekTo(\(value), true)")
        
        // most likely will be false becuase this happens after value has changed and hasSeeked is true in that statment
        hasSeeked = !hasSeeked
        
    }
    
    @objc func handleVideoSlider() {
        //most likely will be true
       hasSeeked = !hasSeeked
        
    }
    
    let videoLengthLabel = customLabel(startText: "00:00", isBold: true, fontSize: 13)
    
    let videoTitleLabel = customLabel(startText: "", isBold: true, fontSize: 18)
    
    let videoChanelTitleLabel = customLabel(startText: "", isBold: false, fontSize: 0)
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var playPauseButton: UIButton = {
        let button = customButton(startImage: "pause")
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    
    // isplaying is set to true so when we are playing the we want to pause the video also change the button image plus the most imprortant part is that we switch the boolean of isPlaying so now it is false becuase have pressed the pause and when it false we do play the and the same thing as we paused
    
    @objc func handlePlayPause() {
        
        if isPlaying {
            
            VideoWebView.stringByEvaluatingJavaScript(from: "ytplayer.pauseVideo()")
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            
            
        } else {
            
            VideoWebView.stringByEvaluatingJavaScript(from: "ytplayer.playVideo()")
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            
        }
        
        isPlaying = !isPlaying
        
    }
    
    lazy var forwardButton: UIButton = {
        let button = customButton(startImage: "skipNext")
        button.addTarget(self, action: #selector(playNextVideo), for: .touchUpInside)
        return button
    }()
    
    @objc func playNextVideo() {
        
        i += 1
        
        if i > 14 {
            i = 14
        }
        
        playNextPreviousVideo(nextPrevoiusInt: i)
//        print(i)
       
    }
    
    lazy var backwordButton: UIButton = {
        let button = customButton(startImage: "previous")
        button.addTarget(self, action: #selector(handlePlayPrevoiusVideo), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlayPrevoiusVideo() {
        
        i += -1
        
        if i < 0 {
            i = 0
        }
        
        playNextPreviousVideo(nextPrevoiusInt: i)
//        print(i)
        
    }
    
    lazy var downloadButton: UIButton = {
        let button = customButton(startImage: "arrowDown")
        button.addTarget(self, action: #selector(downloadSelectedVideo), for: .touchUpInside)
        return button
    }()
    
    @objc func downloadSelectedVideo() {
        print("123")
    }
    
    lazy var listButton: UIButton = {
        let button = customButton(startImage: "listOrder")
        button.addTarget(self, action: #selector(handleShowList), for: .touchUpInside)
        return button
    }()
    
    // when we show the list we stop the video for now and we get acces to the view controller we set the value playerIsNotDismissed becaise we later pass the value to the view controller and decide how it will look becuase they look different though even they are they same viewController, we show the viewController and set back playerIsNotDismissed
    @objc func handleShowList() {
        
        VideoWebView.stringByEvaluatingJavaScript(from: "ytplayer.stopVideo()")
        
        let vc = self.navigationController?.viewControllers[0] as! ViewController
        
         playerIsNotDismissed = !playerIsNotDismissed
        
        if !playerIsNotDismissed {
            print("playerDismissed")
            
            vc.isPlayerNotDismissed = playerIsNotDismissed

            navigationController?.popToRootViewController(animated: true)
            
             playerIsNotDismissed = !playerIsNotDismissed
            
        }
    }
    
    // this if because the next view contoller will have a navigation bar and we set here becuase if we don't then user will briefly see nothing and in then see navigationbar so we do this for more transation of removing and enbaling navigatioBar
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        setupDeviceHeightAndWidth()
        
        guard let vidId = videoID else { return }
        
        playVideo(videoId: vidId)

        
        let index = 0
        i = index
    }
    
    let volumeDownImage = customUIImageView(startImage: "volumeDown")
    
    let volumeUpImage = customUIImageView(startImage: "volumeUp")
    
    lazy var volumeSlider: MPVolumeView = {
        let slider = MPVolumeView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setVolumeThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        slider.setRouteButtonImage(#imageLiteral(resourceName: "airPlay"), for: .normal)
        return slider
    }()
    
    let replayButton: UIButton = {
        let button = customButton(startImage: "replay")
        return button
    }()
    
    let shuffleButton: UIButton = {
        let button = customButton(startImage: "shuffle")
        return button
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        let slideDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissVideoViewController))
        slideDownGesture.direction = .down
        view.addGestureRecognizer(slideDownGesture)
        
    }
    
    // invalidate timer becuase it still gets called
    @objc func handleDismissVideoViewController() {
        
        timer?.invalidate()
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addingSubviewsToView()
        
        customVolumeSliderColor()
        
        customVolumeSliderButtonColor()
        
        setupAnchors()
        
    }
    
    func setupDeviceHeightAndWidth() {
        
        let width = self.view.frame.size.width
        let phoneHeight = self.view.frame.size.height / 2.5
        let height = width/320 * phoneHeight.rounded(.toNearestOrAwayFromZero)
        
        VidWidth = width
        VidHeight = height
        
    }
    
    func setupAnchors() {
        
        //videoWebView
        
        VideoWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        VideoWebView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        VideoWebView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        VideoWebView.heightAnchor.constraint(equalToConstant: VidHeight).isActive = true
        
        //sepeartorLine
        
        SeperatorView.topAnchor.constraint(equalTo: VideoWebView.bottomAnchor).isActive = true
        SeperatorView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        SeperatorView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        SeperatorView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        //currentTimeLabel
        
        currentTimeLabel.topAnchor.constraint(equalTo: SeperatorView.bottomAnchor, constant: 5).isActive = true
        currentTimeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5).isActive = true
        currentTimeLabel.rightAnchor.constraint(equalTo: videoSlider.leftAnchor, constant: -5).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // videoSlider
        
        videoSlider.topAnchor.constraint(equalTo: SeperatorView.bottomAnchor).isActive = true
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: -5).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //videoLengthLabel
        
        videoLengthLabel.topAnchor.constraint(equalTo: SeperatorView.bottomAnchor, constant: 5).isActive = true
        videoLengthLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // videoTitleLabel
        
        videoTitleLabel.text = videoTitle
        
        videoTitleLabel.topAnchor.constraint(equalTo: videoSlider.bottomAnchor, constant: 10).isActive = true
        videoTitleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        videoTitleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        videoTitleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        //videoChannelTitle
        
        videoChanelTitleLabel.text = videoChannelTitle
        
        videoChanelTitleLabel.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: 5).isActive = true
        videoChanelTitleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        videoChanelTitleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        videoChanelTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // buttonStackView
        
        buttonStackView.topAnchor.constraint(equalTo: videoChanelTitleLabel.bottomAnchor, constant: 10).isActive = true
        buttonStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        // volumeDownImagee
        
        volumeDownImage.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20).isActive = true
        volumeDownImage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        
        // volumeSlider
        
        volumeSlider.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20).isActive = true
        volumeSlider.leftAnchor.constraint(equalTo: volumeDownImage.rightAnchor, constant: 5).isActive = true
        volumeSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // volumeUpImage
        
        volumeUpImage.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20).isActive = true
        volumeUpImage.leftAnchor.constraint(equalTo: volumeSlider.rightAnchor, constant: 5).isActive = true
        volumeUpImage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        
        
        // replayButton
        
        replayButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 10).isActive = true
        replayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50).isActive = true
        
        // shuffleButton
        
        shuffleButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 10).isActive = true
        shuffleButton.leftAnchor.constraint(equalTo: replayButton.rightAnchor, constant: 5).isActive = true
        shuffleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50).isActive = true

        
    }
    
    // a for statment we check and assign volumeSlider as a kind of UISlider note that we orginal have MPVolumeView and we looking for trackTintColor
    
    func customVolumeSliderColor() {
        let temp = volumeSlider.subviews
        for current in temp {
            if current.isKind(of: UISlider.self) {
                let tempSlider = current as! UISlider
                tempSlider.minimumTrackTintColor = .red
                tempSlider.maximumTrackTintColor = .white
            }
        }
    }
    
    func customVolumeSliderButtonColor() {
        let temp = volumeSlider.subviews
        for current in temp {
            if current.isKind(of: UIButton.self) {
                let tempButton = current as! UIButton
                tempButton.setImage(tempButton.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
                tempButton.tintColor = .white
                
            }
        }
    }
    
    // adding everything into the view
        
    func addingSubviewsToView() {
        
        view.addSubview(VideoWebView)
        view.addSubview(SeperatorView)
        view.addSubview(currentTimeLabel)
        view.addSubview(videoSlider)
        view.addSubview(videoLengthLabel)
        view.addSubview(videoTitleLabel)
        view.addSubview(videoChanelTitleLabel)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(downloadButton)
        buttonStackView.addArrangedSubview(backwordButton)
        buttonStackView.addArrangedSubview(playPauseButton)
        buttonStackView.addArrangedSubview(forwardButton)
        buttonStackView.addArrangedSubview(listButton)
        view.addSubview(volumeDownImage)
        view.addSubview(volumeSlider)
        view.addSubview(volumeUpImage)
        view.addSubview(replayButton)
        view.addSubview(shuffleButton)
        
    }
    
    // we play video by using the videoEmbedString and we set the width and height also here, we play the video by using the videoID from YouTube API
    
    func playVideo(videoId: String) {
        
        let videoEmbdedString = "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(String(describing: VidWidth))' height='\(String(describing: VidHeight))' src='http://www.youtube.com/embed/\(videoId)?enablejsapi=1&controls=0&autohide=1&rel=0&playsinline=1&autoplay=1' frameborder='0'&controls=0></body></html>"
        
        VideoWebView.loadHTMLString(videoEmbdedString, baseURL: nil)
    
        videoSlider.value = 0
        
    }
    
    // simply getting video duration and converting it to minutes ans seconds
    func timeComverter(time: String, label: UILabel) {
        
        DispatchQueue.main.async {
            
            let timeInFloat = (time as NSString).floatValue
            
            let secondsString = String(format: "%02d", Int(timeInFloat.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%02d", Int(timeInFloat / 60))
            
            let durationText = "\(minutesString):\(secondsString)"
            
            label.text = durationText
            
        
            
        }
        
    }
    
    // we do some very simple math to know how much time of the video we have left we take videoduartion - current time the video is at to know how much there is we convert it to minutes and seconds
    func VideoRemainingTimeLeft(duration: String, curTime: String, Label: UILabel) {
        
        DispatchQueue.main.async {
            let durationInFloat = (duration as NSString).floatValue
            let currentTimeInFloat = (curTime as NSString).floatValue
            
            let remainingTime = durationInFloat - currentTimeInFloat
            
            let secondsString = String(format: "%02d", Int(remainingTime.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%02d", Int(remainingTime / 60))
            
            let durationText = "\(minutesString):\(secondsString)"
            
            Label.text = durationText
            
            
        }
        
        
    }
    
    // we have divide current time with video duration to know how far the video has reached the end and we set the slider value to that
    func updateVideoSlider(duration: String, currentTime: String, slider: UISlider) {
        
        DispatchQueue.main.async {
            if self.hasSeeked == false {
            let currentTimeInFloat = (currentTime as NSString).floatValue
            let videoDurationTimeInFloat = (duration as NSString).floatValue
            
            slider.value = Float(currentTimeInFloat / videoDurationTimeInFloat)
            
//            print(slider.value)
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //check if we are still loading
        if VideoWebView.isLoading {
            return
        }
        
        print("done loading")
        
        // if it is false then we are not loading anymore and completly loaded the content
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleHasVideoLoaded), userInfo: nil, repeats: true)
    
        
    }
    
    // using timer as to mimick a listner and that way we can now in what state the video is at, and of cousre getting the currenttime
    @objc func handleHasVideoLoaded() {
        guard let videoLoaded = VideoWebView.stringByEvaluatingJavaScript(from: "ytplayer.getPlayerState()")else { return }
        
        if videoLoaded == "2" {
            
            print("video is paused")
            
        }
        
        else if videoLoaded == "1" {
            
            guard let videoDuration = VideoWebView.stringByEvaluatingJavaScript(from: "ytplayer.getDuration()")else { return }
            
            guard let currentTime = VideoWebView.stringByEvaluatingJavaScript(from: "ytplayer.getCurrentTime()") else { return }
            
            timeComverter(time: currentTime, label: currentTimeLabel)
            
            VideoRemainingTimeLeft(duration: videoDuration, curTime: currentTime, Label: videoLengthLabel)
            
            updateVideoSlider(duration: videoDuration, currentTime: currentTime, slider: videoSlider)
            
            
        }
        
        else if videoLoaded == "3" {
            
            print("video is buffering")
            
        }
        
        else if videoLoaded == "0" {
            
            print("video was stopped")
            
//            timer.invalidate()
            
            i += 1
            
            playNextPreviousVideo(nextPrevoiusInt: i)
            
        }
    }
    
    func playNextPreviousVideo(nextPrevoiusInt: Int) {
        guard let firstVideoId = videoID else { return }
        
        for (index, item) in videosID.removeDuplicates().enumerated() {
            
            
            if firstVideoId == item {
                print("Found \(item) at position \(index)")
                
                if videosID.count > index + nextPrevoiusInt && index + nextPrevoiusInt > -1 {
                    var nextVideoId = videosID[index + nextPrevoiusInt]
                    playVideo(videoId: nextVideoId)
                    
                    let nextVideoTitle = videosTitles[index + nextPrevoiusInt]
                    videoTitleLabel.text = nextVideoTitle
                    
                    let nextVideoChannelTitle = videosChannelTitle[index + nextPrevoiusInt]
                    videoChanelTitleLabel.text = nextVideoChannelTitle
                    
                }else {
                    print("couldn't play next Video")
                }
            }
        }
    }
    
}






