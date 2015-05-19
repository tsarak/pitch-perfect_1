//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Athanasios Sarakatsianou on 5/8/15.
//  Copyright (c) 2015 tsarakatsianou. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var pausedRecording: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.hidden = true
        recordingInProgress.text = "Tap to Record"
        pausedRecording = false
        pauseButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.text = "recording in progress"
        stopRecordingButton.hidden = false
        pauseButton.hidden = false
        recordButton.enabled = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }

    @IBAction func stopRecording(sender: UIButton) {
        stopRecordingButton.hidden = true
        recordButton.enabled = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil) //added because the category set in recordAudio function routes audio to phone speaker, not to audio speaker
        
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            
             recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            println("the recording was not successful")
        }
            stopRecordingButton.hidden = true
            recordButton.enabled = true
            //recordingInProgress.hidden = true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController! = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
            
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        if (pausedRecording == false) {
            audioRecorder.meteringEnabled = true
            audioRecorder.pause()
            recordingInProgress.text="recording Paused"
            pausedRecording = true
        }else{
            audioRecorder.meteringEnabled = true
            audioRecorder.record()
            recordingInProgress.text="recording in progress"
            pausedRecording=false
        }
    }


}