//
//  ShopPopup.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/20/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit

class ShopPopup: SKShapeNode {
    let exitButton = SKSpriteNode()
    let priceNode = SKLabelNode(fontNamed: "HelveticaNeue")
    let purchaseButton = PurchaseButton()
    
    var skinName = String()
    var price = Int()
    var textNum0 = String()
    var textNum1 = String()
    var textNum2 = String()
    var textNum3 = String()
    var isActive = Bool()
    var isOwned = Bool()
    
    init(rectOfSize:CGSize, skinName:String, priceNum:Int, text0:String, text1:String, text2:String, text3:String){
        super.init()
        
        self.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rectOfSize.width, height: rectOfSize.height), cornerRadius: rectOfSize.height / 15).cgPath
        self.fillColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.zPosition = 100
        
        self.textNum0 = text0
        self.textNum1 = text1
        self.textNum2 = text2
        self.textNum3 = text3
        self.skinName = skinName
        self.price = priceNum
        self.isActive = UserDefaults.standard.bool(forKey: "\(skinName)Active")
        self.isOwned = UserDefaults.standard.bool(forKey: "\(skinName)Owned")
        
        createPrice()
        createExit()
        showSkins()
        createPurchase()
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSkins(){
        for i in 0...3{
            let letter = Letter()
            letter.isUserInteractionEnabled = false
            letter.physicsBody?.isDynamic = false
            letter.texture = SKTexture(imageNamed: "\(self.skinName)\(i)")
            let midpointX = Int(self.frame.midX) - (180) + (120 * i)
            let letterPosY = Int(self.frame.maxY) - (Int(letter.size.height))
            letter.position = CGPoint(x: midpointX, y: letterPosY)
            letter.zPosition = self.zPosition + 1
            letter.letterNode.fontName = "HelveticaNeue-Light"
            self.addChild(letter)
            if(i % 2 == 1){
                letter.letterNode.text = "A"
            } else {
                letter.letterNode.text = "B"
            }
            switch i {
            case 0:
                letter.letterNode.fontColor = colors[textNum0]
            case 1:
                letter.letterNode.fontColor = colors[textNum1]
            case 2:
                letter.letterNode.fontColor = colors[textNum2]
            case 3:
                letter.letterNode.fontColor = colors[textNum3]
            default:
                letter.letterNode.fontColor = UIColor.white
            }
        }
    }
    
    func createPrice(){
        if(isOwned == true){
            priceNode.text = "Already Owned"
        } else {
            priceNode.text = "\(price) coins"
        }
        priceNode.fontColor = UIColor.white
        priceNode.fontSize = 50
        priceNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(priceNode)
    }
    
    func createExit(){
        exitButton.texture = SKTexture(imageNamed: "ExitButton")
        exitButton.size = CGSize(width: 60, height: 60)
        exitButton.position = CGPoint(x: self.frame.maxX - (exitButton.size.width / 3), y: self.frame.maxY - (exitButton.size.height / 3))
        self.addChild(exitButton)
    }
    
    func createPurchase(){
        let skin = self.skinName
        let skinOwned = UserDefaults.standard.bool(forKey: "\(skin)Owned")
        let skinActive = UserDefaults.standard.bool(forKey: "\(skin)Active")
        print(skin)
        print(skinOwned)
        print(skinActive)
        if(skinOwned == false){
            purchaseButton.texture = SKTexture(imageNamed: "Purchase")
        } else if(skinOwned == true && skinActive == false){
            purchaseButton.texture = SKTexture(imageNamed: "Activate")
        } else if(skinOwned == true && skinActive == true){
            purchaseButton.texture = SKTexture(imageNamed: "Active")
        }
        purchaseButton.size = CGSize(width: self.frame.width / 1.5, height: (self.frame.width / 1.5) / 4)
        purchaseButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (purchaseButton.size.height / 2) + 50)
        purchaseButton.zPosition = self.zPosition + 10
        purchaseButton.name = "purchaseButton"
        self.addChild(purchaseButton)
        purchaseButton.createShadow(imageNamed: "PopupButtonShadow")
        
    }
    
    func enterScreen(){
        let moveRight:SKAction = SKAction.moveBy(x: (scene?.frame.width)!, y: 0, duration: 0.3)
        self.run(moveRight)
    }
    
    func leaveScreen(){
        let moveRight:SKAction = SKAction.moveBy(x: (scene?.frame.width)!, y: 0, duration: 0.3)
        let removeFromScreen:SKAction = SKAction.run {
            self.removeAllChildren()
            self.removeFromParent()
        }
        self.run(SKAction.sequence([moveRight, removeFromScreen]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if exitButton.contains(location) {
                leaveScreen()
            }
        }
    }
}
