//
//  PauseMenuScene.swift
//  MilkyWayTest
//
//  Created by Kleit Duka on 29/11/2016.
//  Copyright © 2016 Kleit Duka. All rights reserved.
//

import Foundation
import SpriteKit

class PauseMenuScene: SKScene{
    
    override func didMove(to view: SKView) {
        
        let shapeBackground = SKSpriteNode(imageNamed: "PauseBackground")
        shapeBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        shapeBackground.zPosition = 0
        self.addChild(SKEmitterNode(fileNamed: "MovingStars")!)
        addChild(shapeBackground)
        
        let pauseLabel = SKLabelNode(fontNamed: "The Bold Font")
        pauseLabel.text = "Pause"
        pauseLabel.fontSize = 120
        pauseLabel.fontColor = customColor1
        pauseLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.79)
        pauseLabel.zPosition = 2
        self.addChild(pauseLabel)

        
        let continueGame = SKLabelNode(fontNamed: "theBoldFont")
        continueGame.text = "Continue"
        continueGame.fontSize = 150
        continueGame.fontColor = brushedGold
        continueGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.37)
        continueGame.zPosition = 1
        continueGame.name = "continueButton"
        self.addChild(continueGame)
        
        let goToSettingsLabel = SKLabelNode(fontNamed: "theBoldFont")
        goToSettingsLabel.text = "Settings"
        goToSettingsLabel.fontSize = 150
        goToSettingsLabel.fontColor = brushedGold
        goToSettingsLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.57)
        goToSettingsLabel.zPosition = 1
        goToSettingsLabel.name = "goToSettingsLabel"
        self.addChild(goToSettingsLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
           
            if nodeITapped.name == "continueButton"{
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if nodeITapped.name == "goToSettingsLabel"{
                let sceneToMoveTo = SettingsMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
    
    
}
