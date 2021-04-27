//
//  TutLetter.swift
//  WordFallOOP
//
//  Created by Braden Ross on 4/23/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

class TutLetter:SKSpriteNode{
    
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
    
    func distanceFromLetter(letter2: TutLetter) -> CGFloat{
        let distance = ((self.position.x - letter2.position.x) * (self.position.x - letter2.position.x) + (self.position.y - letter2.position.y) * (self.position.y - letter2.position.y)).squareRoot()
        return distance
    }
    
    func createConnection(letter2: TutLetter) {
        if(distanceFromLetter(letter2: letter2) < 93){
            let distX = abs((self.position.x - letter2.position.x))
            let distY = abs((self.position.y - letter2.position.y))
            let connectPoint = CGPoint(x: distX, y: distY)
            let joint = SKPhysicsJointPin.joint(withBodyA: self.physicsBody!, bodyB: letter2.physicsBody!, anchor: connectPoint)
            joints.append(joint)
            scene!.physicsWorld.add(joint)
            AudioServicesPlaySystemSound(1103)
            tutSelected.append(self)
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
        
        let letter = TutLetter()
        letter.size = CGSize(width: 1, height: 1)
        letter.letter = char
        letter.name = "letter"
        letter.texture = SKTexture(imageNamed: "\(textureName)0")
        letter.position = CGPoint(x: xPos, y: yPos)
        self.parent?.addChild(letter)
    }
    
    func active(){
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
        
    }
    
    func getWord(){
        (self.parent as? TutorialScene)!.word = ""
        for item in tutSelected {
            (self.parent as? TutorialScene)!.word.append(item.letter)
        }
        (self.parent as? TutorialScene)!.wordLabel.text = (self.parent as? TutorialScene)!.word
        (self.parent as? TutorialScene)!.wordLabel.fitToWidth(maxWidth: scene!.frame.width - 100, originalSize: 50)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.isActive == false && tutSelected.isEmpty == false){
            self.createConnection(letter2: tutSelected.last!)
        } else if(tutSelected.isEmpty == true && self.isActive == false){
            AudioServicesPlaySystemSound(1103)
            tutSelected.append(self)
            self.active()
            print("empty")
            
        } else if(self.isActive == true) {
            while(tutSelected.reversed()[0] != self){
                scene?.physicsWorld.remove(joints.reversed()[0])
                joints.removeLast()
                tutSelected.reversed()[0].active()
                tutSelected.removeLast()
            }
            self.active()
            tutSelected.removeLast()
            if(joints.count != 0){
                scene?.physicsWorld.remove(joints.reversed()[0])
                joints.removeLast()
            }
        }
        getWord()
        
        if((self.parent as? TutorialScene)!.word == "WORD" && (self.parent as? TutorialScene)!.tutStep == 0){
            (self.parent as? TutorialScene)!.tutStep = 1
            (self.parent as? TutorialScene)!.swipeRightHand()
        } else if ((self.parent as? TutorialScene)!.word != "WORD" && (self.parent as? TutorialScene)!.tutStep == 1){
            print("HERE")
            (self.parent as? TutorialScene)!.tutStep = 0
            (self.parent as? TutorialScene)!.moveHandTaps()
        } else if ((self.parent as? TutorialScene)!.word.count == 4 && (self.parent as? TutorialScene)!.tutStep == 2){
            print("HERE")
            (self.parent as? TutorialScene)!.tutStep = 3
            (self.parent as? TutorialScene)!.tapLetter()
        } else if ((self.parent as? TutorialScene)!.word.count != 4 && (self.parent as? TutorialScene)!.tutStep == 3){
            print("HERE")
            (self.parent as? TutorialScene)!.tutStep = 4
            (self.parent as? TutorialScene)!.swipeLeftHand()
        }
        print("ACTIVE: \(isActive) FROZE: \(isFrozen)")
    }
}
