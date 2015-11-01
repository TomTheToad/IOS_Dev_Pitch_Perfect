//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by VICTOR ASSELTA on 10/27/15.
//  Copyright © 2015 TomTheToad. All rights reserved.
//

import UIKit
import AVFoundation

/// PlaySoundsViewController
/// - alters previously recorded sound file
class PlaySoundsViewController: UIViewController {
    
    // Fields
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    // Slow button
    @IBOutlet weak var slowButton: UIButton!
    // Fast button
    @IBOutlet weak var fastButton: UIButton!
    // Stop button
    @IBOutlet weak var stopButton: UIButton!
    // Chicken button
    @IBOutlet weak var chipmunkButton: UIButton!
    // Vader button
    @IBOutlet weak var vaderButton: UIButton!
    // Reverb button
    @IBOutlet weak var reverbButton: UIButton!
    // Echo button
    @IBOutlet weak var echoButton: UIButton!
    
    /// viewDidLoad
    /// - set audio path
    /// - convert audio path to NSURL
    /// - initialize audio path
    /// - enable rate handling
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    /// Unused/ delete?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Reset audio helper function
    /// - stops audio player
    /// - resets auio player current time to 0.0
    /// - stops audio engine
    /// - resets audio engine
    func resetAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    /// Change audio rate helper function
    /// - calls resetAudio function
    /// - sets audio rate to requested
    /// - tells audio player to play
    /// - parameter rate: set rate using float
    func playAudioAtRate(rate:float_t) {
        resetAudio()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    /// Change audio pitch helper function
    /// - sets audio player node
    /// - calls pitch effect
    /// - connects audio player node to pitch effect
    /// - connects pitch effect to speakers
    /// - parameter pitch: set pitch using float
    func playAudioWithVariablePitch(pitch:float_t) {
        resetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    // Change audio reverb helper function
    /// - sets audio player node
    /// - calls pitch effect
    /// - connects audio player node to reverb effect
    /// - connects reverb effect to speakers
    /// - parameter percentage: set reverb using float
    func playAudioWithVariableReverb(percentage:Float) {
        resetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.wetDryMix = percentage
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }

    // slowButton method
    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudioAtRate(0.5)
    }
    
    // fastButton method
    @IBAction func playFastAudio(sender: AnyObject) {
        playAudioAtRate(2.0)
    }
    
    // chipmunk method
    @IBAction func playChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    // vader method
    @IBAction func playVader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    // reverb (Jimmie Hendrix) method
    @IBAction func reverbButton(sender: AnyObject) {
        playAudioWithVariableReverb(30.00)
    }
    
    // echo method
    @IBAction func echoButton(sender: AnyObject) {
        playAudioWithVariableReverb(80.00)
    }
    
    // stopButton method
    @IBAction func stopAudio(sender: AnyObject) {
        resetAudio()
    }
}
