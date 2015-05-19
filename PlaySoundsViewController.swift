//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Athanasios Sarakatsianou on 5/9/15.
//  Copyright (c) 2015 tsarakatsianou. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate{
    var audioPlayer : AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    var reverbPlayers:[AVAudioPlayer] = []
    var receivedAudio : RecordedAudio!
    
    var session = AVAudioSession()
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    let N:Int = 10
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2.enableRate = true
        audioPlayer.delegate = self
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        
        for i in 0...N {
            var temp = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl,
                error: nil)
            reverbPlayers.append(temp)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioPlayer(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioPlayer(1.5)
    }
    
    func playAudioPlayer (rate:Float){
        stopAudio(stopButton)
        audioPlayer.prepareToPlay()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate

        audioPlayer.play()

    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthAudio(sender: UIButton) {
        playAudioWithVariablePitch(-800)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAudio(stopButton)
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.prepareToPlay()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil )
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer2.stop()
        for i in 0...N {
            reverbPlayers[i].stop()
        }
        audioEngine.stop()
        audioEngine.reset()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.stopAudio(UIButton())
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        audioPlayer.rate = 1.0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playEcho(sender: UIButton) {
        self.stopAudio(UIButton())
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.prepareToPlay()
        audioPlayer2.prepareToPlay()
        audioPlayer.currentTime = 0;
        audioPlayer.play()
        
        
        
        audioPlayer.rate = 1.0
        let delay:NSTimeInterval = 0.1
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        
        audioPlayer2.volume = audioPlayer.volume
        audioPlayer2.playAtTime(playtime)
        
    }
    
    @IBAction func playReverb(sender: UIButton) {
        self.stopAudio(UIButton())
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.prepareToPlay()
        
        let delay:NSTimeInterval = 0.09
        for i in 0...N {
            var curDelay:NSTimeInterval = delay*NSTimeInterval(i)
            var player:AVAudioPlayer = reverbPlayers[i]
            
            var exponent:Double = -Double(i)/Double(N/2)
            var volume = Float(pow(Double(M_E), exponent))
            player.prepareToPlay()
            player.volume = volume
            player.currentTime = 0.0
            player.playAtTime(player.deviceCurrentTime + curDelay)
        }
    }

    
}
