//
//  InstructionsMenuScene.swift
//  MilkyWayTest
//
//  Created by Kleit Duka on 15/12/2016.
//  Copyright © 2016 Kleit Duka. All rights reserved.
//

import Foundation
import SpriteKit

class InstructionsMenuScene: SKScene{
    
    let playGame = SKLabelNode(fontNamed: "theBoldFont")
    
    override func didMove(to view: SKView) {
        
        let shapeBackground = SKSpriteNode(imageNamed: "InstructionsBackground")
        shapeBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        shapeBackground.zPosition = 0
        self.addChild(SKEmitterNode(fileNamed: "MenusBackground")!)
        addChild(shapeBackground)
        
        let instructionsLabel = SKLabelNode(fontNamed: "The Bold Font")
        instructionsLabel.text = "Instructions"
        instructionsLabel.fontSize = 100
        instructionsLabel.fontColor = customColor1
        instructionsLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.79)
        instructionsLabel.zPosition = 2
        self.addChild(instructionsLabel)

        playGame.text = "Play"
        playGame.fontSize = 90
        playGame.fontColor = brushedGold
        playGame.position = CGPoint(x: self.size.width/2, y: self.size.height*0.24)
        playGame.zPosition = 1
        playGame.name = "startButton"
        self.addChild(playGame)

        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.fontSize = 90
        mainMenuLabel.fontColor = brushedGold
        mainMenuLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.18)
        mainMenuLabel.zPosition = 1
        self.addChild(mainMenuLabel)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if playGame.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if mainMenuLabel.contains(pointOfTouch){
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
