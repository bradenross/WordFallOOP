//
//  Letter.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/14/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class Letter:SKSpriteNode{
    
    var isActive:Bool = false
    var letter:String = "A"
    var isFrozen:Bool = false
    var letterNode = SKLabelNode(fontNamed: "HelveticaNeue-Light")
    
    let vowels = ["A", "E", "I", "O", "U"]
    
    
    init(){
        
        let texture = SKTexture(imageNamed: "\(textureName)0")
        let color = SKColor.black
        let size = CGSize(width: 90, height: 90)
        
        super.init(texture: texture, color: color, size: size)
        
        isUserInteractionEnabled = true
        
        letter = self.getLetter()
        self.getTexture()
        
        letterNode.fontColor = colors[text0]
        letterNode.fontSize = 55
        letterNode.text = letter
        letterNode.zPosition = self.zPosition + 1
        self.addChild(letterNode)
        letterNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY - letterNode.frame.size.height / 2)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 45)
        self.physicsBody?.restitution = 0.3
        self.physicsBody?.friction = 0.1
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    func getTexture(){
        if (vowels.contains(letter) && isActive == false) {
            self.texture = SKTexture(imageNamed: "\(textureName)0")
        } else if(!(vowels.contains(letter)) && isActive == false) {
            self.texture = SKTexture(imageNamed: "\(textureName)1")
        } else if(vowels.contains(letter) && isActive == true){
            self.texture = SKTexture(imageNamed: "\(textureName)2")
        } else if(!(vowels.contains(letter)) && isActive == true) {
            self.texture = SKTexture(imageNamed: "\(textureName)3")
        }
    }
    
    func getLetter() -> String{
        let rndInt = LetterOddsAndScores().letterOdds()
        let newLetter = String(Character(UnicodeScalar(rndInt)!))
        if(newLetter == "W"){
            letterNode.fontName = "LucidaHandwriting-Italic"
        }
        
        return newLetter
    }
    
    func distanceFromLetter(letter2: Letter) -> CGFloat{
        let distance = ((self.position.x - letter2.position.x) * (self.position.x - letter2.position.x) + (self.position.y - letter2.position.y) * (self.position.y - letter2.position.y)).squareRoot()
        return distance
    }
    
    func createConnection(letter2: Letter) {
        if(distanceFromLetter(letter2: letter2) < 93){
            let distX = abs((self.position.x - letter2.position.x))
            let distY = abs((self.position.y - letter2.position.y))
            let connectPoint = CGPoint(x: distX, y: distY)
            let joint = SKPhysicsJointPin.joint(withBodyA: self.physicsBody!, bodyB: letter2.physicsBody!, anchor: connectPoint)
            joints.append(joint)
            scene!.physicsWorld.add(joint)
            AudioServicesPlaySystemSound(1103)
            selected.append(self)
            self.active()
        } else {
            AudioServicesPlaySystemSound(1104)
        }
    }
    
    func removeLetter(){
        AudioServicesPlaySystemSound(1504)
        AudioServicesPlaySystemSound(1519)
        self.physicsBody?.isDynamic = false
        self.removeFromParent()
        //self.run(SKAction.sequence([shrink, newNode, removeNode]))
    }
    
    func newLetter(xPos: CGFloat, yPos: CGFloat){
        let rndInt = Int.random(in: 65...90)
        let char = String(Character(UnicodeScalar(rndInt)!))
        
        let letter = Letter()
        letter.size = CGSize(width: 1, height: 1)
        letter.letter = char
        letter.texture = SKTexture(imageNamed: "\(textureName)0")
        letter.position = CGPoint(x: xPos, y: yPos)
        self.parent?.addChild(letter)
    }
    
    func active(){
        if(!self.isFrozen){
            if(!vowels.contains(letter)){
                if(self.isActive == false){
                    self.isActive = true
                    self.texture = SKTexture(imageNamed: "\(textureName)3")
                    self.letterNode.fontColor = colors[text3]
                } else {
                    self.isActive = false
                    self.texture = SKTexture(imageNamed: "\(textureName)1")
                    self.letterNode.fontColor = colors[text1]
                }
            } else {
                if(self.isActive == false){
                    self.isActive = true
                    self.texture = SKTexture(imageNamed: "\(textureName)2")
                    self.letterNode.fontColor = colors[text2]
                } else {
                    self.isActive = false
                    self.texture = SKTexture(imageNamed: "\(textureName)0")
                    self.letterNode.fontColor = colors[text0]
                }
            }
        } else {
            if(self.isActive == false){
                self.isActive = true
                self.texture = SKTexture(imageNamed: "frozen1")
                self.letterNode.fontColor = UIColor.white
            } else {
                self.isActive = false
                self.texture = SKTexture(imageNamed: "frozen0")
                self.letterNode.fontColor = UIColor.white
            }
        }
        
        
    }
    
    func freeze(){
        if(self.isFrozen == false && self.isActive == false){
            self.physicsBody?.isDynamic = false
            self.texture = SKTexture(imageNamed: "frozen0")
            self.letterNode.fontColor = UIColor.white
            self.isFrozen = true
        } else if(self.isFrozen == false && self.isActive == true) {
            self.physicsBody?.isDynamic = false
            self.texture = SKTexture(imageNamed: "frozen1")
            self.letterNode.fontColor = UIColor.white
            self.isFrozen = true
        } else if(self.isFrozen == true && self.isActive == false){
            self.physicsBody?.isDynamic = true
            self.getTexture()
            self.isFrozen = false
            self.letterNode.fontColor = colors[text0]
        } else if(self.isFrozen == true && self.isActive == true){
            self.physicsBody?.isDynamic = true
            self.getTexture()
            self.isFrozen = false
            self.letterNode.fontColor = colors[text0]
        }
        (self.parent as? GameScene)!.freezeNum -= 1
        (self.parent as? GameScene)!.freezeLabel.text = "\((self.parent as? GameScene)!.freezeNum)"
        (self.parent as? GameScene)!.freezeEnabled = false
        (self.parent as? GameScene)!.freezeLogo.isHidden = true
        if((self.parent as? GameScene)!.freezeNum == 0) {
            (self.parent as? GameScene)!.freezeButton.isEnabled = false
        }
    }
    
    func destroy(){
        (self.parent as? GameScene)!.destroyNum -= 1
        (self.parent as? GameScene)!.destroyLabel.text = "\((self.parent as? GameScene)!.destroyNum)"
        (self.parent as? GameScene)!.destroyEnabled = false
        let x = self.position.x
        let y = self.position.y
        
        let letter = Letter()
        letter.size = CGSize(width: 90, height: 90)
        letter.position = CGPoint(x: x, y: y)
        
        self.removeLetter()
        
    }
    
    func getWord(){
        (self.parent as? GameScene)!.word = ""
        for item in selected {
            (self.parent as? GameScene)!.word.append(item.letter)
        }
        (self.parent as? GameScene)!.wordLabel.text = (self.parent as? GameScene)!.word
        (self.parent as? GameScene)!.wordLabel.fitToWidth(maxWidth: scene!.frame.width - 100, originalSize: 50)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if((self.parent as? GameScene)?.freezeEnabled == true){
            freeze()
        } else if((self.parent as? GameScene)?.destroyEnabled == true){
            (self.parent as? GameScene)?.destroyLetter(letter: self)
        } else {
            if(self.isActive == false && selected.isEmpty == false){
                self.createConnection(letter2: selected.last!)
            } else if(selected.isEmpty == true && self.isActive == false){
                AudioServicesPlaySystemSound(1103)
                selected.append(self)
                self.active()
                print("empty")
                
            } else if(self.isActive == true) {
                while(selected.reversed()[0] != self){
                    scene?.physicsWorld.remove(joints.reversed()[0])
                    joints.removeLast()
                    selected.reversed()[0].active()
                    selected.removeLast()
                }
                self.active()
                selected.removeLast()
                if(joints.count != 0){
                    scene?.physicsWorld.remove(joints.reversed()[0])
                    joints.removeLast()
                }
            }
            getWord()
        }
        print("ACTIVE: \(isActive) FROZE: \(isFrozen)")
    }
}
