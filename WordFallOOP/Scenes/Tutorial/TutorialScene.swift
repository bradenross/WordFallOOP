//
//  TutorialScene.swift
//  WordFallOOP
//
//  Created by Braden Ross on 4/23/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

var tutSelected = [TutLetter]()

class TutorialScene: SKScene {
    
    let wordArray = ["W", "O", "R", "D"]
    
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
    //Tutorial Steps Nodes
    var tutStep = 0
    let stepsLabel = SKLabelNode(fontNamed: "Avenir-Book")
    var handStartPoint = CGPoint()
    let hand = SKSpriteNode(imageNamed: "Hand")
    let phone = SKSpriteNode(imageNamed: "iPhone")
    
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
        //motionManager?.startAccelerometerUpdates()
        
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
        
        moveHandTaps()
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
        
        stepsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        stepsLabel.fontSize = 50
        stepsLabel.lineBreakMode = .byWordWrapping
        stepsLabel.numberOfLines = 3
        stepsLabel.zPosition = 30
        stepsLabel.isHidden = true
        stepsLabel.horizontalAlignmentMode = .center
        self.addChild(phone)
        phone.isHidden = true
        
        self.addChild(wordLabel)
        self.addChild(scoreLabel)
        self.addChild(stepsLabel)
        
        showLives()
    }
    
    func createBottomBar(){
        bottomBar.texture = SKTexture(imageNamed: "BottomBar")
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
        powerupButton.isEnabled = false
    }
    
    
    
    func createLetters(){
        //Creating random letters on board
        let x1 = CGFloat(45)
        let x2 = CGFloat(90)
        
        var yPos = CGFloat(195)
        var xPos = CGFloat(45)
        var x = 1
        var i = 0
        
        for _ in 1...18{
            let letter = TutLetter()
            letter.position = CGPoint(x: xPos, y: yPos)
            letter.name = "letter"
            self.addChild(letter)
            letter.physicsBody?.isDynamic = false
            letter.isUserInteractionEnabled = false
            
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
        
        for letters in wordArray{
            let letter = TutLetter()
            letter.position = CGPoint(x: xPos, y: yPos)
            letter.name = "letter"
            self.addChild(letter)
            letter.letter = letters
            letter.letterNode.text = letters
            letter.getTexture()
            letter.physicsBody?.isDynamic = false
            letter.isUserInteractionEnabled = true
            if(i == 18){
                hand.isUserInteractionEnabled = false
                hand.size = CGSize(width: 100, height: 175)
                hand.position = CGPoint(x: letter.position.x, y: letter.position.y - (hand.size.height / 2))
                handStartPoint = hand.position
                hand.zPosition = letter.zPosition + 1
                self.addChild(hand)
            }
            
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

        
        for _ in 23...50{
            let letter = TutLetter()
            letter.position = CGPoint(x: xPos, y: yPos)
            letter.name = "letter"
            self.addChild(letter)
            letter.physicsBody?.isDynamic = false
            letter.isUserInteractionEnabled = false
            
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
                        print(words)
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
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 50, dy: accelerometerData.acceleration.y * 50)
        }
    }
    
    override func willMove(from view: SKView) {
        motionManager?.stopAccelerometerUpdates()
    }
}
