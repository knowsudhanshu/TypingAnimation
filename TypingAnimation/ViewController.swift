//
//  ViewController.swift
//  TypingAnimation
//
//  Created by Sudhanshu Sudhanshu on 27/06/18.
//  Copyright © 2018 Sudhanshu Sudhanshu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let countingLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    var messageSemiText = ""
    let messageText = "Your application initializes a new display link, providing a target object and a selector to be called when the screen is updated. To synchronize your display loop with the display, your application adds it to a run loop using the add(to:forMode:) method."
    
    var characterIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(countingLabel)
        countingLabel.frame = view.frame
        beginTyping()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGR)
    }
    
    @objc func tapGestureHandler(_ tapGR: UITapGestureRecognizer) {
        beginTyping()
    }
    
    func beginTyping () {
        characterIndex = 0
        messageSemiText = ""
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink))
        displayLink.preferredFramesPerSecond = 10 // This value will decide the speed of typing on screen
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        if player == nil || player?.isPlaying == false{
            playSound()
        }
        
        if messageSemiText.count < messageText.count {
            characterIndex += 1
            messageSemiText.append( messageText[messageSemiText.endIndex] )
            countingLabel.text = "\(messageSemiText)"
        }else {
            if player?.isPlaying == true {
                player?.stop()
            }
            messageSemiText = messageText
            countingLabel.text = "\(messageSemiText)"
            displayLink.invalidate() // Must invalidate displayLink else runLoop wouldn't stop.
        }
    }
    
    var player : AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "typeSound", withExtension: "mp3") else { return }
        do {
            player = (player != nil) ? player : try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            
        }catch let error as NSError {
            print(error.description)
        }
    }
    
}

