//
//  Button.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/15/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit

class Button:SKSpriteNode {
    
    let buttonShadow = SKSpriteNode()
    var action: () -> Void
    var isEnabled = Bool()
    
    init(action: @escaping () -> Void){
        
        let texture = SKTexture(imageNamed: "")
        let color = SKColor.black
        let size = CGSize(width: 0, height: 0)
        self.action = action
        self.isEnabled = true
        
        
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
        if(isEnabled){
            self.press()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isEnabled){
            for touch in touches {
                let location = touch.location(in: self.parent!)
                if self.contains(location) {
                    self.press()
                } else {
                    self.lift()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isEnabled){
            self.lift()
            action()
        }
    }
    
    func press(){
        self.position = CGPoint(x: self.position.x, y: buttonShadow.position.y + 4)
    }
    
    func lift(){
        self.position = CGPoint(x: self.position.x, y: buttonShadow.position.y + 10)
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
