//
//  AdMobViewController.swift
//  WordFallOOP
//
//  Created by Braden Ross on 4/23/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class AdMobViewController: UIViewController, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!
    var count = 0
    var countdown = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdown.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.frame.height / 2)
        countdown.textAlignment = NSTextAlignment.center
        countdown.text = "Ad dismissed in 10"
        self.view.addSubview(countdown)
        
        
        firstLoad()
        
        tryLoadAd()
        
    }
    
    func firstLoad(){
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4212352933737390/3503002911")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
 
    @objc func tryLoadAd(){
        if (interstitial.isReady){
            self.interstitial.present(fromRootViewController: self)
        } else {
            if (count < 10) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.count += 1
                    self.countdown.text = "Ad dismissed in \(10 - self.count)"
                    print("Ad not ready retrying")
                    self.tryLoadAd()
                }
            } else {
                print("Ad was not ready")
                self.countdown.text = "Ad closing"
                dismiss(animated: true, completion: nil)
            }
            
            
        }
        
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("Ad Presented")
        firstLoad()
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("Ad Dismissed")
        interstitial = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        self.dismiss(animated: true, completion: nil)
        interstitial = nil
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError){
        print(error)
        count = 10
        self.dismiss(animated: true, completion: nil)
    }
    
}
