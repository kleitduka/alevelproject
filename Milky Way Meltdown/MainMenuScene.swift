//
//  MainMenuScene.swift
//  Milky Way Meltdown
//
//  Created by Kleit Duka on 17/11/2016.
//  Copyright © 2016 Kleit Duka. All rights reserved.
//

import Foundation
import SpriteKit

let brushedGold = UIColor(red:0.92, green:0.82, blue:0.48, alpha:1.0)
let customColor1 = UIColor(red:1.00, green:0.45, blue:0.36, alpha:1.0)
let darkTurquoise = UIColor(red:0.52, green:0.89, blue:0.87, alpha:1.0)

class MainMenuScene: SKScene{
    
    override func didMove(to view: SKView) {

        let background = SKSpriteNode(imageNamed: "startBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameBy = SKLabelNode(fontNamed: "blowBrush")
        gameBy.text = "Created By: Kleit Duka"
        gameBy.fontSize = 40
        gameBy.fontColor = brushedGold
        //gameBy.position = CGPoint(x: self.size.width*0.73, y: self.size.height*0.81)
        gameBy.position = CGPoint(x: self.size.width*0.74, y: self.size.height*0.94)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        let gameNamel = SKLabelNode(fontNamed: "blowBrush")
        gameNamel.text = "Milky Way"
        gameNamel.fontSize = 260
        gameNamel.fontColor = brushedGold
        gameNamel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85)
        gameNamel.zPosition = 1
        self.addChild(gameNamel)
    
        let gameName2 = SKLabelNode(fontNamed: "blowBrush")
        gameName2.text = "Meltdown"
        gameName2.fontSize = 260
        gameName2.fontColor = brushedGold
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        let startGame = SKLabelNode(fontNamed: "theBoldFont")
        startGame.text = "Start Game"
        startGame.fontSize = 110
        startGame.fontColor = brushedGold
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.42) //0.37
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
        let instructionsMenu = SKLabelNode(fontNamed: "theBoldFont")
        instructionsMenu.text = "Instructions"
        instructionsMenu.fontSize = 110
        instructionsMenu.fontColor = brushedGold
        instructionsMenu.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.35) //0.27
        instructionsMenu.zPosition = 1
        instructionsMenu.name = "instructionsButton"
        self.addChild(instructionsMenu)
        
        let settingsMenu = SKLabelNode(fontNamed: "theBoldFont")
        settingsMenu.text = "Settings"
        settingsMenu.fontSize = 110
        settingsMenu.fontColor = brushedGold
        settingsMenu.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.28)
        settingsMenu.zPosition = 1
        settingsMenu.name = "settingsButton"
        self.addChild(settingsMenu)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
        

        if nodeITapped.name == "startButton"{
            let sceneToMoveTo = GameScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
        if nodeITapped.name == "instructionsButton"{
            let sceneToMoveTo = InstructionsMenuScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
        if nodeITapped.name == "settingsButton"{
            let sceneToMoveTo = SettingsMenuScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
