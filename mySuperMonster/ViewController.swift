//
//  ViewController.swift
//  mySuperMonster
//
//  Created by LarryNguyen Macbook Pro on 10/20/15.
//  Copyright © 2015 LarryNguyen Macbook Pro. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var skull1Img: UIImageView!
    @IBOutlet weak var skull2Img: UIImageView!
    @IBOutlet weak var skull3Img: UIImageView!
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var foodImg: DragImg!
    
    
    
    var backGroundMusic : AVAudioPlayer!
    var deathMusic : AVAudioPlayer!
    var biteMusic : AVAudioPlayer!
    var heartBeatMusic : AVAudioPlayer!
    var lostSkullMusic: AVAudioPlayer!
    
    
    let DIM_ALPHA: CGFloat =  0.4
    let OPAQUE : CGFloat = 1.0
    let MAX_PENALTIES =  3
    

    
    var Penalties = 0
    var monsterHappyState = false
    var timer : NSTimer!
    var currentItem: UInt32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        skull1Img.alpha = DIM_ALPHA
        skull2Img.alpha = DIM_ALPHA
        skull2Img.alpha = DIM_ALPHA
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter", name: "onTargetDropped", object: nil)
        
        
        do {
            try backGroundMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try deathMusic = AVAudioPlayer (contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try biteMusic = AVAudioPlayer( contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try heartBeatMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try lostSkullMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            backGroundMusic.prepareToPlay()
            backGroundMusic.play()
            deathMusic.prepareToPlay()
            biteMusic.prepareToPlay()
            heartBeatMusic.prepareToPlay()
            lostSkullMusic.prepareToPlay()
        
        } catch let err as NSError {
        print(err.debugDescription)
        
        }
        
        starTimer()
    
    }
    
    func starTimer() {
        if timer != nil {
        timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func itemDroppedOnCharacter(){
        monsterHappyState = true
        starTimer()
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            heartBeatMusic.play()
            
        }else  {
        
            biteMusic.play()
        }
        
    }
    
    
    func changeGameState (){
        if !monsterHappyState {
            Penalties++
            lostSkullMusic.play()
            
            if Penalties == 1 {
                skull1Img.alpha = OPAQUE
                skull2Img.alpha = DIM_ALPHA
            } else if Penalties == 2 {
                skull2Img.alpha =  OPAQUE
                skull3Img.alpha = DIM_ALPHA
            } else if Penalties >= 3 {
                skull3Img.alpha = OPAQUE
            }else {
                skull1Img.alpha = DIM_ALPHA
                skull2Img.alpha = DIM_ALPHA
                skull3Img.alpha = DIM_ALPHA
                
            }
            
            if Penalties > MAX_PENALTIES {
            gameOver()
                
            }
        
        }
        
        let rand = arc4random_uniform(2) // 0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
            
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        
        currentItem = rand
        monsterHappyState   = false
    
    }
    
    func gameOver(){
        timer.invalidate()
        monsterImg.playDeathAnimation()
        deathMusic.play()
    
    }
    

}

