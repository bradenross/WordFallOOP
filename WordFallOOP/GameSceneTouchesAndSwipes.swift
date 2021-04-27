//
//  GameSceneTouchesAndSwipes.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/15/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox
import GoogleMobileAds

extension GameScene{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        if (test(word: word.lowercased()) == true){
            if (word.lowercased() == "braden") {
                warning.text = "AMAZING word!"
                warning.fontColor = UIColor.green
                warning.showWarning()
                score += 100
            } else {
                warning.text = "Good word!"
                warning.fontColor = UIColor.green
                warning.showWarning()
            }
            
            for letters in selected {
                let x = letters.position.x
                let y = letters.position.y
                
                let letter = Letter()
                letter.size = CGSize(width: 90, height: 90)
                letter.position = CGPoint(x: x, y: y)
                self.run(SKAction.sequence([ SKAction.run{letters.removeLetter()}, SKAction.run{self.addChild(letter)}]))
            }
            wordLabel.text = ""
            selected.removeAll()
            if(word.count >= LetterOddsAndScores().lettersNeeded()){
                removeWord()
            } else {
                if(lives > 1){
                    removeWord()
                    warning.numberOfLines = 2
                    warning.text = "Not enough letters: \(LetterOddsAndScores().lettersNeeded()) needed \n Life lost"
                    warning.fontColor = UIColor.red
                    warning.showWarning()
                    //warning.numberOfLines = 1
                    lives -= 1
                    removeHeart()
                } else {
                    warning.numberOfLines = 2
                    warning.text = "Not enough letters: \(LetterOddsAndScores().lettersNeeded()) needed \n Life lost"
                    warning.fontColor = UIColor.red
                    warning.showWarning()
                    //warning.numberOfLines = 1
                    let gameEnded:SKAction = SKAction.run {
                        self.removeWord()
                        self.removeHeart()
                    }
                    let changeScene:SKAction = SKAction.run {
                        self.removeAllChildren()
                        self.gameOver = true
                        self.isPaused = true
                        self.gamePaused = true
                        self.pauseButton.isEnabled = false
                        self.powerupButton.isEnabled = false
                        self.showPauseEndMenu()
                        self.view!.window!.rootViewController!.present(AdMobViewController(), animated: true, completion: nil)
                    }
                    self.run(SKAction.sequence([gameEnded, SKAction.wait(forDuration: 0.5),changeScene]))
                }
            }
        } else {
            if(word.count == 0){
                warning.text = "No letters selected"
                warning.fontColor = UIColor.red
                warning.showWarning()
            } else {
                warning.text = "No matching word"
                warning.fontColor = UIColor.red
                warning.showWarning()
            }
        }
        word = ""
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        if(selected.count > 0){
            selected.last?.active()
            selected.removeLast()
            if(joints.count > 0){
                self.physicsWorld.remove(joints.last!)
                joints.removeLast()
            }
            word = ""
            for letters in selected {
                word.append(letters.letter)
            }
            wordLabel.text = word
        }
    }
    
    func showPauseEndMenu(){
        if(self.isPaused == false && gamePaused == false && self.gameOver == false){
            let endPauseMenu = EndGame(parentScene: self, isGameOver: false)
            self.addChild(endPauseMenu)
            self.isPaused = true
            gamePaused = true
            powerupButton.isEnabled = false
        } else if(self.gameOver == true){
            let endPauseMenu = EndGame(parentScene: self, isGameOver: true)
            endPauseMenu.addReward()
            self.addChild(endPauseMenu)
            self.isPaused = true
            gamePaused = true
            powerupButton.isEnabled = false
            let bannerView = self.view?.viewWithTag(100) as! GADBannerView?
            bannerView?.isHidden = false
        } else {
            let menu = self.childNode(withName: "pauseEndMenu") as? EndGame
            menu!.removeEndGame()
            menu!.removeFromParent()
            self.isPaused = false
            gamePaused = false
            powerupButton.isEnabled = true
        }
    }
    
    func segue(toScene: SKScene){
        let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
        let scene = toScene
        scene.scaleMode = .aspectFill
        self.removeAllChildren()
        //Error here with nil view
        self.view?.presentScene(scene, transition: transition)
    }
}
