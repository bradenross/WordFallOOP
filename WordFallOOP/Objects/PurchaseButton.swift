//
//  PurchaseButton.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/25/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit

class PurchaseButton:SKSpriteNode {
    
    let buttonShadow = SKSpriteNode()
    var segueScene = SKScene()
    var alertTitle = String()
    var alertMessage = String()
    
    init(){
        
        let texture = SKTexture(imageNamed: "")
        let color = SKColor.black
        let size = CGSize(width: 0, height: 0)
        
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createShadow(imageNamed: String){
        buttonShadow.texture = SKTexture(imageNamed: imageNamed)
        buttonShadow.position = CGPoint(x: self.position.x, y: self.position.y - 10)
        buttonShadow.zPosition = self.zPosition - 1
        buttonShadow.size = self.size
        self.parent?.addChild(buttonShadow)
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
        let skin = (self.parent as? ShopPopup)?.skinName
        let skinOwned = UserDefaults.standard.bool(forKey: "\(skin!)Owned")
        print(skin!)
        
        self.lift()
        if((self.parent as? ShopPopup)?.isActive == false && skinOwned == false){
            if(UserDefaults.standard.integer(forKey: "coins") >= (self.parent as? ShopPopup)!.price){
                purchase()
            } else {
                alert(title: "Get Some More Coins", message: "Play some more and get some more coins!")
            }
        } else if((self.parent as? ShopPopup)?.isActive == false && skinOwned == true){
            for names in letterList {
                if (UserDefaults.standard.bool(forKey: "\(names)Active") == true) {
                    UserDefaults.standard.setValue(false, forKey: "\(names)Active")
                }
            }
            UserDefaults.standard.setValue(true, forKey: "\(skin!)Active")
            self.texture = SKTexture(imageNamed: "Active")
            LetterJSONInfo().setActiveLetter()
        }
    }
    
    func purchase(){
        let skin = (self.parent as? ShopPopup)?.skinName
        UserDefaults.standard.setValue(true, forKey: "\(skin!)Owned")
        let newCoins = UserDefaults.standard.integer(forKey: "coins") - (self.parent as? ShopPopup)!.price
        (self.parent as? ShopPopup)?.priceNode.text = "Already Owned"
        UserDefaults.standard.setValue(newCoins, forKey: "coins")
        self.texture = SKTexture(imageNamed: "Activate")
    }
    
    func press(){
        self.position = CGPoint(x: self.position.x, y: buttonShadow.position.y + 4)
    }
    
    func lift(){
        self.position = CGPoint(x: self.position.x, y: buttonShadow.position.y + 10)
    }
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: { _ in}))
        scene?.view!.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    func createPhysicsBody(){
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        buttonShadow.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        buttonShadow.physicsBody?.affectedByGravity = false
        buttonShadow.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.friction = 0.1
    }
}
