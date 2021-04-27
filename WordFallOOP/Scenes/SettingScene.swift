//
//  SettingScene.swift
//  WordFallOOP
//
//  Created by Braden Ross on 4/25/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsScene: SKScene {
    
    let tutorialButton = Button(action: {})
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let backButton = Button(action: { self.backToMainMenu() })
        backButton.position = CGPoint(x: (self.frame.width / -2) + 100, y: (self.frame.height / 2) - 100)
        backButton.size = CGSize(width: self.frame.size.width / 6, height: self.frame.size.width / 12)
        backButton.texture = SKTexture(imageNamed: "BackButton")
        backButton.zPosition = 100
        self.addChild(backButton)
        backButton.createShadow(imageNamed: "BackShadow")
            
        tutorialButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        tutorialButton.size = CGSize(width: self.frame.width / 1.5, height: self.frame.width / 8)
        if(UserDefaults.standard.bool(forKey: "tutorialActive") == true){
            tutorialButton.texture = SKTexture(imageNamed: "TutorialOn")
        } else {
            tutorialButton.texture = SKTexture(imageNamed: "TutorialOff")
        }
        tutorialButton.zPosition = 100
        tutorialButton.action = {self.changeTutButton()}
        self.addChild(tutorialButton)
        tutorialButton.createShadow(imageNamed: "TutorialShadow")
        
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
    
    func changeTutButton(){
        if(UserDefaults.standard.bool(forKey: "tutorialActive") == true){
            tutorialButton.texture = SKTexture(imageNamed: "TutorialOff")
            UserDefaults.standard.setValue(false, forKey: "tutorialActive")
        } else {
            tutorialButton.texture = SKTexture(imageNamed: "TutorialOn")
            UserDefaults.standard.setValue(true, forKey: "tutorialActive")
        }
    }
}
