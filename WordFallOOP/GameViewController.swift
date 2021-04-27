//
//  GameViewController.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/14/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import AudioToolbox

var textureName = String()
var text0 = String()
var text1 = String()
var text2 = String()
var text3 = String()
var selected = [Letter]()
var joints = [SKPhysicsJointPin]()
var score = 0
var coins = score / 20
let colors : [String:UIColor] = ["white": UIColor.white, "black": UIColor.black, "gray": UIColor.gray,"turquoise": UIColor.cyan,"red": UIColor.red,"yellow":UIColor.yellow,"blue": UIColor.blue, "green": UIColor.green]
var letterList = [String()]

class GameViewController: UIViewController, GADBannerViewDelegate, GADRewardedAdDelegate {
    
    var bannerView:GADBannerView!
    var rewardedAd:GADRewardedAd!
    var skView:SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LetterJSONInfo().setLetterList()
        LetterJSONInfo().setActiveLetter()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore == true  {
            print("Not first launch.")
            //UserDefaults.standard.setValue(false, forKey: "launchedBefore")
        } else {
            print("First launch, Creating Data.")
            // Initializing shop values
            UserDefaults.standard.setValue(true, forKey: "defaultOwned")
            UserDefaults.standard.setValue(true, forKey: "defaultActive")
            UserDefaults.standard.setValue(false, forKey: "americaOwned")
            UserDefaults.standard.setValue(false, forKey: "americaActive")
            UserDefaults.standard.setValue(false, forKey: "blackwhiteOwned")
            UserDefaults.standard.setValue(false, forKey: "blackwhiteActive")
            UserDefaults.standard.setValue(false, forKey: "silvergoldOwned")
            UserDefaults.standard.setValue(false, forKey: "silvergoldActive")
            UserDefaults.standard.setValue(false, forKey: "pinkpurpleOwned")
            UserDefaults.standard.setValue(false, forKey: "pinkpurpleActive")
            // Letting app know it has been launched before
            UserDefaults.standard.setValue(true, forKey: "tutorialActive")
            UserDefaults.standard.setValue(true, forKey: "launchedBefore")
            LetterJSONInfo().setActiveLetter()
        }
        
        //UserDefaults.standard.setValue(2500, forKey: "coins")
        
        if let view = self.view as! SKView? {
            skView = view
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MainMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.anchorPoint = CGPoint(x: 0, y: 0)
                
                // Present the scene
                view.presentScene(scene)
            }
            
            rewardedAd = createAndLoadRewardedAd()
            
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView.frame = CGRect(x: (self.view.frame.width / 2) - (bannerView.frame.width / 2), y: self.view.frame.height - bannerView.frame.height, width: 320, height: 50)
            bannerView.delegate = self
            bannerView.adUnitID = "ca-app-pub-4212352933737390/4281941541"
            bannerView.rootViewController = self
            bannerView.tag = 100
            
            bannerView.load(GADRequest())
            view.addSubview(bannerView)
            
            view.ignoresSiblingOrder = true
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
        
    }
    
    func createAndLoadRewardedAd() -> GADRewardedAd{
      rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-4212352933737390/2222532648")
      rewardedAd?.load(GADRequest()) { error in
        if let error = error {
          print("Loading failed: \(error)")
        } else {
          print("Loading Succeeded")
        }
      }
      return rewardedAd!
    }
    
    override func viewWillLayoutSubviews() {
        NotificationCenter.default.addObserver(self, selector: #selector(playReward), name: NSNotification.Name(rawValue: "showVideoRewardAd"), object: nil)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    @objc func playReward(){
        if rewardedAd?.isReady == true {
            print("PRESENT")
            rewardedAd?.present(fromRootViewController: self, delegate: self)
        }
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("Banner clicked")
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        if let soundURL = Bundle.main.url(forResource: "coins-in-hand-1", withExtension: "mp3") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
            // Play
            AudioServicesPlaySystemSound(mySound);
        }
        coins *= 2
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "doubleCoins"), object: nil)
        print("REWARD")
    }
    
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.rewardedAd = createAndLoadRewardedAd()
        dismiss(animated: true, completion: nil)
        print("Reward Closed")
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        self.rewardedAd = createAndLoadRewardedAd()
        print("ERROR")
        print(error)
        print("ERROR")
    }
    
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
