//
//  ShopItem.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/20/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit

class ShopItem: SKSpriteNode {
    let shadow = SKSpriteNode()
    var skinName = String()
    var price = Int()
    var textNum0 = String()
    var textNum1 = String()
    var textNum2 = String()
    var textNum3 = String()
    var isActive = Bool()
    var isOwned = Bool()
    
    init(skinName:String, priceNum:Int, text0:String, text1:String, text2:String, text3:String){
        
        super.init(texture: SKTexture(), color: UIColor(), size: CGSize())
        isUserInteractionEnabled = true
        
        
        self.texture = SKTexture(imageNamed: "ShopItem")
        
        self.textNum0 = text0
        self.textNum1 = text1
        self.textNum2 = text2
        self.textNum3 = text3
        self.skinName = skinName
        self.price = priceNum
        self.isActive = UserDefaults.standard.bool(forKey: "\(skinName)Active")
        self.isOwned = UserDefaults.standard.bool(forKey: "\(skinName)Owned")
        createLetters()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPopup(){
        let popupSize = CGSize(width: (scene?.frame.width)! - 100, height: (scene?.frame.height)! / 2)
        let popup = ShopPopup(rectOfSize: popupSize, skinName: skinName, priceNum: price, text0: textNum0, text1: textNum1, text2: textNum2, text3: textNum3)
        popup.position = CGPoint(x: (-popup.frame.width / 2) - (scene?.frame.width)!, y: -popup.frame.height / 2)
        popup.name = "popup"
        if(self.parent?.childNode(withName: "popup") == nil){
            self.parent?.addChild(popup)
            popup.enterScreen()
        }
    }
    
    func createShadow(){
        shadow.texture = SKTexture(imageNamed: "ShopItemShadow")
        shadow.position = CGPoint(x: self.position.x, y: self.position.y - 10)
        shadow.zPosition = self.zPosition - 1
        shadow.size = self.size
        self.parent?.addChild(shadow)
    }
    
    func createLetters(){
        for i in 0...3{
            let letter = Letter()
            letter.isUserInteractionEnabled = false
            letter.physicsBody?.isDynamic = false
            letter.texture = SKTexture(imageNamed: "\(skinName)\(i)")
            let midpointX = Int(self.frame.midX) - (180) + (120 * i)
            letter.position = CGPoint(x: midpointX, y: Int(self.frame.midY))
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.press()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self.parent!)
            if self.contains(location) {
                self.press()
            } else {
                self.lift()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lift()
        
        createPopup()
    }
    
    func press(){
        self.position = CGPoint(x: self.position.x, y: shadow.position.y + 4)
    }
    
    func lift(){
        self.position = CGPoint(x: self.position.x, y: shadow.position.y + 10)
    }
}
