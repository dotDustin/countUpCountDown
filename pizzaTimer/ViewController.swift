//
//  ViewController.swift
//  pizzaTimer
//
//  Created by Dustin M on 2/23/16.
//  Copyright © 2016 Vento. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var countingDown: UISwitch!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var timer = NSTimer()
    let timeInterval: NSTimeInterval = 0.05
    let timerEnd:NSTimeInterval = 10.0 //seconds to end the timer
    var timeCount:NSTimeInterval = 0.0 // counter for the timer
    var isTiming = false
    
    var player: AVAudioPlayer = AVAudioPlayer()

    
    @IBAction func startButtonPressed(sender: AnyObject) {
        
        if !timer.valid{ //prevent more than one timer on the thread
            timerLabel.text = timeString(timeCount) //change to show clock instead of message
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                target: self,
                selector: "timerDidEnd:",
                userInfo: nil,
                repeats: true) //repeating timer in the second iteration
        }
        
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        
        timerLabel.text = "Timer Stopped"
        timer.invalidate()
        
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        
        timer.invalidate()
        resetTimeCount()
        timerLabel.text = timeString(timeCount)
        
    }
    
    @IBAction func countingDown(sender: AnyObject) {
        
        if !isTiming {
            resetTimeCount()
            timerLabel.text = timeString(timeCount)
        }
        
    }
    //MARK: Instance Methods
    
    func timerDidEnd(timer:NSTimer){
        if countingDown.on{
            //timer that counts down
            timeCount = timeCount - timeInterval
            if timeCount <= 0 {  //test for target time reached.
                timerLabel.text = "Pizza Ready!!"
                
                let audioPath = NSBundle.mainBundle().pathForResource("beep", ofType: "mp3")!
                do {
                    try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
                    player.play()
                }catch{
                    print("error occurred")
                }
            
                timer.invalidate()
                
            } else { //update the time on the clock if not reached
                timerLabel.text = timeString(timeCount)
            }
        } else {
            //timer that counts up
            timeCount = timeCount + timeInterval
            if timeCount >= timerEnd{  //test for target time reached.
                timerLabel.text = "Pizza Ready!!"
                
                let audioPath = NSBundle.mainBundle().pathForResource("beep", ofType: "mp3")!
                do {
                    try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
                    player.play()
                }catch{
                    print("error occurred")
                }
                
                timer.invalidate()
                
            } else { //update the time on the clock if not reached
                timerLabel.text = timeString(timeCount)
            }
        }
    }
    
    func timeString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%01i",minutes,Int(seconds),Int(secondsFraction * 10.0))
    }
    
    func resetTimeCount(){
        if countingDown.on{
            timeCount = timerEnd
        } else {
            timeCount = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            descriptionLabel.text = "Timer will count up or down based on the slider position. After 10 seconds, the timer will alert that it has reached the end."
            descriptionLabel.layer.borderColor = UIColor.orangeColor().CGColor
            descriptionLabel.layer.borderWidth = 3.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

