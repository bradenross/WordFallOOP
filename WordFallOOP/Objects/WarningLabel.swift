//
//  WarningLabel.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/17/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit

class WarningLabel: SKLabelNode{
    
    convenience init (fontNamed:String!, text: String!, fontSize: CGFloat!, color: UIColor){
        self.init(fontNamed: fontNamed)
        self.text = text
        self.fontSize = fontSize
        self.color = color
        
        self.fontColor = self.color
    }
    
    func showWarning(){
        self.isHidden = false
        self.fitToWidth(maxWidth: scene!.frame.width - 100, originalSize: 50)
        let hide = SKAction.run {
            self.isHidden = true
        }
        let fadeInAndOut:SKAction = SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 1), SKAction.wait(forDuration: 1), SKAction.fadeAlpha(to: 0, duration: 1), hide])
        self.run(fadeInAndOut)
    }
    
}

extension SKLabelNode{
    func fitToWidth(maxWidth: CGFloat, originalSize: CGFloat){
        if(frame.size.width > maxWidth){
            while(frame.size.width > maxWidth){
                fontSize -= 1
            }
        } else if(fontSize < originalSize) {
            fontSize = originalSize
            fitToWidth(maxWidth: maxWidth, originalSize: originalSize)
        }
    }
}
