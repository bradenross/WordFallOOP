//
//  LetterJSONInfo.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/29/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation
import SpriteKit
class LetterJSONInfo {
    
    func getShopItem(index: Int) -> ShopItem{
        let shopItem:ShopItem
        let array = getJsonToArray()
        let itemDict = array[index] as? [String: Any]
        let imageName = itemDict!["name"] as? String
        let textColor0 = itemDict!["text0"] as? String
        let textColor1 = itemDict!["text1"] as? String
        let textColor2 = itemDict!["text2"] as? String
        let textColor3 = itemDict!["text3"] as? String
        let price = itemDict!["price"] as? Int
        
        shopItem = ShopItem(skinName: imageName!, priceNum: price!, text0: textColor0!, text1: textColor1!, text2: textColor2!, text3: textColor3!)
        return shopItem
    }
    
    func getShopCount() -> Int{
        var count = 0
        let array = getJsonToArray()
        for _ in array {
            count += 1
        }
        return count
    }
    
    func setLetterList(){
        let array = getJsonToArray()
        for items in array {
            let item = items as? [String: Any]
            if (letterList == [""]){
                letterList = [(item!["name"] as? String)!]
            } else {
                letterList.append((item!["name"] as? String)!)
            }
        }
    }
    
    func setActiveLetter(){
        var nameKey = String()
        for names in letterList {
            if(UserDefaults.standard.bool(forKey: "\(names)Active") == true){
                nameKey = names
            }
        }
        let array = getJsonToArray()
        for items in array {
            let itemDict = items as? [String: Any]
            if(itemDict!["name"] as? String == nameKey){
                textureName = (itemDict!["name"] as? String)!
                text0 = (itemDict!["text0"] as? String)!
                text1 = (itemDict!["text1"] as? String)!
                text2 = (itemDict!["text2"] as? String)!
                text3 = (itemDict!["text3"] as? String)!
            }
        }
    }
    
    func getJsonToArray() -> [Any]{
        do {
            if let file = Bundle.main.url(forResource: "ShopList", withExtension: "JSON") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let array = json as? [Any] {
                    return array
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return [Any]()
    }
}
