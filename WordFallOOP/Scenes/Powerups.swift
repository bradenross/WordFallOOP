//
//  Powerups.swift
//  WordFallOOP
//
//  Created by Braden Ross on 4/13/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    func createPowerupMenu(){
        powerupMenu.texture = SKTexture(imageNamed: "PowerupMenu")
        powerupMenu.size = CGSize(width: 150, height: 500)
        powerupMenu.position = CGPoint(x: powerupButton.position.x + 250, y: bottomBar.frame.maxY + (powerupMenu.frame.height / 2) + 25)
        powerupMenu.name = "powerupMenu"
        powerupMenu.zPosition = 5
        
        freezeButton.texture = SKTexture(imageNamed: "FreezeButton")
        freezeButton.size = CGSize(width: 125, height: 75)
        freezeButton.position = CGPoint(x: powerupMenu.frame.midX, y: powerupMenu.frame.maxY - (freezeButton.frame.height / 2) - 25)
        freezeButton.zPosition = powerupMenu.zPosition + 5
        freezeButton.action = {self.freezeAction()}
        freezeLabel.fontSize = 25
        freezeLabel.fontColor = .white
        freezeLabel.text = "\(freezeNum)"
        freezeLabel.position = CGPoint(x: freezeButton.frame.maxX - freezeLabel.frame.width - 5, y: freezeButton.frame.minY + 10)
        freezeLabel.zPosition = freezeButton.zPosition + 1
        freezeLabel.name = "freezeNum"
        
        destroyButton.texture = SKTexture(imageNamed: "DestroyButton")
        destroyButton.size = CGSize(width: 125, height: 75)
        destroyButton.position = CGPoint(x: powerupMenu.frame.midX, y: powerupMenu.frame.midY)
        destroyButton.zPosition = powerupMenu.zPosition + 5
        destroyButton.action = {self.destroyAction()}
        destroyLabel.fontSize = 25
        destroyLabel.fontColor = .white
        destroyLabel.text = "\(destroyNum)"
        destroyLabel.position = CGPoint(x: destroyButton.frame.maxX - destroyLabel.frame.width - 5, y: destroyButton.frame.minY + 10)
        destroyLabel.zPosition = destroyButton.zPosition + 1
        destroyLabel.name = "destroyNum"
        
        moonButton.texture = SKTexture(imageNamed: "MoonButton")
        moonButton.size = CGSize(width: 125, height: 75)
        moonButton.position = CGPoint(x: powerupMenu.frame.midX, y: powerupMenu.frame.minY + (moonButton.frame.height / 2) + 25)
        moonButton.zPosition = powerupMenu.zPosition + 5
        moonButton.action = {self.moonGrav()}
        moonLabel.fontSize = 25
        moonLabel.fontColor = .white
        moonLabel.text = "\(moonNum)"
        moonLabel.position = CGPoint(x: moonButton.frame.maxX - moonLabel.frame.width - 5, y: moonButton.frame.minY + 10)
        moonLabel.zPosition = moonButton.zPosition + 1
        moonLabel.name = "moonNum"
        
        self.addChild(powerupMenu)
        self.addChild(freezeButton)
        self.addChild(freezeLabel)
        self.addChild(destroyButton)
        self.addChild(destroyLabel)
        self.addChild(moonButton)
        self.addChild(moonLabel)
        
        freezeButton.createShadow(imageNamed: "FreezeShadow")
        destroyButton.createShadow(imageNamed: "DestroyShadow")
        moonButton.createShadow(imageNamed: "MoonShadow")
    }
    
    func removePowerupsMenu(){
        powerupMenu.removeFromParent()
        freezeButton.removeFromParent()
        freezeButton.buttonShadow.removeFromParent()
        freezeLabel.removeFromParent()
        destroyButton.buttonShadow.removeFromParent()
        destroyButton.removeFromParent()
        destroyLabel.removeFromParent()
        moonButton.removeFromParent()
        moonButton.buttonShadow.removeFromParent()
        moonLabel.removeFromParent()
    }
    
    func destroyAction(){
        if(destroyEnabled == false){
            destroyEnabled = true
            destroyLogo.isHidden = false
            freezeEnabled = false
            freezeLogo.isHidden = true
        } else {
            destroyEnabled = false
            destroyLogo.isHidden = true
        }
    }
    
    func destroyLetter(letter: Letter){
        if(selected.contains(letter)){
            while(selected.last != letter){
                scene?.physicsWorld.remove(joints.last!)
                joints.removeLast()
                selected.last!.active()
                selected.removeLast()
            }
            letter.active()
            selected.removeLast()
            if(joints.count != 0){
                scene?.physicsWorld.remove(joints.last!)
                joints.removeLast()
            }
            letter.getWord()
        }
        let x = letter.position.x
        let y = letter.position.y
        let newLet = Letter()
        newLet.position = CGPoint(x: x, y: y)
        letter.removeLetter()
        self.addChild(newLet)
        destroyEnabled = false
        destroyLogo.isHidden = true
        destroyNum -= 1
        if(destroyNum == 0){
            destroyButton.isEnabled = false
        }
        destroyLabel.text = "\(destroyNum)"
    }
        
    func freezeAction(){
        if(freezeEnabled == false){
            freezeEnabled = true
            freezeLogo.isHidden = false
            destroyEnabled = false
            destroyLogo.isHidden = true
        } else {
            freezeEnabled = false
            freezeLogo.isHidden = true
        }
            
    }
        
    func closeMenu(){
    
        moonButton.moveDown()
        moonButton.buttonShadow.moveDown()
        moonLabel.moveOut()
        destroyButton.moveDown()
        destroyButton.buttonShadow.moveDown()
        destroyLabel.moveOut()
        freezeButton.moveDown()
        freezeButton.buttonShadow.moveDown()
        freezeLabel.moveOut()
        powerupMenu.moveDown()
        
    }
    
    func openMenu(){
        moonButton.moveUp()
        moonButton.buttonShadow.moveUp()
        moonLabel.moveIn()
        destroyButton.moveUp()
        destroyButton.buttonShadow.moveUp()
        destroyLabel.moveIn()
        freezeButton.buttonShadow.moveUp()
        freezeButton.moveUp()
        freezeLabel.moveIn()
        powerupMenu.moveUp()
        
    }
    
    func openClosePowerups(){
        if (powerupMenu.parent == nil){
            createPowerupMenu()
            openMenu()
        } else if(powerupMenu.position.x > powerupButton.position.x + 249){
            openMenu()
            //removePowerupsMenu()
        } else if(powerupMenu.position.x < powerupButton.position.x + 1) {
            //createPowerupsMenu()
            closeMenu()
        }
    }
        
    func moonGrav(){
        countdown.fontSize = 60
        countdown.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        countdown.color = UIColor.white
        countdown.colorBlendFactor = 1.0
        countdown.name = "countdownLabel"
        countdown.zPosition = -1
        countdown.text = "\(timer)"
        self.addChild(countdown)
        self.moonEnabled = true
        self.moonTimer()
        moonLabel.text = "0"
        self.moonButton.isEnabled = false
        
    }
    
    func moonTimer(){
        if(timer > 0 && timer < 30 && self.moonEnabled == true && gamePaused == false){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.timer -= 1
                self.countdown.text = "\(self.timer)"
                self.moonTimer()
                self.gravSpeed = 5
                self.moonLogo.isHidden = false
            }
        }
        else if(timer == 30 && self.moonEnabled == true && gamePaused == false){
            self.gravSpeed = 5
            self.moonLogo.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.timer -= 1
                self.countdown.text = "\(self.timer)"
                self.moonTimer()
            }
        } else if(timer == 0){
            self.gravSpeed = 50
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.countdown.removeFromParent()
                self.moonEnabled = false
                self.moonLogo.isHidden = true
            }
        } else if(gamePaused == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.moonTimer()
            }
        }
    }

    
}

    extension SKSpriteNode{
        
        func moveDown(){
            
            run(SKAction.moveBy(x: 250.0, y: 0, duration: 0.5))
            
        }
        
        func moveUp(){
            run(SKAction.moveBy(x: -250.0, y: 0, duration: 0.5))
        }
        
        
    }

    extension SKLabelNode{
        
        func moveOut(){
            
            run(SKAction.moveBy(x: 250.0, y: 0, duration: 0.5))
            
        }
        
        func moveIn(){
            run(SKAction.moveBy(x: -250.0, y: 0, duration: 0.5))
        }
        
        func shrink(){
            run(SKAction.scale(to: 0.7, duration: 1))
        }
        
        func moveUp(position: CGPoint){
            run(SKAction.move(to: position, duration: 1))
        }
}
