//
//  GameScene.swift
//  Milky Way Meltdown
//
//  Created by Kleit Duka on 14/11/2016.
//  Copyright © 2016 Kleit Duka. All rights reserved.
//

import CoreMotion
import AVFoundation
import SpriteKit

    //Declaring global variables
    var motionManager: CMMotionManager!
    var gameScore = 0
    let backgroundMusic = NSURL(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic", ofType: "m4a")!)
    let audioPlayer = try! AVAudioPlayer(contentsOf: backgroundMusic as URL)

    let bulletEffect = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bulletEffect", ofType: "wav")!)
    let bulletEffectPlayer = try! AVAudioPlayer(contentsOf: bulletEffect as URL)

    var player = SKSpriteNode(imageNamed: "playerShipRed")
    let background = SKSpriteNode(imageNamed: "blackBackground")

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    //Setting the enumeration cases
    enum gameState {
        case preGame   //game state before the game
        case inGame    //game state during the game
        case afterGame //game state when the game has finished
    }
    
    //Declaring variables
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    var livesNumber = 5
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    var levelNumber = 0
    let tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")
    let newLevelLabel = SKLabelNode(fontNamed: "The Bold Font")
    var currentGameState = gameState.preGame
    
    //Defining the new structures
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1
        static let Bullet : UInt32 = 0b10
        static let Enemy : UInt32 = 0b100
    }
    
    // ??????
    func random() -> CGFloat{
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    func random(min:CGFloat, max:CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
   
    //Setting the area of which the game is allowed to be played
    var gameArea: CGRect
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    //Creating a function to tell the program what to do when the game is started
    func startGame(){
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let waitToStart = SKAction.wait(forDuration: 0.5)
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction, waitToStart])
        tapToStartLabel.run(deleteSequence)
        
        //The background music starts to play for an infinte number of times
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.run(startGameSequence)
    }
    
    
    
    
    //Creating a function to generate the enemies
    func generateEnemies() {
        let randomXStart = random(min: gameArea.minX * 1.1, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX * 1.1, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShipGreen")
        enemy.name = "Enemy"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody (rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2.0)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
    }
    
    
    
    
    //Creating a function to start to get the accelerometer updates
    func addMotionManager() {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()
    }
    
    //Creating a function to convert accelerometer data into gravity for the player ship
    func accelerometer(){
    if let accelerometerData = motionManager.accelerometerData {
        
        //Checks to see if the device is tilted and generates gravity on the x-axis only
        physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 25, dy: 0)
        }
        
        //These if statements don't let the player's ship move outside the screen
        if player.position.x > gameArea.maxX - player.size.width/2{
            player.position.x = (gameArea.maxX - player.size.width/2)
        }
        if player.position.x < gameArea.minX + player.size.width/2{
            player.position.x = (gameArea.minX + player.size.width/2)
        }
        
    }
    
    //Making the device constantly get data from the accelerometer
    override func update(_ currentTime: TimeInterval) {
        accelerometer()
    }
    
    
    
    
    //Creating a function to create bullets
    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bulletRed")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody (rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        
        bulletEffectPlayer.play()
        
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet,deleteBullet])
        bullet.run(bulletSequence)
    }
    
    
    
    
    //Creating a function to add the score whenever an enemy is shot
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        //Making a new level start whenever the score has reached the required number as below
        if gameScore == 15 || gameScore == 25 || gameScore == 50 || gameScore == 80 || gameScore == 150 || gameScore == 200{
            startNewLevel()
        }
    }
    
    
    
    
    //Creating a function to decrease the life by one
    func loseALife(){
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)

        if livesNumber == 0 {
            runGameOver()
        }
    }
    

    
    
    //Creating a function to start a new level whenever needed
    func startNewLevel(){
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
 /*       var levelDuration = TimeInterval()
        switch levelNumber {
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1.0
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        case 5: levelDuration = 0.2
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
    */////////////
        //////////
        //////////
        //////////
        
        
        //Positioning the 'new level' label on screen
        newLevelLabel.text = "Level \(levelNumber)"
        newLevelLabel.fontSize = 150
        newLevelLabel.fontColor = brushedGold
        newLevelLabel.zPosition = 1
        newLevelLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        newLevelLabel.alpha = 1
        self.addChild(newLevelLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 1)
        newLevelLabel.run(fadeInAction)
        let fadeOutAction = SKAction.fadeOut(withDuration: 1)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        newLevelLabel.run(deleteSequence)
        
        //////////////////////////////////
        //////////////////////////////////
        //////////////////////////////////
        /////  TEST WITHOUT ENEMIES   ////
        /////         |               ////
        /////         |               ////
        /////         |               ////
        /////        \  /             ////
        /////         \/              ////
        //////////////////////////////////
        //////////////////////////////////

        //Spawning enemies whenever a new level starts
        let spawn = SKAction.run(generateEnemies)
        let waitToSpawn = SKAction.wait(forDuration: 3)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }

    
    
    //Creating a function to show the game over menu
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    //Creating a function to remove everything from the screen when game over
    func runGameOver(){
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
      
        if #available(iOS 10.0, *) {
            audioPlayer.setVolume(0, fadeDuration: 1)
        } else {
            audioPlayer.stop()
        }
        
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeFromParent()
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1.5)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    
    
    
    //Creating a function to generate explosion when bullet hits enemy
    func explosion(pos: CGPoint) {
        let emitterNode = SKEmitterNode(fileNamed: "Explosion")
        emitterNode?.particlePosition = pos
        self.addChild(emitterNode!)
        self.run(SKAction.wait(forDuration: 2), completion: { emitterNode?.removeFromParent() })
        
    }
    
    //Creating a function to generate explosion when player hits enemy
    func bigExplosion(pos: CGPoint) {
        let emitterNode = SKEmitterNode(fileNamed: "BigExplosion")
        emitterNode?.particlePosition = pos
        self.addChild(emitterNode!)
        self.run(SKAction.wait(forDuration: 5), completion: { emitterNode?.removeFromParent() })
        
        let fadeIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 4)
        let delete = SKAction.removeFromParent()
        let bigExplosionSequence = SKAction.sequence([fadeIn, fadeOut, delete])
        emitterNode?.run(bigExplosionSequence)
    }
    
    //Creating a function to show the label when you lose
    func invadedLabel(){
        let invadedLabel = SKLabelNode(fontNamed: "blowBrush")
        invadedLabel.text = "You've Been"
        invadedLabel.fontSize = 210
        invadedLabel.fontColor = darkTurquoise
        invadedLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.55)
        invadedLabel.zPosition = 1
        self.addChild(invadedLabel)
        
        let invadedLabel1 = SKLabelNode(fontNamed: "blowBrush")
        invadedLabel1.text = "INVADED"
        invadedLabel1.fontSize = 240
        invadedLabel1.fontColor = darkTurquoise
        invadedLabel1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.45)
        invadedLabel1.zPosition = 1
        self.addChild(invadedLabel1)
    }
    
    
    
    
    //Creating a function to detect whether a bullet or the player hits the enemy, and run game over when needed
    func didBegin(_ contact: SKPhysicsContact){
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask  < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        //Tell the program what to do if player hits enemy
         if body1.categoryBitMask == PhysicsCategories.Player  && body2.categoryBitMask == PhysicsCategories.Enemy{
            
            if body1.node != nil{
                bigExplosion(pos: body1.node!.position)
                invadedLabel()
            }
    
            if body2.node != nil{
                bigExplosion(pos: body2.node!.position)
                invadedLabel()
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            runGameOver()
        }
        
        //Tell the program what to do if bullet hits enemy
        if body1.categoryBitMask == PhysicsCategories.Bullet  && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            
            addScore()
            
            if body2.node != nil{
                explosion(pos: body1.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
    
        /*                 ENEMY & SHIP COLLISION -- EXPLOSION FROM IMAGE
    func bigExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
    }
        */
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
    
    
    override func didMove(to view: SKView) {
        addMotionManager()
        self.physicsWorld.contactDelegate = self
        
        
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

        /*                ORIGINAL BACKGROUND SLIDE THROUGH SCREEN
         for i in 0...1{
         let background = SKSpriteNode(imageNamed: "background")
         background.size = self.size
         background.anchorPoint = CGPoint(x: 0.5, y: 0)
         background.position = CGPoint(x: self.size.width/2,
         y: self.size.height*CGFloat(i))
         background.zPosition = 0
         background.name = "Background"
         self.addChild(background)
         }
         */
        
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

        //Positioning the background on screen
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(0))
        background.zPosition = 0
        background.name = "blackBackground"
        self.addChild(background)
        self.addChild(SKEmitterNode(fileNamed: "MovingStars")!)
        
        
        //Positioning the player on screen
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: 0 - self.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody (rectangleOf: player.size)
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        
        //Adding a trail to follow the ship
        var sparkEmmitter:SKEmitterNode!
        func addTrail(){
            let sparkEmmitterPath = Bundle.main.path(forResource: "ShipTrail", ofType: "sks")!
            sparkEmmitter = NSKeyedUnarchiver.unarchiveObject(withFile: sparkEmmitterPath) as! SKEmitterNode
            sparkEmmitter.position = CGPoint(x: 6, y: -97)
            sparkEmmitter.name = "Trail"
            sparkEmmitter.zPosition = 22.0
            sparkEmmitter.targetNode = self.scene
            player.addChild(sparkEmmitter)
        }
        addTrail()
        
        //Positioning the score label on screen
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        
        //Positioning the pause button on screen
        let pauseButton = SKLabelNode(fontNamed: "The Bold Font")
        pauseButton.text = "Pause"
        pauseButton.fontSize = 50
        pauseButton.fontColor = SKColor.white
        pauseButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        pauseButton.position = CGPoint(x: self.size.width*0.55, y: self.size.height + pauseButton.frame.size.height)
        pauseButton.zPosition = 1
        pauseButton.name = "pauseButton"
        self.addChild(pauseButton)
        
        
        //Positioning the lives label on screen
        livesLabel.text = "Lives: 5"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        
        //Creating the fade in transition of the labels
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        pauseButton.run(moveOnToScreenAction)
        
        
        //Positioning the 'tap to start' label on screen
        tapToStartLabel.text = "Tap To Start"
        tapToStartLabel.fontSize = 150
        tapToStartLabel.fontColor = brushedGold
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 1
        self.addChild(tapToStartLabel)
        
        
        //Creating the fade in transition of tap to start
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
    }

    
    
    
    //Telling the program what happens when user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //If user touches screen when game hasn't started, then run the startGame function
        if currentGameState == gameState.preGame{
            startGame()
            gameScore = 0
        }
        //If user touches screen when game has started, then run the fireBullet function
        else if currentGameState == gameState.inGame{
            fireBullet()
        }
    
    
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            //If user touches screen where the pause button is positioned, then show the pause menu
            if nodeITapped.name == "pauseButton"{
                let sceneToMoveTo = PauseMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }
            }
    }
    
    
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

  //                          MOVE PLAYER TOUCHING THE SCREEN
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame{
            player.position.x += amountDragged
            }
            
            if player.position.x > gameArea.maxX - player.size.width/2{
                player.position.x = (gameArea.maxX - player.size.width/2)
            }
            
            
            
            if player.position.x < gameArea.minX + player.size.width/2{
                player.position.x = (gameArea.minX + player.size.width/2)
            }
            
        
                }
        }
 
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
 
    
}





