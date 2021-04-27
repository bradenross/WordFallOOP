//
//  TutorialSteps.swift
//  WordFallOOP
//
//  Created by Braden Ross on 4/25/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds

extension TutorialScene{
    
    func moveHandTaps(){
        stepsLabel.isHidden = false
        stepsLabel.text = "Tap letters to \nselect them into a word"
        
        hand.removeAllActions()
        hand.position = handStartPoint
        let pause:SKAction = SKAction.wait(forDuration: 0.2)
        let moveRight:SKAction = SKAction.move(by: CGVector(dx: 90, dy: 0), duration: 0.4)
        let movePause:SKAction = SKAction.sequence([moveRight, SKAction.wait(forDuration: 0.2)])
        let repeatMove:SKAction = SKAction.repeat(movePause, count: 3)
        
        hand.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {self.hand.isHidden = false}, pause, repeatMove, SKAction.run {self.hand.isHidden = true; self.hand.position = CGPoint(x: self.hand.position.x - 270, y: self.hand.position.y); SKAction.wait(forDuration: 0.2)}])))
    }
    
    func swipeLeftHand(){
        stepsLabel.text = "Or swipe left to \nremove a single letter"
        hand.removeAllActions()
        hand.position = CGPoint(x: self.frame.width - 100, y: self.frame.midY)
        let show:SKAction = SKAction.run {
            self.hand.isHidden = false
        }
        let fadeIn:SKAction = SKAction.fadeAlpha(to: 1, duration: 0.5)
        let slideRight:SKAction = SKAction.move(to: CGPoint(x: 100, y: self.frame.midY), duration: 1)
        let fadeOut:SKAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let hide:SKAction = SKAction.run {
            self.hand.isHidden = true
            self.hand.position = CGPoint(x: self.frame.width - 100, y: self.frame.midY)
        }
        
        
        hand.isHidden = false
        hand.run(SKAction.repeatForever(SKAction.sequence([show, fadeIn, slideRight, fadeOut, hide])))
    }
    
    func swipeRightHand(){
        stepsLabel.text = "Swipe right to input \nword to get points"
        hand.removeAllActions()
        hand.position = CGPoint(x: 100, y: self.frame.midY)
        let show:SKAction = SKAction.run {
            self.hand.isHidden = false
        }
        let fadeIn:SKAction = SKAction.fadeAlpha(to: 1, duration: 0.5)
        let slideRight:SKAction = SKAction.move(to: CGPoint(x: self.frame.width - 100, y: self.frame.midY), duration: 1)
        let fadeOut:SKAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let hide:SKAction = SKAction.run {
            self.hand.isHidden = true
            self.hand.position = CGPoint(x: 100, y: self.frame.midY)
        }
        
        
        hand.isHidden = false
        hand.run(SKAction.repeatForever(SKAction.sequence([show, fadeIn, slideRight, fadeOut, hide])))
    }
    
    func tapLetter(){
        stepsLabel.text = "Tap letters to deselect \nthem from the word"
        hand.removeAllActions()
        hand.position = CGPoint(x: handStartPoint.x + 90, y: handStartPoint.y)
        let show:SKAction = SKAction.run {
            self.hand.isHidden = false
        }
        let fadeIn:SKAction = SKAction.fadeAlpha(to: 1, duration: 0.5)
        let fadeOut:SKAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
        
        hand.isHidden = false
        hand.run(SKAction.repeatForever(SKAction.sequence([show, fadeIn, fadeOut])))
    }
    
    func tiltPhone(){
        stepsLabel.text = "Tilt your device to move \nthe letters around"
        hand.removeAllActions()
        hand.removeFromParent()
        phone.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 300)
        phone.size = CGSize(width: 100, height: 150)
        phone.isHidden = false
        
        let tiltRight:SKAction = SKAction.rotate(byAngle: .pi / 4, duration: 0.5)
        let tiltLeft:SKAction = SKAction.rotate(byAngle: .pi / -2, duration: 1)
        let tilt:SKAction = SKAction.repeat(SKAction.sequence([tiltRight, tiltLeft]), count: 4)
        let enableGrav:SKAction = SKAction.run({
            for child in self.children {
                if(child.name == "letter") {
                    (child as? TutLetter)?.physicsBody?.isDynamic = true
                    (child as? TutLetter)?.isUserInteractionEnabled = true
                }
            }
            self.motionManager?.startAccelerometerUpdates()
        })
        
        let finalStep:SKAction = SKAction.run({ self.goodLuck() })
        
        phone.run(SKAction.sequence([enableGrav, tilt, finalStep]))
    }
    
    func goodLuck(){
        phone.removeAllActions()
        phone.removeFromParent()
        let powerups:SKAction = SKAction.run({
            self.stepsLabel.text = "Don't forget to try \nthe powerups in the \nbottom right corner!"
        })
        let goodLuck:SKAction = SKAction.run({
            self.stepsLabel.text = "Good Luck!"
        })
        let hideAndEnableGrav:SKAction = SKAction.run({
            let bannerView = self.scene?.view?.viewWithTag(100) as! GADBannerView?
            bannerView?.isHidden = true
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") + coins, forKey: "coins")
            score = 0
            coins = 0
            UserDefaults.standard.setValue(false, forKey: "tutorialActive")
            self.scene?.view?.presentScene(GameScene(size: self.frame.size), transition: SKTransition.crossFade(withDuration: 1))
            self.scene?.removeAllChildren()
            self.scene?.removeAllActions()
            self.removeFromParent()
            
        })
        stepsLabel.run(SKAction.sequence([powerups, SKAction.wait(forDuration: 4), goodLuck, SKAction.wait(forDuration: 4), hideAndEnableGrav]))
    }
    
}
