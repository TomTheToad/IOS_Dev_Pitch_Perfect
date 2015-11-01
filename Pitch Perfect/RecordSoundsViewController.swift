//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by VICTOR ASSELTA on 10/21/15.
//  Copyright © 2015 TomTheToad. All rights reserved.
//

import UIKit
import AVFoundation

/// RecordSound View Controller
/// ### Allows for:
/// - recording from the microphone
/// - pausing the recording
/// - resume the recording
/// - stop recording and seque
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Fields
    // Global audio recorder
    var audioRecorder: AVAudioRecorder!
    // Gobal recorded audio
    var recordedAudio: RecordedAudio!
    
    // recording label
    @IBOutlet weak var recordingLabel: UILabel!
    // stop button
    @IBOutlet weak var stopButton: UILabel!
    // pause button
    @IBOutlet weak var pauseButton: UIButton!
    // record button
    @IBOutlet weak var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Preconfigure interface
    override func viewWillAppear(animated: Bool) {
        hideStopButton()
        hidePauseButton()
        enableRecordButton()
        setRecordingLabelTextToIntro()
    }

    // Unused, delete?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Begin Helper Functions:
    // Purposely coded flat for readability
    // Change recording label text
    func setRecordingLabelTextToIntro() {
        recordingLabel.text = "Tap to Record"
    }
    
    // Change recording label text to recording
    func setRecordingLabelTextToRecording() {
        recordingLabel.text = "Recording in Progress"
    }
    
    // Change recording label text to paused
    func setRecordingLabelTextPaused() {
        recordingLabel.text = "Paused"
    }
    
    // Show stop button
    func showStopButton() {
        stopButton.hidden = false
    }
    
    // Hide stop button
    func hideStopButton() {
        stopButton.hidden = true
    }
    
    // Show pause button
    func showPauseButton() {
        pauseButton.hidden = false
    }
    
    // Hide pause button
    func hidePauseButton() {
        pauseButton.hidden = true
    }
    
    // Disable record button
    func disableRecordButton() {
        recordButton.enabled = false
    }
    
    // Enable record button
    func enableRecordButton() {
        recordButton.enabled = true
    }
    // Finish Helper Functions
    
    // Microphone button actions
    /// recordAudio
    /// - parameter: sender: UIButton
    @IBAction func recordAudio(sender: UIButton) {
        setRecordingLabelTextToRecording()
        showStopButton()
        showPauseButton()
        disableRecordButton()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch {
            print("Unable to set output to speaker")
        }
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // Once Recording finishes
    /// audioRecorderDidFinishRecording
    /// - actions after recording has finished
    /// - Parameters:
    ///     - recorder: AVAudioRecorder
    ///     - successfully flag: Bool
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            // Save the recorded audio
            let filePathUrl = recorder.url
            let title = recorder.url.lastPathComponent
            recordedAudio = RecordedAudio(setFilePath: filePathUrl, setTitle: title!)
            
            // Perform a seque
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording failed")
            hideStopButton()
            hidePauseButton()
            enableRecordButton()
        }
    }
    // Prepare for segue
    /// prepareForSeque
    /// - Parameters:
    ///     - seque: UIStoryboardSegue
    ///     - sender: AnyObject optional
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    // Pause audio recording
    /// pauseRecordingAudio
    /// - parameter sender: AnyObject
    @IBAction func pauseRecordingAudio(sender: AnyObject) {
        if (audioRecorder.recording == true) {
            audioRecorder.pause()
            pauseButton.selected = true
            setRecordingLabelTextPaused()
        } else {
            audioRecorder.record()
            pauseButton.selected = false
            setRecordingLabelTextToRecording()
        }
    }

    
    // Stop button actions
    /// stopRecordingAudio
    /// - parameter sender: UIButton (stopButton)
    @IBAction func stopRecordingAudio(sender: UIButton) {
        setRecordingLabelTextToIntro()
        hideStopButton()
        hidePauseButton()
        enableRecordButton()
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}

