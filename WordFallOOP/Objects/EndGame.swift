//
//  EndGame.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/30/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds

class EndGame: SKShapeNode {
    let scoreLabel:SKLabelNode
    let clearLayer:SKSpriteNode
    let coinLabel:SKLabelNode
    let playAgainButton:Button
    let homeButton:Button
    let endReward:Button
    var isGameOver:Bool
    unowned let parentScene:SKScene
    
    init(parentScene: SKScene, isGameOver: Bool) {
        self.isGameOver = isGameOver
        scoreLabel = SKLabelNode(fontNamed: "Avenir-Book")
        coinLabel = SKLabelNode(fontNamed: "Avenir-Book")
        clearLayer = SKSpriteNode()
        playAgainButton = Button(action: {})
        homeButton = Button(action: {})
        endReward = Button(action: {})
        self.parentScene = parentScene
        super.init()
        self.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: parentScene.frame.width * (4/5), height: parentScene.frame.height * (2/3)), cornerRadius: parentScene.frame.width / 15).cgPath
        self.position = CGPoint(x: parentScene.frame.midX - (self.frame.width / 2), y: parentScene.frame.midY - (self.frame.height / 2))
        self.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.alpha = 0.85
        self.strokeColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.zPosition = 1000
        self.name = "pauseEndMenu"
        
        clearLayer.size = CGSize(width: parentScene.size.width * 2, height: parentScene.size.height * 2)
        clearLayer.position = CGPoint(x: parentScene.frame.midX, y: parentScene.frame.midY)
        clearLayer.zPosition = self.zPosition - 1
        clearLayer.alpha = 0.01
        clearLayer.color = UIColor.black
        parentScene.addChild(clearLayer)
        
        addElements()
        
        coins = score / 20
    }
    
    deinit {
        print("EndGame Deinittttt")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements(){
        homeButton.action = {self.segueHome()}
        playAgainButton.action = {self.newGame()}
        
        scoreLabel.fontColor = UIColor.black
        scoreLabel.text = "Score: \(score)"
        scoreLabel.zPosition = self.zPosition + 1
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - (scoreLabel.frame.height * 3))
        parentScene.addChild(scoreLabel)
        
        homeButton.texture = SKTexture(imageNamed: "Home")
        homeButton.size = CGSize(width: 500, height: 85)
        homeButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 110)
        homeButton.zPosition = self.zPosition + 2
        parentScene.addChild(homeButton)
        homeButton.createShadow(imageNamed: "HomeShadow")
        
        if(isGameOver == false){
            endReward.isHidden = true
            endReward.buttonShadow.isHidden = true
            playAgainButton.texture = SKTexture(imageNamed: "Restart")
        } else {
            endReward.isHidden = false
            endReward.buttonShadow.isHidden = false
            playAgainButton.texture = SKTexture(imageNamed: "PlayAgain")
            coinLabel.fontColor = UIColor.black
            coinLabel.text = "Coins: \(Int(score / 20))"
            coinLabel.zPosition = self.zPosition + 1
            coinLabel.fontSize = 50
            coinLabel.position = CGPoint(x: self.frame.midX, y: scoreLabel.position.y - (coinLabel.frame.height * 3))
            parentScene.addChild(coinLabel)
        }
        playAgainButton.size = CGSize(width: 500, height: 85)
        playAgainButton.position = CGPoint(x: self.frame.midX, y: homeButton.position.y + 110)
        playAgainButton.zPosition = self.zPosition + 2
        parentScene.addChild(playAgainButton)
        playAgainButton.createShadow(imageNamed: "PlayAgainShadow")
    }
    
    func addReward(){
        endReward.texture = SKTexture(imageNamed: "Reward")
        endReward.size = CGSize(width: self.frame.width / 2, height: self.frame.width / 4)
        endReward.position = CGPoint(x: self.frame.midX , y: playAgainButton.position.y + 150)
        endReward.zPosition = self.zPosition + 2
        endReward.action = {self.showAd()}
        parentScene.addChild(endReward)
        endReward.createShadow(imageNamed: "RewardShadow")
        NotificationCenter.default.addObserver(self, selector: #selector(rewardCoinsText), name: NSNotification.Name(rawValue: "doubleCoins"), object: nil)
    }
    
    @objc func rewardCoinsText(){
        coinLabel.text = "Coins: \(Int(score / 20))"
    }
    
     func segueHome(){
        let bannerView = self.scene?.view?.viewWithTag(100) as! GADBannerView?
        bannerView?.isHidden = false
        if let gestures = (self.parent as? SKScene)?.view!.gestureRecognizers {
            for gesture in gestures {
               if let recognizer = gesture as? UISwipeGestureRecognizer {
                    (self.parent as? SKScene)?.view!.removeGestureRecognizer(recognizer)
               }
            }
        }
        print(score)
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") + coins, forKey: "coins")
        score = 0
        coins = 0
        self.scene?.view?.presentScene(MainMenu(size: self.parentScene.frame.size), transition: SKTransition.push(with: SKTransitionDirection.down, duration: 1))
        self.scene?.removeAllChildren()
        self.scene?.removeAllActions()
        self.removeFromParent()
     }
    
    func newGame(){
        let bannerView = self.scene?.view?.viewWithTag(100) as! GADBannerView?
        bannerView?.isHidden = true
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") + coins, forKey: "coins")
        score = 0
        coins = 0
        self.scene?.view?.presentScene(GameScene(size: self.parentScene.frame.size), transition: SKTransition.crossFade(withDuration: 1))
        self.scene?.removeAllChildren()
        self.scene?.removeAllActions()
        self.removeFromParent()
    }
    
    func removeEndGame(){
        clearLayer.removeFromParent()
        scoreLabel.removeFromParent()
        homeButton.removeFromParent()
        homeButton.buttonShadow.removeFromParent()
        endReward.removeFromParent()
        endReward.buttonShadow.removeFromParent()
        playAgainButton.removeFromParent()
        playAgainButton.buttonShadow.removeFromParent()
    }
    
    func showAd(){
        endReward.isEnabled = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showVideoRewardAd"), object: nil)
    }
    
    
}
