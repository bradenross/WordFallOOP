//
//  GameScene.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/14/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    var motionManager:CMMotionManager? = CMMotionManager()
    
    var joint = SKPhysicsJointPin()
    
    let warning = WarningLabel(fontNamed: "Avenir-Heavy", text: "WARNING", fontSize: 50, color: UIColor.red)
    let scoreLabel = SKLabelNode(fontNamed: "Avenir-Book")
    let wordLabel = SKLabelNode(fontNamed: "Avenir-Book")
    
    let bottomBar = SKSpriteNode()
    let pauseButton = Button(action: {})
    let powerupButton = Button(action: {})

    var word = String()
    var lives = 3
    var hearts = [SKSpriteNode]()
    var lettersNeeded = 2
    var gamePaused = false
    var gameOver = false
    //Powerup menu, buttons, logos
    let powerupMenu = SKSpriteNode()
    let freezeButton = Button(action: {})
    let freezeLogo = SKSpriteNode()
    let destroyButton = Button(action: {})
    let destroyLogo = SKSpriteNode()
    let moonButton = Button(action: {})
    let moonLogo = SKSpriteNode()
    //Powerups enabled/disabled
    var gravSpeed = 50 //Is 50 when moon powerup is not enable and 5 when enabled
    var moonEnabled = false
    var freezeEnabled = false
    var destroyEnabled = false
    var timer = 30
    let countdown = SKLabelNode(fontNamed: "Avenir-Book")
    var freezeNum = 2
    var destroyNum = 3
    var moonNum = 1
    let freezeLabel = SKLabelNode(fontNamed: "Avenir-Book")
    let destroyLabel = SKLabelNode(fontNamed: "Avenir-Book")
    let moonLabel = SKLabelNode(fontNamed: "Avenir-Book")
    
    override func didMove(to view: SKView) {
        
        warning.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(warning)
        warning.isHidden = true
        
        //Scene setup
        SKScene().deviceSize(scene: self)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.scaleMode = .aspectFit
        self.name = ""
        
        score = 0
        //Motion for phone tilting
        motionManager?.startAccelerometerUpdates()
        
        let swipeRight = UISwipeGestureRecognizer(target: self,
            action: #selector(GameScene.swipeRight(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,
            action: #selector(GameScene.swipeLeft(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        createBottomBar()
        createLetters()
        createLabels()
    }
    
    deinit {
        print("GameScene Deinit")
        motionManager?.stopAccelerometerUpdates()
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    func createLabels(){
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 30, y: self.frame.height - 100)
        scoreLabel.fontSize = 35
        scoreLabel.name = "scoreLabel"
        scoreLabel.zPosition = -1
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        wordLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 200)
        wordLabel.fontSize = 50
        wordLabel.lineBreakMode = .byWordWrapping
        wordLabel.numberOfLines = 0
        wordLabel.name = "answerLabel"
        wordLabel.zPosition = 25
        
        self.addChild(wordLabel)
        self.addChild(scoreLabel)
        
        showLives()
    }
    
    func createBottomBar(){
        bottomBar.texture = SKTexture(imageNamed: "BottomBar")
        powerupButton.action = {self.openClosePowerups()}
        pauseButton.action = { self.showPauseEndMenu() }
        
        bottomBar.size = CGSize(width: self.frame.width - 50, height: 125)
        bottomBar.position = CGPoint(x: self.frame.midX, y: 90)
        bottomBar.name = "BottomBar"
        bottomBar.zPosition = 1000
        bottomBar.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bottomBar.frame.width, height: bottomBar.frame.height))
        bottomBar.physicsBody?.isDynamic = false
        bottomBar.physicsBody?.allowsRotation = false
        self.addChild(bottomBar)
        
        pauseButton.texture = SKTexture(imageNamed: "PauseButton")
        pauseButton.position = CGPoint(x: bottomBar.frame.minX + 100, y: bottomBar.frame.midY + 5)
        pauseButton.size = CGSize(width: 125, height: 75)
        pauseButton.zPosition = bottomBar.zPosition + 2
        self.addChild(pauseButton)
        pauseButton.createShadow(imageNamed: "SmallShadow")
        
        powerupButton.texture = SKTexture(imageNamed: "PowerupButton")
        powerupButton.position = CGPoint(x: bottomBar.frame.maxX - 100, y: bottomBar.frame.midY + 5)
        powerupButton.size = CGSize(width: 125, height: 75)
        powerupButton.zPosition = bottomBar.zPosition + 2
        self.addChild(powerupButton)
        powerupButton.createShadow(imageNamed: "SmallShadow")
        
        freezeLogo.texture = SKTexture(imageNamed: "Snowflake")
        freezeLogo.size = CGSize(width: bottomBar.frame.height - 35, height: bottomBar.frame.height - 35)
        freezeLogo.position = CGPoint(x: pauseButton.frame.maxX + freezeLogo.frame.width / 2 + 25, y: bottomBar.position.y)
        freezeLogo.zPosition = bottomBar.zPosition + 1
        freezeLogo.isHidden = true
        freezeLogo.name = "freezeLogo"
        
        destroyLogo.texture = SKTexture(imageNamed: "Dynamite")
        destroyLogo.size = CGSize(width: bottomBar.frame.height - 15, height: bottomBar.frame.height - 35)
        destroyLogo.position = CGPoint(x: bottomBar.frame.midX, y: bottomBar.position.y)
        destroyLogo.zPosition = bottomBar.zPosition + 1
        destroyLogo.isHidden = true
        destroyLogo.name = "destroyLogo"
        
        moonLogo.texture = SKTexture(imageNamed: "Moon")
        moonLogo.size = CGSize(width: bottomBar.frame.height - 35, height: bottomBar.frame.height - 35)
        moonLogo.position = CGPoint(x: powerupButton.frame.minX - moonLogo.frame.width / 2 - 25, y: bottomBar.position.y)
        moonLogo.zPosition = bottomBar.zPosition + 1
        moonLogo.isHidden = true
        moonLogo.name = "moonLogo"
        
        self.addChild(freezeLogo)
        self.addChild(destroyLogo)
        self.addChild(moonLogo)
    }
    
    
    
    func createLetters(){
        //Creating random letters on board
        let x1 = CGFloat(45)
        let x2 = CGFloat(90)
        
        var yPos = CGFloat(195)
        var xPos = CGFloat(45)
        var x = 1
        var i = 0
        
        for _ in 1...49{
            let letter = Letter()
            letter.position = CGPoint(x: xPos, y: yPos)
            letter.name = String(i)
            self.addChild(letter)
            
            if (xPos + 89 < self.frame.size.width){
                xPos = CGFloat(xPos + 90)
            } else {
                if (x == 0){
                    xPos = x1
                    x = 1
                } else if (x == 1) {
                    xPos = x2
                    x = 0
                }
                yPos = CGFloat(yPos + 80)
            }
            i+=1
        }
    }
    
    func showLives(){
        var i = 0
        while(hearts.count < lives){
            let heart = SKSpriteNode(imageNamed: "HeartAlive")
            heart.size = CGSize(width: 25, height: 25)
            heart.position = CGPoint(x: self.frame.width - CGFloat(i * Int(40)) - 45, y: self.frame.height - 90)
            heart.zPosition = -1
            heart.name = "heart\(i)"
            hearts.append(heart)
            self.addChild(heart)
            i += 1
        }
    }
    
    func test(word: String) -> Bool{
        let fileName = String(word.count)
        print(fileName)
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: filepath, encoding: .utf8)
                let contentsArray = data.components(separatedBy: .newlines)
                for words in contentsArray {
                    if (word == words){
                        return true
                    }
                }
            } catch {
                print("Contents Couldn't be loaded")
                return false
            }
        } else {
            print("Couldn't load file")
            return false
        }
        return false
    }
    
    func removeWord(){
        score += LetterOddsAndScores().wordScore(word: word)
        scoreLabel.text = "Score: \(score)"
        if(score > UserDefaults.standard.integer(forKey: "highScore")){
            UserDefaults.standard.set(score, forKey: "highScore")
        }
        if(lettersNeeded < LetterOddsAndScores().lettersNeeded()){
            warning.text = "Letters needed is now \(LetterOddsAndScores().lettersNeeded())"
            warning.fontColor = UIColor.green
            warning.showWarning()
            lettersNeeded = LetterOddsAndScores().lettersNeeded()
        }
    }
    
    func removeHeart(){
        if(hearts.count > 0){
            let node = childNode(withName: hearts[0].name!)
            let grow:SKAction = SKAction.scale(by: 3.0, duration: 0.3)
            let shrink:SKAction = SKAction.scale(to: 0, duration: 0.4)
            let remove:SKAction = SKAction.run {
                node?.removeFromParent()
            }
            let disappear:SKAction = SKAction.sequence([grow, shrink, remove])
            node!.run(disappear)
            hearts.remove(at: 0)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * Double(self.gravSpeed), dy: accelerometerData.acceleration.y * Double(self.gravSpeed))
        }
    }
    
    override func willMove(from view: SKView) {
        motionManager?.stopAccelerometerUpdates()
    }
}
