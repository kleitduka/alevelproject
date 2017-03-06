//
//  SettingsMenuScene.swift
//  MilkyWayTest
//
//  Created by Kleit Duka on 29/11/2016.
//  Copyright © 2016 Kleit Duka. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsMenuScene: SKScene{
    
    let musicSwitchLabel = SKLabelNode(fontNamed: "The Bold Font")
  //  let tiltMode = SKLabelNode(fontNamed: "The Bold Font")
  //  let touchMode = SKLabelNode(fontNamed: "The Bold Font")
    let theme1 = SKLabelNode(fontNamed: "The Bold Font")
    let theme2 = SKLabelNode(fontNamed: "The Bold Font")
    let theme3 = SKLabelNode(fontNamed: "The Bold Font")
    let colorTrail = "ShipTrail"

    override func didMove(to view: SKView) {
        
    /*    let background = SKSpriteNode(imageNamed: "blackBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
      */
        
        let shapeBackground = SKSpriteNode(imageNamed: "SettingsBackground")
        shapeBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        shapeBackground.zPosition = 0
        
        //addChild(background)
        self.addChild(SKEmitterNode(fileNamed: "MenusBackground")!)
        addChild(shapeBackground)
        
        let settingsLabel = SKLabelNode(fontNamed: "The Bold Font")
        settingsLabel.text = "Settings"
        settingsLabel.fontSize = 120
        settingsLabel.fontColor = customColor1
        settingsLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.79)
        settingsLabel.zPosition = 2
        self.addChild(settingsLabel)
        
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.fontSize = 90
        mainMenuLabel.fontColor = brushedGold
        mainMenuLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.18)
        mainMenuLabel.zPosition = 1
        self.addChild(mainMenuLabel)

        musicSwitchLabel.text = "Music: On / Off"
        musicSwitchLabel.fontSize = 80
        musicSwitchLabel.fontColor = customColor1
        musicSwitchLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.59)
        musicSwitchLabel.zPosition = 2
        self.addChild(musicSwitchLabel)
        
        theme1.text = "Theme 1"
        theme1.fontSize = 80
        theme1.fontColor = customColor1
        theme1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.49)
        theme1.zPosition = 2
        self.addChild(theme1)
        
        theme2.text = "Theme 2"
        theme2.fontSize = 80
        theme2.fontColor = customColor1
        theme2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.39)
        theme2.zPosition = 2
        self.addChild(theme2)
        
        theme3.text = "Theme 3"
        theme3.fontSize = 80
        theme3.fontColor = customColor1
        theme3.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.29)
        theme3.zPosition = 2
        self.addChild(theme3)
        
        }
 
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if mainMenuLabel.contains(pointOfTouch){
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if theme1.contains(pointOfTouch){
                background.texture = SKTexture(imageNamed: "blackBackground")
                player.texture = SKTexture(imageNamed: "playerShipRed")
            }
            
            if theme2.contains(pointOfTouch){
                background.texture = SKTexture(imageNamed: "redBackground")
                player.texture = SKTexture(imageNamed: "playerShipBlue")
            }
            
            if theme3.contains(pointOfTouch){
                background.texture = SKTexture(imageNamed: "blueBackground")
                player.texture = SKTexture(imageNamed: "playerShipYellow")
                
            }
 
/*            if musicSwitchLabel.contains(pointOfTouch){
                if audioPlayer.isPlaying {
                    audioPlayer.stop()
                } else {
                    audioPlayer.play()
                }
            }
*/
        }
    }
}
