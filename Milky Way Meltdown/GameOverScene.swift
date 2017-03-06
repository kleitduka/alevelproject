//
//  GameOverScene.swift
//  Milky Way Meltdown
//
//  Created by Kleit Duka on 17/11/2016.
//  Copyright © 2016 Kleit Duka. All rights reserved.
//

import Foundation
import SpriteKit


    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    let mainMenuLabel = SKLabelNode(fontNamed: "The Bold Font")


class GameOverScene: SKScene{
    
    
    override func didMove(to view: SKView) {
        
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
      /*  let background = SKSpriteNode(imageNamed: "blackBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
      */
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

        //Positioning the background on screen
        let background = SKSpriteNode(imageNamed: "GameOverBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
        self.addChild(SKEmitterNode(fileNamed: "MenusBackground")!)

        //Positioning the game over label on screen
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 140
        gameOverLabel.fontColor = customColor1
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        gameOverLabel.zPosition = 2
        self.addChild(gameOverLabel)
        
        //Positioning the score label on screen
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = customColor1
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreNumber")
      
        if gameScore > highScoreNumber{
        highScoreNumber = gameScore
        defaults.set(highScoreNumber, forKey: "highScoreNumber")
            
    }
        
        //Positioning the high score label on screen
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 100
        highScoreLabel.fontColor = customColor1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.50)
        highScoreLabel.zPosition = 2
        self.addChild(highScoreLabel)
 
        //Positioning the restart button on screen
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = brushedGold
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.25)
        restartLabel.zPosition = 2
        self.addChild(restartLabel)

        //Positioning the main menu button on screen
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.fontSize = 90
        mainMenuLabel.fontColor = brushedGold
        mainMenuLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.18)
        mainMenuLabel.zPosition = 2
        self.addChild(mainMenuLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            //When screen is tapped at the location of the restart button, the game restarts
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            //When screen is tapped at the location of the main menu button, the menu takes you to the main menu
            if mainMenuLabel.contains(pointOfTouch){
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    } 
    
    
}
