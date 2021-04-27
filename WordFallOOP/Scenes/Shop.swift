//
//  Shop.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/19/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit

class Shop:SKScene{
    
    var index = 0
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let backButton = Button(action: { self.backToMainMenu() })
        backButton.position = CGPoint(x: (self.frame.width / -2) + 100, y: (self.frame.height / 2) - 100)
        backButton.size = CGSize(width: self.frame.size.width / 6, height: self.frame.size.width / 12)
        backButton.texture = SKTexture(imageNamed: "BackButton")
        backButton.zPosition = 100
        self.addChild(backButton)
        backButton.createShadow(imageNamed: "BackShadow")
        
        var posY:CGFloat = 0
        
        for i in 0...(LetterJSONInfo().getShopCount() - 1){
            let shopItem = LetterJSONInfo().getShopItem(index: i)
            
            shopItem.size = CGSize(width: self.frame.width - 100, height: 120)
            shopItem.position = CGPoint(x: self.frame.midX, y: scene!.frame.midY + (175 * posY))
            self.addChild(shopItem)
            shopItem.createShadow()
            
            if(posY > 0){
                posY *= -1
            } else {
                posY -= 1
                posY *= -1
            }
        }
        
    }
    
    deinit {
        print("shop deinit")
    }
    
    func backToMainMenu(){
        let transition:SKTransition = SKTransition.push(with: SKTransitionDirection.down, duration: 1)
        let scene = MainMenu(size: self.frame.size)
        scene.scaleMode = .aspectFill
        self.removeAllChildren()
        //Error here with nil view
        self.view?.presentScene(scene, transition: transition)
    }
    
}
