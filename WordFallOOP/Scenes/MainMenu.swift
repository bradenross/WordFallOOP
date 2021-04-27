//
//  MainMenu.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/16/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion
import GoogleMobileAds

class MainMenu: SKScene{
    // Motion Manager
    var motionManager:CMMotionManager? = CMMotionManager()
    // Arrays for creating title
    let wordTitle = ["D", "R", "O", "W"]
    let fallTitle = ["F", "A", "L", "L"]
    // Labels
    let highScoreLabel = SKLabelNode(fontNamed: "Avenir-Book")
    let coinsLabel = SKLabelNode(fontNamed: "Avenir-Book")
    // Alert
    var alert = UIAlertController()
    
    override func didMove(to view: SKView) {
        // Scene setup
        self.backgroundColor = #colorLiteral(red: 0.1490196139, green: 0.1490196139, blue: 0.1490196139, alpha: 1)
        deviceSize(scene: self)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.scaleMode = .aspectFit
        self.name = ""
        isUserInteractionEnabled = true
        // Creates menu
        createMenuButtons()
        createMenuLabels()
        createTitle()
        // Phone motion manager
        motionManager = CMMotionManager()
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.motionManager?.startAccelerometerUpdates()
        }
        
    }
    
    deinit {
        print("MAIN DEINIT")
    }
    
    func createMenuButtons(){
        let infoButton = Button(action: {self.alert(title: "Game Information", message: "Game coded, created, and designed by Braden Ross \nTwitter: @WordFallGame \nInstagram: @WordFallGame", buttonTitle: "Close")})
        let settingsButton = Button(action: { self.segue(toScene: SettingsScene(size: self.frame.size)) })
        let shopButton = Button(action: { self.segue(toScene: Shop(size: self.frame.size)) })
        let playButton = Button(action: { self.playGame() })
        // Play button creation
        playButton.texture = SKTexture(imageNamed: "PlayButton")
        playButton.size = CGSize(width: 500, height: 94)
        playButton.position = CGPoint(x: self.frame.midX, y: 200)
        playButton.zPosition = 11
        playButton.createPhysicsBody()
        self.addChild(playButton)
        playButton.createShadow(imageNamed: "PlayButtonShadow")
        // Info button creation
        infoButton.texture = SKTexture(imageNamed: "InfoButton")
        infoButton.size = CGSize(width: 244, height: 94)
        infoButton.position = CGPoint(x: self.frame.midX - 130, y: playButton.position.y + 120)
        infoButton.zPosition = 11
        infoButton.createPhysicsBody()
        self.addChild(infoButton)
        infoButton.createShadow(imageNamed: "SmallButtonsShadow")
        // Settings button creation
        settingsButton.texture = SKTexture(imageNamed: "SettingsButton")
        settingsButton.size = CGSize(width: 244, height: 94)
        settingsButton.position = CGPoint(x: self.frame.midX + 130, y: playButton.position.y + 120)
        settingsButton.zPosition = 11
        settingsButton.createPhysicsBody()
        self.addChild(settingsButton)
        settingsButton.createShadow(imageNamed: "SmallButtonsShadow")
        // Shop button creation
        shopButton.texture = SKTexture(imageNamed: "ShopButton")
        shopButton.size = CGSize(width: 500, height: 94)
        shopButton.position = CGPoint(x: self.frame.midX, y: settingsButton.position.y + 120)
        shopButton.zPosition = 11
        shopButton.createPhysicsBody()
        self.addChild(shopButton)
        shopButton.createShadow(imageNamed: "ShopShadow")
    }
    
    func createTitle(){
        // Creates "Word" for title
        var i = 0
        for letters in wordTitle{
            let letter = Letter()
            letter.isUserInteractionEnabled = false
            letter.letter = letters
            letter.letterNode.text = letters
            letter.getTexture()
            print(textureName)
            if(letters == "W"){
                letter.letterNode.fontName = "LucidaHandwriting-Italic"
            } else {
                letter.letterNode.fontName = "HelveticaNeue-Light"
            }
            letter.position = CGPoint(x: self.frame.midX - CGFloat(i * 90), y: self.frame.maxY - 200)
            i += 1
            self.addChild(letter)
            letter.physicsBody?.allowsRotation = true
        }
        // Creates "Fall" for title
        i = 0
        for letters in fallTitle{
            let letter = Letter()
            letter.isUserInteractionEnabled = false
            letter.letter = letters
            letter.getTexture()
            letter.letterNode.text = letters
            letter.letterNode.fontName = "HelveticaNeue-Light"
            letter.position = CGPoint(x: self.frame.midX + CGFloat(i * 90), y: self.frame.maxY - 300)
            i += 1
            self.addChild(letter)
            letter.physicsBody?.allowsRotation = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager?.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 50, dy: accelerometerData.acceleration.y * 50)
        }
    }
    
    func createMenuLabels(){
        
        highScoreLabel.text = "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))"
        
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + highScoreLabel.frame.size.height * 2)
        highScoreLabel.fontSize = 50
        highScoreLabel.fontColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        highScoreLabel.name = "highScoreLabel"
        highScoreLabel.zPosition = 10
        
        coinsLabel.text = "Coins: \(UserDefaults.standard.integer(forKey: "coins"))"
        
        coinsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        coinsLabel.fontSize = 50
        coinsLabel.fontColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        coinsLabel.name = "coinsLabel"
        coinsLabel.zPosition = 10
        
        self.addChild(highScoreLabel)
        self.addChild(coinsLabel)
    }
    
    func alert(title: String, message: String, buttonTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { _ in}))
        self.view!.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    func playGame(){
        let bannerView = self.view?.viewWithTag(100) as! GADBannerView?
        bannerView?.isHidden = true
        if(UserDefaults.standard.bool(forKey: "tutorialActive") == true){
            self.segue(toScene: TutorialScene(size: self.frame.size))
            print("TUTORIAL")
        } else {
            self.segue(toScene: GameScene(size: self.frame.size))
            print("GAMESCENE")
        }
        
    }
    
    func segue(toScene: SKScene){
        let transition:SKTransition = SKTransition.push(with: SKTransitionDirection.up, duration: 1)
        let scene = toScene
        scene.scaleMode = .aspectFill
        motionManager?.stopAccelerometerUpdates()
        self.removeAllChildren()
        self.removeAllActions()
        //Error here with nil view
        self.view?.presentScene(scene, transition: transition)
    }
    
}
