//
//  LetterOddsAndScores.swift
//  WordFallOOP
//
//  Created by Braden Ross on 3/31/20.
//  Copyright © 2020 Braden Ross. All rights reserved.
//

import Foundation

class LetterOddsAndScores {
    let onePoint = 1 //A E I O U
    let twoPoints = 2 //T N S H R
    let fourPoints = 4 //D L C M
    let fivePoints = 5 //F W Y G P
    let sixPoints = 6 //B V K
    let eightPoints = 8 //Q J X Z
    let one = ["A", "E", "I", "O", "U"]
    let two = ["T", "N", "S", "H", "R"]
    let three = ["D", "L", "C", "M"]
    let four = ["F", "W", "Y", "G", "P"]
    let five = ["B", "V", "K"]
    let six = ["Q", "J", "X", "Z"]
    
    func wordScore(word: String) -> Int{
        var totalWordScore = 0
        
        for letters in word {
            if (one.contains(String(letters))){
                totalWordScore += onePoint
            }
            else if (two.contains(String(letters))){
                totalWordScore += twoPoints
            }
            else if (three.contains(String(letters))){
                totalWordScore += fourPoints
            }
            else if (four.contains(String(letters))){
                totalWordScore += fivePoints
            }
            else if (five.contains(String(letters))){
                totalWordScore += sixPoints
            }
            else if (six.contains(String(letters))){
                totalWordScore += eightPoints
            }
        }
        
        totalWordScore = Int((totalWordScore * word.count) / 2)
        //score += totalWordScore
        print("Word Score: \(totalWordScore)")
        print("score \(score)")
        
        return totalWordScore
    }
    //FIX SCORES BEFORE SENDING OUT FOR PLAY
    
    
    //
    //
    //
    //
    //
    //FIX SCORES
    func lettersNeeded() -> Int{
        if(score < 100){
            return 2
        } else if (score >= 100 && score < 250){
            return 3
        } else if(score >= 250 && score < 400){
            return 4
        } else if(score >= 400 && score < 900){
            return 5
        } else if(score >= 900 && score < 1300){
            return 6
        } else if(score >= 1300 && score < 1800){
            return 7
        } else if(score >= 1800 && score < 2400){
            return 8
        } else if(score >= 2400 && score < 3000){
            return 9
        } else if(score >= 3000 && score < 3800){
            return 10
        } else if(score >= 3800 && score < 4600){
            return 11
        } else if(score >= 4600 && score < 5500){
            return 12
        } else if(score >= 5500 && score < 6400){
            return 13
        } else if(score >= 6400 && score < 5400){
            return 14
        } else if(score >= 5400 && score < 6500){
            return 15
        } else {
            return 16
        }
        
    }
    
    func letterOdds() -> Int{
        if(score >= 0 && score < 1000){
            return levelOne()
        } else if (score >= 1000 && score < 4500) {
            return levelTwo()
        } else {
            return levelThree() }
    }
    
    func levelOne() -> Int{
        var rndInt = Int.random(in: 65...100)
        
        if (rndInt > 90 && rndInt <= 92){
            rndInt = 65
        } else if (rndInt > 92 && rndInt <= 94){
            rndInt = 69
        } else if (rndInt > 94 && rndInt <= 96){
            rndInt = 73
        } else if (rndInt > 96 && rndInt <= 98){
            rndInt = 79
        } else if (rndInt > 98 && rndInt <= 100){
            rndInt = 85
        }
        return rndInt
    }
    
    func levelTwo() -> Int{
        var rndInt = Int.random(in: 65...95)
        
        if (rndInt > 90 && rndInt <= 91){
            rndInt = 65
        } else if (rndInt > 91 && rndInt <= 92){
            rndInt = 69
        } else if (rndInt > 92 && rndInt <= 93){
            rndInt = 73
        } else if (rndInt > 93 && rndInt <= 94){
            rndInt = 79
        } else if (rndInt > 94 && rndInt <= 95){
            rndInt = 85
        }
        return rndInt
    }
    
    func levelThree() -> Int{
        let rndInt = Int.random(in: 65...90)
        return rndInt
    }
}
