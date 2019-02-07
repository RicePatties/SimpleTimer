//
//  ViewController.swift
//  Simple Workout Timer
//
//  Created by Jimu Ryoo on 1/30/19.
//  Copyright © 2019 RicePatties. All rights reserved.


import UIKit
import SnapKit
import AVFoundation
import AudioToolbox.AudioServices

class ViewController: UIViewController, AVAudioPlayerDelegate {
    var audioPlayer = AVAudioPlayer()
    var soundFiles : Array<String> = Array(["note1", "note2", "note3", "note4"])

    
    //starting values for each of the three button
    var secondsButton1 = 45  //change to 30 when done with debug
    var secondsButton2 = 60
    var secondsButton3 = 75
    var seconds = 10 // dis val don't really matter
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var resumeTapped = false
    var currBrightness : CGFloat = 0
    
    
   
    
    
    
    
    
    ///////should change brightness regardless of current light setting
    ////// should change brightness setting when closed and reopened, unlocked
    ///app should still run in background
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //create View for buttons, in order to set constraints
        let topRightView = UIView()
        topRightView.backgroundColor  = UIColor.init(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.5)
 
        let topLeftView = UIView()
        topLeftView.backgroundColor  = UIColor.init(red: 115/255, green: 115/255, blue: 115/255, alpha: 0.5)
        let bottomRightView = UIView()
        bottomRightView.backgroundColor  = UIColor.init(red: 110/255, green: 110/255, blue: 110/255, alpha: 0.5)
        let bottomLeftView = UIView()
        bottomLeftView.backgroundColor  = UIColor.init(red: 120/225, green: 120/225, blue: 120/225, alpha: 0.5)
        self.view.addSubview(topRightView)
        self.view.addSubview(topLeftView)
        self.view.addSubview(bottomRightView)
        self.view.addSubview(bottomLeftView)
        
        
        //creates each of button lable
        let tRLable = UILabel()
        tRLable.text = "45"
        tRLable.textColor = UIColor.white
        topRightView.addSubview(tRLable)
        tRLable.snp.makeConstraints { (make) -> Void in
            tRLable.center.equalTo(topRightView.center)
        }
        
        let tLLable = UILabel()
        tLLable.text = "60"
        tLLable.textColor = UIColor.white
        topLeftView.addSubview(tLLable)
        tLLable.snp.makeConstraints { (make) -> Void in
            tLLable.center.equalTo(topLeftView.center)
        }
        
        let bRLable = UILabel()
        bRLable.text = "75"
        bRLable.textColor = UIColor.white
        bottomRightView.addSubview(bRLable)
        bRLable.snp.makeConstraints { (make) -> Void in
            bRLable.center.equalTo(bottomRightView.center)
        }
        
        let bLLable = UILabel()
        bLLable.text = "Cancel"
        bLLable.textColor = UIColor.white
        bottomLeftView.addSubview(bLLable)
        bLLable.snp.makeConstraints { (make) -> Void in
           bLLable.center.equalTo(bottomLeftView.center)
        }
        
    
        
        //set constraints for each view
        topRightView.snp.makeConstraints { (make) in
            //cuz it's 50% of screen
            let multiple  = 1.0/2.0
            make.width.equalTo(self.view).multipliedBy(multiple)
            make.height.equalTo(self.view).multipliedBy(multiple)
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            
        }
        
        topLeftView.snp.makeConstraints { (make) in
            let multiple  = 1.0/2.0
            make.width.equalTo(self.view).multipliedBy(multiple)
            make.height.equalTo(self.view).multipliedBy(multiple)
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            
        }
        
        bottomRightView.snp.makeConstraints { (make) in
            let multiple  = 1.0/2.0
            make.width.equalTo(self.view).multipliedBy(multiple)
            make.height.equalTo(self.view).multipliedBy(multiple)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            
        }
        
        bottomLeftView.snp.makeConstraints { (make) in
            let multiple  = 1.0/2.0
            make.width.equalTo(self.view).multipliedBy(multiple)
            make.height.equalTo(self.view).multipliedBy(multiple)
            make.bottom.equalTo(self.view)
            make.right.equalTo(self.view)
            
        }
        
        //creates buttons
        let tRBtn = UIButton()
        topRightView.addSubview(tRBtn)
        tRBtn.tag = 1
        tRBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        let tLBtn = UIButton()
        topLeftView.addSubview(tLBtn)
        tLBtn.tag = 2
        tLBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        let bRBtn = UIButton()
        bottomRightView.addSubview(bRBtn)
        bRBtn.tag = 3
        bRBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        let bLBtn = UIButton()
        bottomLeftView.addSubview(bLBtn)
        bLBtn.tag = 4
        bLBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        //creates constraints for buttons
        tRBtn.snp.makeConstraints { (make) -> Void in
            let multiple  = 1.0/2.0
            make.width.equalTo(self.view).multipliedBy(multiple)
            make.height.equalTo(self.view).multipliedBy(multiple)
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
        }
        
        tLBtn.snp.makeConstraints { (make) -> Void in
            let multiple  = 1.0/2.0
            make.width.equalTo(self.view).multipliedBy(multiple)
            make.height.equalTo(self.view).multipliedBy(multiple)
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        bRBtn.snp.makeConstraints { (make) in
            let multiple  = 1.0/2.0
            make.width.equalTo(self.view).multipliedBy(multiple)
            make.height.equalTo(self.view).multipliedBy(multiple)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            
        }
        
        bLBtn.snp.makeConstraints { (make) in
            let multiple  = 1.0/2.0
            make.width.equalTo(self.view).multipliedBy(multiple)
            make.height.equalTo(self.view).multipliedBy(multiple)
            make.bottom.equalTo(self.view)
            make.right.equalTo(self.view)
            
        }
        
        
       
      
    }
    
   
    
    @objc func buttonAction(sender: UIButton!) {
        let selectedFileName : String = soundFiles[sender.tag - 1]
        playSound(selectedFileName)
        
        //this invalidate makes sure
        //seconds don't go negative
        //if it does, it doesn't affect functionality, but will do unecessary computation
        timer.invalidate()
        
        //switch selects which timer to run
        //if user touches button b4 timer is done
        //timer restart immediately with appropiriate button
        switch sender.tag {
        case 1:
            seconds = secondsButton1
            runTimer()
        case 2:
            seconds = secondsButton2
            runTimer()
        case 3:
            seconds = secondsButton3
            runTimer()
        default:
            timer.invalidate() //when user presses 4th button, timer stops
        }
    }
  
    
    //needed for runTimer function
    //decrments timer and stops when done
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        print(seconds)
        if seconds == 0 {
            timer.invalidate()
            playSound(soundFiles[3])
        }
    }
    
    //Function to initialize timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    //Helper function.
    //Plays appropirate sound, once
    func playSound(_ soundFileName : String) {
        
        //sets url for soundfile
        let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav")
        
        do {
            //allows sound to play with the music
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: AVAudioSession.CategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //preparing to play sound
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            
        } catch {
            print(error)
        }
        audioPlayer.play()
        
    }
    
}






