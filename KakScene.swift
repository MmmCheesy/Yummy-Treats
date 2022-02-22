//
//  GameScene.swift
//  Kids and Kreeps
//
//  Created by Alexander Eckert on 9/15/19.
//  Copyright © 2019 Alexander Eckert. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

struct PhysicsCatagory {
    static var monster : UInt32 = 0x1 >> 1
    static var kid : UInt32 = 0x1 >> 1
    static var trash : UInt32 = 0x1 >> 0
    static var ground : UInt32 = 0x1 >> 1
}
class KakScene: SKScene, SKPhysicsContactDelegate {
    
    //scene variables
    var bg = SKSpriteNode(imageNamed: "Bg1")
    var timer = Timer()
    var kidsAndKreeps = SKSpriteNode(imageNamed: "KidsKreeps")
    var volcano1 = SKSpriteNode(imageNamed: "Volcano1")
    var volcano2 = SKSpriteNode(imageNamed: "Volcano2")
    var lava = SKSpriteNode(imageNamed: "Lava")
    var tip1 = SKSpriteNode(imageNamed: "Tip1")
    var cloud1 = SKSpriteNode(imageNamed: "CloudOne")
    var cloud2 = SKSpriteNode(imageNamed: "CloudTwo")
    var ground = SKSpriteNode()
    var levOn = SKSpriteNode(imageNamed: "Lev1")
    var endbg = SKSpriteNode(imageNamed: "EndScreen")
    var goSign = SKSpriteNode(imageNamed: "Go")
    
    var audioPlayer : AVAudioPlayer = AVAudioPlayer()
    var audioPlayer2 : AVAudioPlayer = AVAudioPlayer()
    var audioPlayer3 : AVAudioPlayer = AVAudioPlayer()
    
    //scene booleans
    var levelStarted : Bool = false
    var openeingDone: Bool = false
    var combo : Bool = false
    
    //scene integers
    var garbageDelay : Int = 3 //time between debree spawns
    var garbageSpeed : Int = 8 //the lower the number, the faster the speed
    var garbageCount : Int = 8 //make one less than actual amount
    var level : Int = 0 //set with NSUserDefaults at start of every load
    var points : Int = -1
    
    //kids and monsters
    var kid = SKSpriteNode(imageNamed: "Kid1-1")
    var kidYum = SKSpriteNode()
    var kidYuk = SKSpriteNode()
    var monster = SKSpriteNode(imageNamed: "Monster1-1")
    var monsterYum = SKSpriteNode()
    var monsterYuk = SKSpriteNode()
    
    //food and trash variables
    var trash = SKSpriteNode(imageNamed: "Trash1")
    var food = SKSpriteNode(imageNamed: "Food1")
    
    //variables needed but are junk
    var object1 = SKSpriteNode()
    var object2 = SKSpriteNode()
    var object3 = SKSpriteNode()
    var object4 = SKSpriteNode()
    var count : Int = 0
    var sorted : Int = 0
    var touching1 : Bool = false
    var touching2 : Bool = false
    var touching3 : Bool = false
    var touching4 : Bool = false
    
    //Scoring Variables
    var currentScore : Int = 0
    var highScore : Int = 0
    var currentLbl = SKLabelNode(fontNamed: "American Typewriter")
    var highLbl = SKLabelNode(fontNamed: "American Typewriter")
    var scoreCone = SKSpriteNode(imageNamed: "IceCream1")
    var currentText = SKLabelNode(fontNamed: "American Typewriter")
    var highText = SKLabelNode(fontNamed: "American Typewriter")
    
    override func didMove(to view: SKView) {
        bg.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.addChild(bg)
        self.physicsWorld.contactDelegate = self
        tip1.size = CGSize(width: self.frame.width, height: self.frame.height)
        tip1.position = CGPoint(x: 0, y: self.frame.height / 25)
        self.addChild(tip1)
        kidsAndKreeps.size = CGSize(width: self.frame.width * 0.9, height: self.frame.height / 2.8)
        kidsAndKreeps.position = CGPoint(x: 0, y: 0)
        kidsAndKreeps.zPosition = 10
        self.addChild(kidsAndKreeps)
        cloud1.size = CGSize(width: self.frame.width, height: self.frame.height)
        cloud2.size = CGSize(width: self.frame.width, height: self.frame.height)
        levOn.size = CGSize(width: 1, height: 1)
        levOn.position = CGPoint(x: 0, y: 0)
        
        let defaults = UserDefaults.standard
        if defaults.integer(forKey: "lev") == 0 {
            defaults.set(1, forKey: "lev")
        }
        level = defaults.integer(forKey: "lev")
        
        volcano1.size = CGSize(width: self.frame.height / 2.5, height: self.frame.height / 3)
        volcano1.position = CGPoint(x: (self.frame.width / 2) - (self.frame.height / 5), y: (self.frame.height / 2) - (self.frame.height / 6))
        if level == 1 {
            self.addChild(volcano1)
        }
        
        volcano2.size = CGSize(width: self.frame.height / 2.5, height: self.frame.height / 3)
        volcano2.position = CGPoint(x: (self.frame.width / 2) - (self.frame.height / 5), y: (self.frame.height / 2) - (self.frame.height / 6))
        
        lava.size = CGSize(width: self.frame.height / 2.5, height: self.frame.height / 3)
        lava.position = CGPoint(x: (self.frame.width / 2) - (self.frame.height / 5), y: (self.frame.height / 2) - (self.frame.height / 6))
        
        
        kid.size = CGSize(width: self.frame.height / 2, height: self.frame.height / 2)
        kid.position = CGPoint(x: self.frame.height / 2.3, y: (self.frame.height / -2) + (self.frame.height / 3.8))
        kid.isUserInteractionEnabled = false
        kid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 4, height: self.frame.height / 3))
        kid.physicsBody?.usesPreciseCollisionDetection = true
        kid.physicsBody?.categoryBitMask = PhysicsCatagory.kid
        kid.physicsBody?.collisionBitMask = PhysicsCatagory.trash
        kid.physicsBody?.contactTestBitMask = PhysicsCatagory.trash
        kid.physicsBody?.affectedByGravity = false
        kid.physicsBody?.isDynamic = false
        kid.name = "kid"
        self.addChild(kid)
        
        monster.size = CGSize(width: self.frame.height / 2, height: self.frame.height / 2)
        monster.position = CGPoint(x: self.frame.height / -2.3, y: (self.frame.height / -2) + (self.frame.height / 3.8))
        monster.isUserInteractionEnabled = false
        monster.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 3, height: self.frame.height / 3))
        monster.physicsBody?.usesPreciseCollisionDetection = true
        monster.physicsBody?.categoryBitMask = PhysicsCatagory.monster
        monster.physicsBody?.collisionBitMask = PhysicsCatagory.trash
        monster.physicsBody?.contactTestBitMask = PhysicsCatagory.trash
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.isDynamic = false
        monster.name = "monster"
        self.addChild(monster)
        
        kidYum = SKSpriteNode(imageNamed: "Kid\(level)-2")
        kidYum.position = kid.position
        kidYum.size = kid.size
        kidYum.isHidden = true
        self.addChild(kidYum)
        kidYuk = SKSpriteNode(imageNamed: "Kid\(level)-3")
        kidYuk.position = kid.position
        kidYuk.size = kid.size
        kidYuk.isHidden = true
        self.addChild(kidYuk)
        
        monsterYum = SKSpriteNode(imageNamed: "Monster\(level)-2")
        monsterYum.position = monster.position
        monsterYum.size = monster.size
        monsterYum.isHidden = true
        self.addChild(monsterYum)
        monsterYuk = SKSpriteNode(imageNamed: "Monster\(level)-3")
        monsterYuk.position = monster.position
        monsterYuk.size = monster.size
        monsterYuk.isHidden = true
        self.addChild(monsterYuk)
        
        trash.size = CGSize(width: self.frame.height / 5, height: self.frame.height / 5)
        trash.position = CGPoint(x: self.frame.height / -2.3, y: (self.frame.height / 2) + ((self.frame.height - ((self.frame.height / 4) + (self.frame.height / 6))) / 2) + (self.frame.height / 10))
        trash.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 6, height: self.frame.height / 6))
        trash.physicsBody?.usesPreciseCollisionDetection = true
        trash.physicsBody?.categoryBitMask = PhysicsCatagory.trash
        trash.physicsBody?.collisionBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
        trash.physicsBody?.contactTestBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
        trash.physicsBody?.affectedByGravity = false
        trash.name = "trash"
        self.addChild(trash)
        
        food.size = CGSize(width: self.frame.height / 5, height: self.frame.height / 5)
        food.position = CGPoint(x: self.frame.height / 2.3, y: (self.frame.height / 2) + (self.frame.height / 10))
        food.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 6, height: self.frame.height / 6))
        food.physicsBody?.usesPreciseCollisionDetection = true
        food.physicsBody?.categoryBitMask = PhysicsCatagory.trash
        food.physicsBody?.collisionBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
        food.physicsBody?.contactTestBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
        food.physicsBody?.affectedByGravity = false
        food.name = "food"
        self.addChild(food)
        
        ground.size = CGSize(width: self.frame.width * 2, height: self.frame.height / 10)
        ground.position = CGPoint(x: 0, y: (self.frame.height / -2) - (self.frame.height / 10))
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 5, height: self.frame.height / 5))
        ground.physicsBody?.usesPreciseCollisionDetection = true
        ground.physicsBody?.categoryBitMask = PhysicsCatagory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCatagory.trash
        ground.physicsBody?.contactTestBitMask = PhysicsCatagory.trash
        ground.physicsBody?.affectedByGravity = false
        ground.name = "ground"
        self.addChild(ground)
        
        goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
        goSign.position = CGPoint(x: 0, y: 0)
        goSign.isHidden = true
        
        animation(anim: level)
        
        highScore = defaults.integer(forKey: "high")
        currentScore = defaults.integer(forKey: "current")
        
        highLbl.text = "\(highScore)"
        highLbl.fontSize = CGFloat(self.frame.height / 12)
        highLbl.fontColor = UIColor.orange
        highLbl.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 3.2)
        
        currentLbl.text = "\(currentScore)"
        currentLbl.fontSize = CGFloat(self.frame.height / 12)
        currentLbl.fontColor = UIColor.orange
        currentLbl.position = CGPoint(x: self.frame.width / -4, y: self.frame.height / 3.2)
        
        highText.text = "High Score"
        highText.fontSize = CGFloat(self.frame.height / 15)
        highText.fontColor = UIColor.orange
        highText.position = CGPoint(x: self.frame.width / 4, y: (self.frame.height / 2) - (self.frame.height / 9))
        
        currentText.text = "Score"
        currentText.fontSize = CGFloat(self.frame.height / 15)
        currentText.fontColor = UIColor.orange
        currentText.position = CGPoint(x: self.frame.width / -4, y: (self.frame.height / 2) - (self.frame.height / 9))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.node as! SKSpriteNode
        let secondBody = contact.bodyB.node as! SKSpriteNode
        
        if (((firstBody.name == "kid") && (secondBody.name == "food")) || ((firstBody.name == "food") && (secondBody.name == "kid"))) {
            food.removeFromParent()
            food.removeAllActions()
            if levelStarted == false {
                food = SKSpriteNode(imageNamed: "Food2")
                food.size = CGSize(width: self.frame.height / 5, height: self.frame.height / 5)
                food.position = CGPoint(x: self.frame.height / 2.3, y: (self.frame.height / 2) + (self.frame.height / 10))
                food.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 6, height: self.frame.height / 6))
                food.physicsBody?.usesPreciseCollisionDetection = true
                food.physicsBody?.categoryBitMask = PhysicsCatagory.trash
                food.physicsBody?.collisionBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
                food.physicsBody?.contactTestBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
                food.physicsBody?.affectedByGravity = false
                food.name = "food"
                self.addChild(food)
                let fall = SKAction.moveBy(x: 0, y: -self.frame.height * 2, duration: 12)
                food.run(fall)
            } else {
                sorted += 1
                kidYum.isHidden = false
                score(good: true)
                if secondBody.name == "food" {
                    secondBody.removeFromParent()
                } else {
                    firstBody.removeFromParent()
                }
                //sound when kid eats food
                var ran1 = CGFloat.random(in: 1...5)
                ran1.round(FloatingPointRoundingRule.toNearestOrAwayFromZero)
                let ran : Int = Int(ran1)
                let path = Bundle.main.path(forResource: "kidgood\(ran)", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            }
        }
        
        if (((firstBody.name == "kid") && (secondBody.name == "trash")) || ((firstBody.name == "trash") && (secondBody.name == "kid"))) {
            sorted += 1
            kidYuk.isHidden = false
            score(good: false)
            if secondBody.name == "trash" {
                secondBody.removeFromParent()
            } else {
                firstBody.removeFromParent()
            }
            //sound when kid eats trash
            var ran1 = CGFloat.random(in: 1...5)
            ran1.round(FloatingPointRoundingRule.toNearestOrAwayFromZero)
            let ran : Int = Int(ran1)
            let path = Bundle.main.path(forResource: "kidbad\(ran)", ofType: "mp3")
            let soundUrl = URL(fileURLWithPath: path!)
            do {
                try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                self.audioPlayer.volume = 1
                self.audioPlayer.numberOfLoops = 0
                self.audioPlayer.play()
            }catch {print(error)}
        }
        
        if (((firstBody.name == "monster") && (secondBody.name == "trash")) || ((firstBody.name == "trash") && (secondBody.name == "monster"))) {
            trash.removeFromParent()
            trash.removeAllActions()
            if levelStarted == false {
                trash = SKSpriteNode(imageNamed: "Trash2")
                trash.size = CGSize(width: self.frame.height / 5, height: self.frame.height / 5)
                trash.position = CGPoint(x: self.frame.height / -2.3, y: (self.frame.height / 2) + (self.frame.height / 10))
                trash.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 6, height: self.frame.height / 6))
                trash.physicsBody?.usesPreciseCollisionDetection = true
                trash.physicsBody?.categoryBitMask = PhysicsCatagory.trash
                trash.physicsBody?.collisionBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
                trash.physicsBody?.contactTestBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
                trash.physicsBody?.affectedByGravity = false
                trash.name = "trash"
                self.addChild(trash)
                let fall = SKAction.moveBy(x: 0, y: -self.frame.height * 2, duration: 12)
                trash.run(fall)
            } else {
                score(good: true)
                sorted += 1
                monsterYum.isHidden = false
                if secondBody.name == "trash" {
                    secondBody.removeFromParent()
                } else {
                    firstBody.removeFromParent()
                }
                //sound when monster eats trash
                var ran1 = CGFloat.random(in: 1...5)
                ran1.round(FloatingPointRoundingRule.toNearestOrAwayFromZero)
                let ran : Int = Int(ran1)
                let path = Bundle.main.path(forResource: "monstergood\(ran)", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            }
        }
        
        if (((firstBody.name == "monster") && (secondBody.name == "food")) || ((firstBody.name == "food") && (secondBody.name == "monster"))) {
            sorted += 1
            monsterYuk.isHidden = false
            score(good: false)
            if secondBody.name == "food" {
                secondBody.removeFromParent()
            } else {
                firstBody.removeFromParent()
            }
            //sound when monster eats food
            var ran1 = CGFloat.random(in: 1...4)
            ran1.round(FloatingPointRoundingRule.toNearestOrAwayFromZero)
            let ran : Int = Int(ran1)
            let path = Bundle.main.path(forResource: "monsterbad\(ran)", ofType: "mp3")
            let soundUrl = URL(fileURLWithPath: path!)
            do {
                try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                self.audioPlayer.volume = 1
                self.audioPlayer.numberOfLoops = 0
                self.audioPlayer.play()
            }catch {print(error)}
        }
        if (((firstBody.name == "ground") && (secondBody.name == "food")) || ((firstBody.name == "food") && (secondBody.name == "ground"))) {
            sorted += 1
            score(good: false)
            if secondBody.name == "food" {
                secondBody.removeFromParent()
            } else {
                firstBody.removeFromParent()
            }
        }
        if (((firstBody.name == "ground") && (secondBody.name == "trash")) || ((firstBody.name == "trash") && (secondBody.name == "ground"))) {
            sorted += 1
            score(good: false)
            if secondBody.name == "trash" {
                secondBody.removeFromParent()
            } else {
                firstBody.removeFromParent()
            }
        }
        
        if sorted - 1 == garbageCount {
            let defaults = UserDefaults.standard
            if level == 5 {
                defaults.set(1, forKey: "lev")
            } else {
                defaults.set(level + 1, forKey: "lev")
            }
            level = defaults.integer(forKey: "lev")
            animation(anim: level)
            sorted = 0
            count = 0
        }
    }
    
    func startLevel(lev: Int){
        count = 0
        points = 0
        if lev != 1 {
            tip1.removeFromParent()
        }
        self.highLbl.removeFromParent()
        self.currentLbl.removeFromParent()
        self.highText.removeFromParent()
        self.currentText.removeFromParent()
        audioPlayer.stop()
        monster.removeAllActions()
        object1.removeFromParent()
        object2.removeFromParent()
        object3.removeFromParent()
        object4.removeFromParent()
        if lev == 1 {
            volcanoErupt()
            levelStarted = true
            garbageDelay = 4
            garbageSpeed = 8
            garbageCount = 6
            food.removeFromParent()
            trash.removeFromParent()
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            goSign.removeFromParent()
            let defaults = UserDefaults.standard
            defaults.set(0, forKey: "current")
        } else if lev == 2 {
            levelStarted = true
            food.removeFromParent()
            trash.removeFromParent()
            garbageDelay = 4
            garbageSpeed = 6
            garbageCount = 10
            garbageTimer()
            foodFall()
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            goSign.removeFromParent()
        } else if lev == 3 {
            levelStarted = true
            food.removeFromParent()
            trash.removeFromParent()
            garbageDelay = 2
            garbageSpeed = 14
            garbageCount = 15
            garbageTimer()
            foodFall()
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            goSign.removeFromParent()
        } else if lev == 4 {
            levelStarted = true
            food.removeFromParent()
            trash.removeFromParent()
            garbageDelay = 3
            garbageSpeed = 4
            garbageCount = 12
            garbageTimer()
            foodFall()
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            goSign.removeFromParent()
        } else if lev == 5 {
            levelStarted = true
            food.removeFromParent()
            trash.removeFromParent()
            garbageDelay = 2
            garbageSpeed = 16
            garbageCount = 20
            garbageTimer()
            foodFall()
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            goSign.removeFromParent()
        }
    }
    
    func score(good: Bool) {
        if good == true {
            points += 1
            if combo == true {
                points += 1
            } else {
                combo = true
            }
        } else {
            combo = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.kidYum.isHidden = true
            self.kidYuk.isHidden = true
            self.monsterYum.isHidden = true
            self.monsterYuk.isHidden = true
        })
    }
    
    func showScore() {
        var lint = 0
        let total: Double = (2*Double(garbageCount))+1
        let scored: Double = (Double(points)/total)*5
        print("\(points)")
        print("\(total)")
        print("\(scored)")
        var interjection = SKSpriteNode(imageNamed: "Interjection1")
        if scored >= 1 { lint = 1 } else { lint = 2 }
        let cream1 = SKSpriteNode(imageNamed: "IceCream\(lint)")
        if scored >= 2 { lint = 1; interjection = SKSpriteNode(imageNamed: "Interjection2") } else { lint = 2 }
        let cream2 = SKSpriteNode(imageNamed: "IceCream\(lint)")
        if scored >= 3 { lint = 1; interjection = SKSpriteNode(imageNamed: "Interjection3") } else { lint = 2 }
        let cream3 = SKSpriteNode(imageNamed: "IceCream\(lint)")
        if scored >= 4 { lint = 1; interjection = SKSpriteNode(imageNamed: "Interjection4") } else { lint = 2 }
        let cream4 = SKSpriteNode(imageNamed: "IceCream\(lint)")
        if scored == 5 { lint = 1; interjection = SKSpriteNode(imageNamed: "Interjection5") } else { lint = 2 }
        let cream5 = SKSpriteNode(imageNamed: "IceCream\(lint)")
        
        let defaults = UserDefaults.standard
        highLbl.removeFromParent()
        currentLbl.removeFromParent()
        currentText.removeFromParent()
        highText.removeFromParent()
        currentScore = defaults.integer(forKey: "current")
        currentScore = currentScore + Int(scored)
        currentLbl.text = "\(currentScore)"
        self.addChild(currentLbl)
        highScore = highScore + Int(scored)
        defaults.set(highScore, forKey: "high")
        highLbl.text = "\(highScore)"
        defaults.set(currentScore, forKey: "current")
        self.addChild(highLbl)
        self.addChild(currentText)
        self.addChild(highText)
        
        points = 0
        
        interjection.size = CGSize(width: 1, height: 1)
        interjection.position = CGPoint(x: 0, y: 0)
        self.addChild(interjection)
        
        cream1.size = CGSize(width: self.frame.height / 6, height: self.frame.height / 6)
        cream1.position = CGPoint(x: self.frame.width * -(1/3), y: self.frame.height / -5)
        self.addChild(cream1)
        
        cream2.size = CGSize(width: self.frame.height / 6, height: self.frame.height / 6)
        cream2.position = CGPoint(x: self.frame.width * -(1/6), y: self.frame.height / -5)
        self.addChild(cream2)
        
        cream3.size = CGSize(width: self.frame.height / 6, height: self.frame.height / 6)
        cream3.position = CGPoint(x: 0, y: self.frame.height / -5)
        self.addChild(cream3)
        
        cream4.size = CGSize(width: self.frame.height / 6, height: self.frame.height / 6)
        cream4.position = CGPoint(x: self.frame.width * (1/6), y: self.frame.height / -5)
        self.addChild(cream4)
        
        cream5.size = CGSize(width: self.frame.height / 6, height: self.frame.height / 6)
        cream5.position = CGPoint(x: self.frame.width * (1/3), y: self.frame.height / -5)
        self.addChild(cream5)
        
        cream1.isHidden = true; cream2.isHidden = true; cream3.isHidden = true; cream4.isHidden = true; cream5.isHidden = true
        
        let wait = SKAction.wait(forDuration: 1)
        let wait2 = SKAction.wait(forDuration: 0.3)
        let unhide = SKAction.unhide()
        let sequence1 = SKAction.sequence([wait, unhide])
        let sequence2 = SKAction.sequence([wait, wait2, unhide])
        let sequence3 = SKAction.sequence([wait, wait2, wait2, unhide])
        let sequence4 = SKAction.sequence([wait, wait2, wait2, wait2, unhide])
        let sequence5 = SKAction.sequence([wait, wait2, wait2, wait2, wait2, unhide])
        let remove = SKAction.removeFromParent()
        
        cream1.run(sequence1)
        cream2.run(sequence2)
        cream3.run(sequence3)
        cream4.run(sequence4)
        cream5.run(sequence5)
        
        let grow = SKAction.scale(to: CGSize(width: self.frame.width, height: self.frame.height), duration: 1)
        let grow2 = SKAction.scale(to: CGSize(width: self.frame.width * 2, height: self.frame.height * 2), duration: 1)
        let wait3 = SKAction.wait(forDuration: 2)
        let sequence6 = SKAction.sequence([grow, wait3, grow2, remove])
        
        interjection.run(sequence6)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            cream1.removeFromParent()
            cream2.removeFromParent()
            cream3.removeFromParent()
            cream4.removeFromParent()
            cream5.removeFromParent()
        })
    }
    
    func score(score: Int) {
        let defaults = UserDefaults.standard
        highLbl.removeFromParent()
        currentLbl.removeFromParent()
        currentText.removeFromParent()
        highText.removeFromParent()
        currentScore = currentScore + score
        currentLbl.text = "\(currentScore)"
        self.addChild(currentLbl)
        if currentScore > highScore {
            highScore = currentScore
            defaults.set(highScore, forKey: "high")
        }
        highLbl.text = "\(highScore)"
        defaults.set(currentScore, forKey: "current")
        self.addChild(highLbl)
        self.addChild(currentText)
        self.addChild(highText)
    }
    
    func garbageTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.garbageDelay), target: self, selector: #selector(KakScene.foodFall), userInfo: nil, repeats: true)
    }
    
    @objc func foodFall() {
        if count == garbageCount {
            timer.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(garbageDelay * 2), execute: {
                if self.sorted - 1 != self.garbageCount && self.count == self.garbageCount {
                    let defaults = UserDefaults.standard
                    if self.level == 5 {
                        defaults.set(1, forKey: "lev")
                    } else {
                        defaults.set(self.level + 1, forKey: "lev")
                    }
                    self.level = defaults.integer(forKey: "lev")
                    self.animation(anim: self.level)
                    self.sorted = 0
                    self.count = 0
                }
            })
        } else {
            count += 1
        }
        
        let rotation = CGFloat.random(in: -4...4)
        let action = SKAction.moveBy(x: 0, y: -self.frame.height * 1.2, duration: TimeInterval(garbageSpeed))
        let rotate = SKAction.rotate(byAngle: 3.14 * rotation, duration: TimeInterval(garbageSpeed))

        if count == 1 || count == 5 || count == 9 || count == 13 || count == 17 || count == 21 || count == 25 {
            object1 = createObject()
            self.addChild(object1)
            object1.run(action)
            object1.run(rotate)
        } else if count == 2 || count == 6 || count == 10 || count == 14 || count == 18 || count == 22 || count == 26 {
            object2 = createObject()
            self.addChild(object2)
            object2.run(action)
            object2.run(rotate)
        } else if count == 3 || count == 7 || count == 11 || count == 15 || count == 19 || count == 23 || count == 27 {
            object3 = createObject()
            self.addChild(object3)
            object3.run(action)
            object3.run(rotate)
        } else if count == 4 || count == 8 || count == 12 || count == 16 || count == 20 || count == 24 || count == 28 {
            object4 = createObject()
            self.addChild(object4)
            object4.run(action)
            object4.run(rotate)
        }

    }
    
    func volcanoErupt(){
        let rumble1 = SKAction.moveBy(x: 0, y: self.frame.height / 50, duration: 0.2)
        let rumble2 = SKAction.moveBy(x: -self.frame.height / 50, y: self.frame.height / -25, duration: 0.2)
        let rumble3 = SKAction.moveBy(x: self.frame.height / 25, y: self.frame.height / 50, duration: 0.2)
        let unrumble = SKAction.move(to: CGPoint(x: (self.frame.width / 2) - (self.frame.height / 5), y: (self.frame.height / 2) - (self.frame.height / 6)), duration: 0.2)
        let wait = SKAction.wait(forDuration: 0.8)
        let sequence = SKAction.sequence([rumble1, rumble2, rumble3, unrumble, wait])
        let repeatSequence = SKAction.repeat(sequence, count: 3)
        volcano1.run(repeatSequence)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.garbageTimer()
            self.foodFall()
            self.volcano1.removeFromParent()
            self.tip1.removeFromParent()
            self.addChild(self.volcano2)
            self.addChild(self.lava)
            let action = SKAction.scaleX(to: 0.9, duration: 0.5)
            let action2 = SKAction.scaleX(to: 1.1, duration: 0.5)
            let wait = SKAction.wait(forDuration: 0.5)
            let sequence = SKAction.sequence([action, action2])
            let actionRepeat = SKAction.repeatForever(sequence)
            let sequence2 = SKAction.sequence([wait, actionRepeat])
            self.volcano2.run(sequence2)
            let action3 = SKAction.scaleY(to: 1.3, duration: 1)
            let action4 = SKAction.scaleY(to: 1.1, duration: 1)
            let sequence3 = SKAction.sequence([action3, action4])
            let repeatForever = SKAction.repeatForever(sequence3)
            self.lava.run(repeatForever)
        })
    }
    
    func createObject() -> SKSpriteNode {
        var object = SKSpriteNode()
        var objectSpawned = CGFloat.random(in: 1...26)
        objectSpawned.round(FloatingPointRoundingRule.toNearestOrAwayFromZero)
        let positionSpawned = CGFloat.random(in: 1.33...4)
        
        if objectSpawned == 1 || objectSpawned == 21 {
            object = SKSpriteNode(imageNamed: "Food1")
        } else if objectSpawned == 2 || objectSpawned == 22 {
            object = SKSpriteNode(imageNamed: "Food2")
        } else if objectSpawned == 3 || objectSpawned == 23 {
            object = SKSpriteNode(imageNamed: "Food3")
        } else if objectSpawned == 4 || objectSpawned == 24 {
            object = SKSpriteNode(imageNamed: "Food4")
        } else if objectSpawned == 5 || objectSpawned == 25 {
            object = SKSpriteNode(imageNamed: "Food5")
        } else if objectSpawned == 6 || objectSpawned == 26 {
            object = SKSpriteNode(imageNamed: "Food6")
        } else if objectSpawned == 7 {
            object = SKSpriteNode(imageNamed: "Trash1")
        } else if objectSpawned == 8 {
            object = SKSpriteNode(imageNamed: "Trash2")
        } else if objectSpawned == 9 {
            object = SKSpriteNode(imageNamed: "Trash3")
        } else if objectSpawned == 10 {
            object = SKSpriteNode(imageNamed: "Trash4")
        } else if objectSpawned == 11 {
            object = SKSpriteNode(imageNamed: "Trash5")
        } else if objectSpawned == 12 {
            object = SKSpriteNode(imageNamed: "Trash6")
        } else if objectSpawned == 13 {
            object = SKSpriteNode(imageNamed: "Trash7")
        } else if objectSpawned == 14 {
            object = SKSpriteNode(imageNamed: "Trash8")
        } else if objectSpawned == 15 {
            object = SKSpriteNode(imageNamed: "Trash9")
        } else if objectSpawned == 16 {
            object = SKSpriteNode(imageNamed: "Trash10")
        } else if objectSpawned == 17 {
            object = SKSpriteNode(imageNamed: "Trash11")
        } else if objectSpawned == 18 {
            object = SKSpriteNode(imageNamed: "Trash12")
        } else if objectSpawned == 19 {
            object = SKSpriteNode(imageNamed: "Trash13")
        } else if objectSpawned == 20 {
            object = SKSpriteNode(imageNamed: "Trash14")
        }
        
        object.size = CGSize(width: self.frame.height / 5, height: self.frame.height / 5)
        object.position = CGPoint(x: (self.frame.width / -2) + (self.frame.width / positionSpawned), y: (self.frame.height / 2) + (self.frame.height / 10))
        object.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 6, height: self.frame.height / 6))
        object.physicsBody?.usesPreciseCollisionDetection = true
        object.physicsBody?.categoryBitMask = PhysicsCatagory.trash
        object.physicsBody?.collisionBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
        object.physicsBody?.contactTestBitMask = PhysicsCatagory.kid | PhysicsCatagory.monster | PhysicsCatagory.ground
        object.physicsBody?.affectedByGravity = false
        object.physicsBody?.isDynamic = true
        
        if (objectSpawned >= 1 && objectSpawned <= 6) || (objectSpawned >= 21) {
            object.name = "food"
        } else if objectSpawned >= 7 && objectSpawned <= 20 {
            object.name = "trash"
        }
        
        return object
    }
    
    func animation(anim: Int) {
        levelStarted = false
        openeingDone = false
        levOn = SKSpriteNode(imageNamed: "Lev\(level)")
        var waitTime : Int = 15
        
        if anim == 1 {
            endbg.size = CGSize(width: self.frame.width, height: self.frame.height)
            endbg.position = CGPoint(x: 0, y: 0)
            endbg.isHidden = true
            self.addChild(endbg)
            let cover = SKSpriteNode()
            cover.color = SKColor.black
            cover.alpha = 0
            cover.size = CGSize(width: self.frame.width, height: self.frame.height)
            cover.position = CGPoint(x: 0, y: 0)
            self.addChild(cover)
            self.addChild(cloud1)
            self.addChild(cloud2)
            levOn.size = CGSize(width: 1, height: 1)
            self.addChild(levOn)
            kidsAndKreeps.removeFromParent()
            kidsAndKreeps.size = CGSize(width: 1, height: 1)
            self.addChild(kidsAndKreeps)
            let fall = SKAction.moveBy(x: 0, y: -self.frame.height * 2, duration: 12)
            let moveLeft = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 3)
            let moveRight = SKAction.moveBy(x: self.frame.width, y: 0, duration: 3)
            let wait = SKAction.wait(forDuration: 3)
            let wait3 = SKAction.wait(forDuration: 9)
            let wait4 = SKAction.wait(forDuration: 1)
            let grow = SKAction.scale(by: 4, duration: 2)
            let grow2 = SKAction.scale(to: CGSize(width: self.frame.width * 0.9, height: self.frame.height / 2.8), duration: 2)
            let grow3 = SKAction.scale(to: CGSize(width: self.frame.width, height: self.frame.height), duration: 2)
            let remove = SKAction.removeFromParent()
            var cloud1action = SKAction()
            var cloud2action = SKAction()
            var logoAction = SKAction()
            var foodAction = SKAction()
            var lev1Action = SKAction()
            let hide = SKAction.hide()
            let unhide = SKAction.unhide()
            let fade = SKAction.fadeAlpha(by: 1, duration: 2)
            let waitRemove = SKAction.sequence([wait, wait4, hide, wait3, wait4, wait4, unhide])
            let bgAction = SKAction.sequence([wait, unhide, wait3, wait, remove])
            let coverAction = SKAction.sequence([wait3, wait4, fade, wait, remove])
            var goGrow = SKAction()
            var goShrink = SKAction()
            var goAction1 = SKAction()
            var goRepeat = SKAction()
            var goAction2 = SKAction()
            if cloud1.position.x == 0 {
                cloud1action = SKAction.sequence([wait, wait3, moveLeft, remove])
                cloud2action = SKAction.sequence([wait, wait3, moveRight, remove])
                logoAction = SKAction.sequence([wait4, grow2, wait, grow, remove])
                foodAction = SKAction.sequence([wait, wait3, wait, fall])
                lev1Action = SKAction.sequence([wait, wait, wait4, grow3, wait4, wait4, wait4, grow, remove])
                goGrow = SKAction.scale(by: 1.2, duration: 1)
                goShrink = SKAction.scale(by: 0.8, duration: 1)
                goAction1 = SKAction.sequence([goGrow, goShrink])
                goRepeat = SKAction.repeatForever(goAction1)
                goAction2 = SKAction.sequence([wait3, wait, wait, unhide, goRepeat])
                waitTime = 15
                //sounds of logo when game loads up
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    let path = Bundle.main.path(forResource: "kidsandkreeps", ofType: "mp3")
                    let soundUrl = URL(fileURLWithPath: path!)
                    do {
                        try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                        self.audioPlayer.volume = 1
                        self.audioPlayer.numberOfLoops = 0
                        self.audioPlayer.play()
                    }catch {print(error)}
                })
            } else {
                audioPlayer.stop()
                waitTime = 24
                cloud1action = SKAction.sequence([moveRight, wait, moveLeft, wait, wait, moveRight, wait, moveLeft, remove])
                cloud2action = SKAction.sequence([moveLeft, wait, moveRight, wait, wait, moveLeft, wait, moveRight, remove])
                lev1Action = SKAction.sequence([wait3, wait, wait, wait4, grow3, wait, grow, remove])
                bg.run(waitRemove)
                kid.run(waitRemove)
                monster.run(waitRemove)
                endbg.run(bgAction)
                cover.run(coverAction)
                goGrow = SKAction.scale(by: 1.2, duration: 1)
                goShrink = SKAction.scale(by: 0.8, duration: 1)
                goAction1 = SKAction.sequence([goGrow, goShrink])
                goRepeat = SKAction.repeatForever(goAction1)
                goAction2 = SKAction.sequence([wait, wait3, wait3, wait, unhide, goRepeat])
                //sound of yays from finishing last level
                let path = Bundle.main.path(forResource: "end5", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
                //sound of yays from beating the game
                DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
                    var ran1 = CGFloat.random(in: 1...9)
                    ran1.round(FloatingPointRoundingRule.toNearestOrAwayFromZero)
                    let ran : Int = Int(ran1)
                    let path = Bundle.main.path(forResource: "end\(ran)", ofType: "mp3")
                    let soundUrl = URL(fileURLWithPath: path!)
                    do {
                        try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                        self.audioPlayer.volume = 1
                        self.audioPlayer.numberOfLoops = 0
                        self.audioPlayer.play()
                    }catch {print(error)}
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 9, execute: {
                    var ran1 = CGFloat.random(in: 1...9)
                    ran1.round(FloatingPointRoundingRule.toNearestOrAwayFromZero)
                    let ran : Int = Int(ran1)
                    let path2 = Bundle.main.path(forResource: "end\(ran)", ofType: "mp3")
                    let soundUrl2 = URL(fileURLWithPath: path2!)
                    do {
                        try self.audioPlayer2 = AVAudioPlayer(contentsOf: soundUrl2)
                        self.audioPlayer2.volume = 1
                        self.audioPlayer2.numberOfLoops = 0
                        self.audioPlayer2.play()
                    }catch {print(error)}
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                    var ran1 = CGFloat.random(in: 1...9)
                    ran1.round(FloatingPointRoundingRule.toNearestOrAwayFromZero)
                    let ran : Int = Int(ran1)
                    let path3 = Bundle.main.path(forResource: "end\(ran)", ofType: "mp3")
                    let soundUrl3 = URL(fileURLWithPath: path3!)
                    do {
                        try self.audioPlayer3 = AVAudioPlayer(contentsOf: soundUrl3)
                        self.audioPlayer3.volume = 1
                        self.audioPlayer3.numberOfLoops = 0
                        self.audioPlayer3.play()
                    }catch {print(error)}
                })
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime) - 6, execute: {
                //monster says the level
                let path = Bundle.main.path(forResource: "level1", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            })
            
            goSign.removeFromParent()
            goSign = SKSpriteNode(imageNamed: "Go")
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            self.addChild(goSign)
            goSign.isHidden = true
            goSign.run(goAction2)
            
            trash.removeFromParent()
            food.removeFromParent()
            trash.position = CGPoint(x: self.frame.height / -2.3, y: (self.frame.height / 2) + ((self.frame.height - ((self.frame.height / 4) + (self.frame.height / 6))) / 2) + (self.frame.height / 10))
            food.position = CGPoint(x: self.frame.height / 2.3, y: (self.frame.height / 2) + (self.frame.height / 10))
            self.addChild(trash)
            self.addChild(food)
            
            cloud1.run(cloud1action)
            cloud2.run(cloud2action)
            if points == -1 {
                kidsAndKreeps.run(logoAction)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.showScore()
                })
            }
            food.run(foodAction)
            trash.run(foodAction)
            levOn.run(lev1Action)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime), execute: {
                self.openeingDone = true
                //Monster does his little dance and song during tutorial segment
                let path = Bundle.main.path(forResource: "MonsterSong", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 10
                    self.audioPlayer.play()
                }catch {print(error)}
                let danceGrow = SKAction.scaleY(to: 1.2, duration: 0.5)
                let danceShrink = SKAction.scaleY(to: 1, duration: 0.5)
                let waitForDance = SKAction.wait(forDuration: 4.9)
                let danceSequence = SKAction.sequence([waitForDance, danceGrow, danceShrink])
                let repeatDance = SKAction.repeatForever(danceSequence)
                self.monster.run(repeatDance)
                self.currentText.removeFromParent()
                self.currentLbl.removeFromParent()
            })
        } else if anim == 2 {
            volcano2.removeFromParent()
            lava.removeFromParent()
            self.addChild(cloud1)
            self.addChild(cloud2)
            levOn.size = CGSize(width: 1, height: 1)
            self.addChild(levOn)
            kidsAndKreeps.removeFromParent()
            kidsAndKreeps.size = CGSize(width: 1, height: 1)
            self.addChild(kidsAndKreeps)
            let fall = SKAction.moveBy(x: 0, y: -self.frame.height * 2, duration: 12)
            let moveLeft = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 3)
            let moveRight = SKAction.moveBy(x: self.frame.width, y: 0, duration: 3)
            let wait = SKAction.wait(forDuration: 3)
            let wait3 = SKAction.wait(forDuration: 9)
            let wait4 = SKAction.wait(forDuration: 1)
            let grow = SKAction.scale(by: 4, duration: 2)
            let grow2 = SKAction.scale(to: CGSize(width: self.frame.width * 0.9, height: self.frame.height / 2.8), duration: 2)
            let grow3 = SKAction.scale(to: CGSize(width: self.frame.width, height: self.frame.height), duration: 2)
            let remove = SKAction.removeFromParent()
            var cloud1action = SKAction()
            var cloud2action = SKAction()
            if cloud1.position.x == 0 {
                cloud1action = SKAction.sequence([wait, wait3, moveLeft, remove])
                cloud2action = SKAction.sequence([wait, wait3, moveRight, remove])
                //sound of logo when you load up the game
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    let path = Bundle.main.path(forResource: "kidsandkreeps", ofType: "mp3")
                    let soundUrl = URL(fileURLWithPath: path!)
                    do {
                        try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                        self.audioPlayer.volume = 1
                        self.audioPlayer.numberOfLoops = 0
                        self.audioPlayer.play()
                    }catch {print(error)}
                })
            } else {
                audioPlayer.stop()
                cloud1action = SKAction.sequence([moveRight, wait3, moveLeft, remove])
                cloud2action = SKAction.sequence([moveLeft, wait3, moveRight, remove])
                //sound of yays when you beat the previous level
                let path = Bundle.main.path(forResource: "end5", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            }
            let logoAction = SKAction.sequence([wait4, grow2, wait, grow, remove])
            let foodAction = SKAction.sequence([wait, wait3, wait, fall])
            let lev1Action = SKAction.sequence([wait, wait, wait4, grow3, wait4, wait4, wait4, grow, remove])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime) - 6, execute: {
                //sound of monster saying the level
                let path = Bundle.main.path(forResource: "level2", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            })
            
            let unhide = SKAction.unhide()
            let goGrow = SKAction.scale(by: 1.2, duration: 1)
            let goShrink = SKAction.scale(by: 0.8, duration: 1)
            let goAction1 = SKAction.sequence([goGrow, goShrink])
            let goRepeat = SKAction.repeatForever(goAction1)
            let goAction2 = SKAction.sequence([wait3, wait, wait, unhide, goRepeat])
            goSign.removeFromParent()
            goSign = SKSpriteNode(imageNamed: "Go")
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            self.addChild(goSign)
            goSign.isHidden = true
            goSign.run(goAction2)
            
            trash.removeFromParent()
            food.removeFromParent()
            trash.position = CGPoint(x: self.frame.height / -2.3, y: (self.frame.height / 2) + ((self.frame.height - ((self.frame.height / 4) + (self.frame.height / 6))) / 2) + (self.frame.height / 10))
            food.position = CGPoint(x: self.frame.height / 2.3, y: (self.frame.height / 2) + (self.frame.height / 10))
            self.addChild(trash)
            self.addChild(food)
            
            cloud1.run(cloud1action)
            cloud2.run(cloud2action)
            if points == -1 {
                kidsAndKreeps.run(logoAction)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.showScore()
                })
            }
            food.run(foodAction)
            trash.run(foodAction)
            levOn.run(lev1Action)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime), execute: {
                self.openeingDone = true
                //sound of monster doing his tutorial dance
                let path = Bundle.main.path(forResource: "MonsterSong", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 10
                    self.audioPlayer.play()
                }catch {print(error)}
                let danceGrow = SKAction.scaleY(to: 1.2, duration: 0.5)
                let danceShrink = SKAction.scaleY(to: 1, duration: 0.5)
                let waitForDance = SKAction.wait(forDuration: 4.9)
                let danceSequence = SKAction.sequence([waitForDance, danceGrow, danceShrink])
                let repeatDance = SKAction.repeatForever(danceSequence)
                self.monster.run(repeatDance)
            })
        } else if anim == 3 {
            self.addChild(cloud1)
            self.addChild(cloud2)
            levOn.size = CGSize(width: 1, height: 1)
            self.addChild(levOn)
            kidsAndKreeps.removeFromParent()
            kidsAndKreeps.size = CGSize(width: 1, height: 1)
            self.addChild(kidsAndKreeps)
            let fall = SKAction.moveBy(x: 0, y: -self.frame.height * 2, duration: 12)
            let moveLeft = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 3)
            let moveRight = SKAction.moveBy(x: self.frame.width, y: 0, duration: 3)
            let wait = SKAction.wait(forDuration: 3)
            let wait3 = SKAction.wait(forDuration: 9)
            let wait4 = SKAction.wait(forDuration: 1)
            let grow = SKAction.scale(by: 4, duration: 2)
            let grow2 = SKAction.scale(to: CGSize(width: self.frame.width * 0.9, height: self.frame.height / 2.8), duration: 2)
            let grow3 = SKAction.scale(to: CGSize(width: self.frame.width, height: self.frame.height), duration: 2)
            let remove = SKAction.removeFromParent()
            var cloud1action = SKAction()
            var cloud2action = SKAction()
            if cloud1.position.x == 0 {
                cloud1action = SKAction.sequence([wait, wait3, moveLeft, remove])
                cloud2action = SKAction.sequence([wait, wait3, moveRight, remove])
                //sound of logo when you load the game
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    let path = Bundle.main.path(forResource: "kidsandkreeps", ofType: "mp3")
                    let soundUrl = URL(fileURLWithPath: path!)
                    do {
                        try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                        self.audioPlayer.volume = 1
                        self.audioPlayer.numberOfLoops = 0
                        self.audioPlayer.play()
                    }catch {print(error)}
                })
            } else {
                audioPlayer.stop()
                cloud1action = SKAction.sequence([moveRight, wait3, moveLeft, remove])
                cloud2action = SKAction.sequence([moveLeft, wait3, moveRight, remove])
                //sound of yays from beating previous level
                let path = Bundle.main.path(forResource: "end5", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            }
            let logoAction = SKAction.sequence([wait4, grow2, wait, grow, remove])
            let foodAction = SKAction.sequence([wait, wait3, wait, fall])
            let lev1Action = SKAction.sequence([wait, wait, wait4, grow3, wait4, wait4, wait4, grow, remove])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime) - 6, execute: {
                //sound of monster saying the level
                let path = Bundle.main.path(forResource: "level3", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            })
            
            let unhide = SKAction.unhide()
            let goGrow = SKAction.scale(by: 1.2, duration: 1)
            let goShrink = SKAction.scale(by: 0.8, duration: 1)
            let goAction1 = SKAction.sequence([goGrow, goShrink])
            let goRepeat = SKAction.repeatForever(goAction1)
            let goAction2 = SKAction.sequence([wait3, wait, wait, unhide, goRepeat])
            goSign.removeFromParent()
            goSign = SKSpriteNode(imageNamed: "Go")
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            self.addChild(goSign)
            goSign.isHidden = true
            goSign.run(goAction2)
            
            trash.removeFromParent()
            food.removeFromParent()
            trash.position = CGPoint(x: self.frame.height / -2.3, y: (self.frame.height / 2) + ((self.frame.height - ((self.frame.height / 4) + (self.frame.height / 6))) / 2) + (self.frame.height / 10))
            food.position = CGPoint(x: self.frame.height / 2.3, y: (self.frame.height / 2) + (self.frame.height / 10))
            self.addChild(trash)
            self.addChild(food)
            
            cloud1.run(cloud1action)
            cloud2.run(cloud2action)
            if points == -1 {
                kidsAndKreeps.run(logoAction)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.showScore()
                })
            }
            food.run(foodAction)
            trash.run(foodAction)
            levOn.run(lev1Action)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime), execute: {
                self.openeingDone = true
                //monster dancing sound; add the monster dancing animation here too i think
                let path = Bundle.main.path(forResource: "MonsterSong", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 10
                    self.audioPlayer.play()
                }catch {print(error)}
                let danceGrow = SKAction.scaleY(to: 1.2, duration: 0.5)
                let danceShrink = SKAction.scaleY(to: 1, duration: 0.5)
                let waitForDance = SKAction.wait(forDuration: 4.9)
                let danceSequence = SKAction.sequence([waitForDance, danceGrow, danceShrink])
                let repeatDance = SKAction.repeatForever(danceSequence)
                self.monster.run(repeatDance)
            })
        } else if anim == 4 {
            self.addChild(cloud1)
            self.addChild(cloud2)
            levOn.size = CGSize(width: 1, height: 1)
            self.addChild(levOn)
            kidsAndKreeps.removeFromParent()
            kidsAndKreeps.size = CGSize(width: 1, height: 1)
            self.addChild(kidsAndKreeps)
            let fall = SKAction.moveBy(x: 0, y: -self.frame.height * 2, duration: 12)
            let moveLeft = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 3)
            let moveRight = SKAction.moveBy(x: self.frame.width, y: 0, duration: 3)
            let wait = SKAction.wait(forDuration: 3)
            let wait3 = SKAction.wait(forDuration: 9)
            let wait4 = SKAction.wait(forDuration: 1)
            let grow = SKAction.scale(by: 4, duration: 2)
            let grow2 = SKAction.scale(to: CGSize(width: self.frame.width * 0.9, height: self.frame.height / 2.8), duration: 2)
            let grow3 = SKAction.scale(to: CGSize(width: self.frame.width, height: self.frame.height), duration: 2)
            let remove = SKAction.removeFromParent()
            var cloud1action = SKAction()
            var cloud2action = SKAction()
            if cloud1.position.x == 0 {
                cloud1action = SKAction.sequence([wait, wait3, moveLeft, remove])
                cloud2action = SKAction.sequence([wait, wait3, moveRight, remove])
                //logo sound for when game loads
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    let path = Bundle.main.path(forResource: "kidsandkreeps", ofType: "mp3")
                    let soundUrl = URL(fileURLWithPath: path!)
                    do {
                        try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                        self.audioPlayer.volume = 1
                        self.audioPlayer.numberOfLoops = 0
                        self.audioPlayer.play()
                    }catch {print(error)}
                })
            } else {
                audioPlayer.stop()
                cloud1action = SKAction.sequence([moveRight, wait3, moveLeft, remove])
                cloud2action = SKAction.sequence([moveLeft, wait3, moveRight, remove])
                //yays from beating the last level
                let path = Bundle.main.path(forResource: "end5", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            }
            let logoAction = SKAction.sequence([wait4, grow2, wait, grow, remove])
            let foodAction = SKAction.sequence([wait, wait3, wait, fall])
            let lev1Action = SKAction.sequence([wait, wait, wait4, grow3, wait4, wait4, wait4, grow, remove])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime) - 6, execute: {
                //monster saying the next level
                let path = Bundle.main.path(forResource: "level4", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            })
            
            let unhide = SKAction.unhide()
            let goGrow = SKAction.scale(by: 1.2, duration: 1)
            let goShrink = SKAction.scale(by: 0.8, duration: 1)
            let goAction1 = SKAction.sequence([goGrow, goShrink])
            let goRepeat = SKAction.repeatForever(goAction1)
            let goAction2 = SKAction.sequence([wait3, wait, wait, unhide, goRepeat])
            goSign.removeFromParent()
            goSign = SKSpriteNode(imageNamed: "Go")
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            self.addChild(goSign)
            goSign.isHidden = true
            goSign.run(goAction2)
            
            trash.removeFromParent()
            food.removeFromParent()
            trash.position = CGPoint(x: self.frame.height / -2.3, y: (self.frame.height / 2) + ((self.frame.height - ((self.frame.height / 4) + (self.frame.height / 6))) / 2) + (self.frame.height / 10))
            food.position = CGPoint(x: self.frame.height / 2.3, y: (self.frame.height / 2) + (self.frame.height / 10))
            self.addChild(trash)
            self.addChild(food)
            
            cloud1.run(cloud1action)
            cloud2.run(cloud2action)
            if points == -1 {
                kidsAndKreeps.run(logoAction)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.showScore()
                })
            }
            food.run(foodAction)
            trash.run(foodAction)
            levOn.run(lev1Action)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime), execute: {
                //monster dancing sound
                let path = Bundle.main.path(forResource: "MonsterSong", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 10
                    self.audioPlayer.play()
                }catch {print(error)}
                self.openeingDone = true
                let danceGrow = SKAction.scaleY(to: 1.2, duration: 0.5)
                let danceShrink = SKAction.scaleY(to: 1, duration: 0.5)
                let waitForDance = SKAction.wait(forDuration: 4.9)
                let danceSequence = SKAction.sequence([waitForDance, danceGrow, danceShrink])
                let repeatDance = SKAction.repeatForever(danceSequence)
                self.monster.run(repeatDance)
            })
        } else if anim == 5 {
            self.addChild(cloud1)
            self.addChild(cloud2)
            levOn.size = CGSize(width: 1, height: 1)
            self.addChild(levOn)
            kidsAndKreeps.removeFromParent()
            kidsAndKreeps.size = CGSize(width: 1, height: 1)
            self.addChild(kidsAndKreeps)
            let fall = SKAction.moveBy(x: 0, y: -self.frame.height * 2, duration: 12)
            let moveLeft = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 3)
            let moveRight = SKAction.moveBy(x: self.frame.width, y: 0, duration: 3)
            let wait = SKAction.wait(forDuration: 3)
            let wait3 = SKAction.wait(forDuration: 9)
            let wait4 = SKAction.wait(forDuration: 1)
            let grow = SKAction.scale(by: 4, duration: 2)
            let grow2 = SKAction.scale(to: CGSize(width: self.frame.width * 0.9, height: self.frame.height / 2.8), duration: 2)
            let grow3 = SKAction.scale(to: CGSize(width: self.frame.width, height: self.frame.height), duration: 2)
            let remove = SKAction.removeFromParent()
            var cloud1action = SKAction()
            var cloud2action = SKAction()
            if cloud1.position.x == 0 {
                cloud1action = SKAction.sequence([wait, wait3, moveLeft, remove])
                cloud2action = SKAction.sequence([wait, wait3, moveRight, remove])
                //sound of logo when loading up the game
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    let path = Bundle.main.path(forResource: "kidsandkreeps", ofType: "mp3")
                    let soundUrl = URL(fileURLWithPath: path!)
                    do {
                        try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                        self.audioPlayer.volume = 1
                        self.audioPlayer.numberOfLoops = 0
                        self.audioPlayer.play()
                    }catch {print(error)}
                })
            } else {
                audioPlayer.stop()
                cloud1action = SKAction.sequence([moveRight, wait3, moveLeft, remove])
                cloud2action = SKAction.sequence([moveLeft, wait3, moveRight, remove])
                //yays from beating previous level
                let path = Bundle.main.path(forResource: "end5", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            }
            let logoAction = SKAction.sequence([wait4, grow2, wait, grow, remove])
            let foodAction = SKAction.sequence([wait, wait3, wait, fall])
            let lev1Action = SKAction.sequence([wait, wait, wait4, grow3, wait, grow, remove])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime) - 6, execute: {
                //monster saying next level
                let path = Bundle.main.path(forResource: "level5", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 0
                    self.audioPlayer.play()
                }catch {print(error)}
            })
            
            let unhide = SKAction.unhide()
            let goGrow = SKAction.scale(by: 1.2, duration: 1)
            let goShrink = SKAction.scale(by: 0.8, duration: 1)
            let goAction1 = SKAction.sequence([goGrow, goShrink])
            let goRepeat = SKAction.repeatForever(goAction1)
            let goAction2 = SKAction.sequence([wait3, wait, wait, unhide, goRepeat])
            goSign.removeFromParent()
            goSign = SKSpriteNode(imageNamed: "Go")
            goSign.size = CGSize(width: self.frame.width, height: self.frame.height)
            self.addChild(goSign)
            goSign.isHidden = true
            goSign.run(goAction2)
            
            trash.removeFromParent()
            food.removeFromParent()
            trash.position = CGPoint(x: self.frame.height / -2.3, y: (self.frame.height / 2) + ((self.frame.height - ((self.frame.height / 4) + (self.frame.height / 6))) / 2) + (self.frame.height / 10))
            food.position = CGPoint(x: self.frame.height / 2.3, y: (self.frame.height / 2) + (self.frame.height / 10))
            self.addChild(trash)
            self.addChild(food)
            
            cloud1.run(cloud1action)
            cloud2.run(cloud2action)
            if points == -1 {
                kidsAndKreeps.run(logoAction)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.showScore()
                })
            }
            food.run(foodAction)
            trash.run(foodAction)
            levOn.run(lev1Action)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(waitTime), execute: {
                self.openeingDone = true
                //monster dance tune/toon
                let path = Bundle.main.path(forResource: "MonsterSong", ofType: "mp3")
                let soundUrl = URL(fileURLWithPath: path!)
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                    self.audioPlayer.volume = 1
                    self.audioPlayer.numberOfLoops = 10
                    self.audioPlayer.play()
                }catch {print(error)}
                let danceGrow = SKAction.scaleY(to: 1.2, duration: 0.5)
                let danceShrink = SKAction.scaleY(to: 1, duration: 0.5)
                let waitForDance = SKAction.wait(forDuration: 4.9)
                let danceSequence = SKAction.sequence([waitForDance, danceGrow, danceShrink])
                let repeatDance = SKAction.repeatForever(danceSequence)
                self.monster.run(repeatDance)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.bg.removeFromParent()
            self.kid.removeFromParent()
            self.monster.removeFromParent()
            self.kidYum.removeFromParent()
            self.kidYuk.removeFromParent()
            self.monsterYum.removeFromParent()
            self.monsterYuk.removeFromParent()
            self.bg = SKSpriteNode(imageNamed: "Bg\(self.level)")
            self.bg.size = CGSize(width: self.frame.width, height: self.frame.height)
            self.bg.zPosition = -2
            self.kid = SKSpriteNode(imageNamed: "Kid\(self.level)-1")
            self.kid.size = CGSize(width: self.frame.height / 2, height: self.frame.height / 2)
            self.kid.position = CGPoint(x: self.frame.height / 2.3, y: (self.frame.height / -2) + (self.frame.height / 3.8))
            self.kid.isUserInteractionEnabled = false
            self.kid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 4, height: self.frame.height / 3))
            self.kid.physicsBody?.usesPreciseCollisionDetection = true
            self.kid.physicsBody?.categoryBitMask = PhysicsCatagory.kid
            self.kid.physicsBody?.collisionBitMask = PhysicsCatagory.trash
            self.kid.physicsBody?.contactTestBitMask = PhysicsCatagory.trash
            self.kid.physicsBody?.affectedByGravity = false
            self.kid.physicsBody?.isDynamic = false
            self.kid.name = "kid"
            self.kid.zPosition = -1
            self.monster = SKSpriteNode(imageNamed: "Monster\(self.level)-1")
            self.monster.size = CGSize(width: self.frame.height / 2, height: self.frame.height / 2)
            self.monster.position = CGPoint(x: self.frame.height / -2.3, y: (self.frame.height / -2) + (self.frame.height / 3.8))
            self.monster.isUserInteractionEnabled = false
            self.monster.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.height / 3, height: self.frame.height / 3))
            self.monster.physicsBody?.usesPreciseCollisionDetection = true
            self.monster.physicsBody?.categoryBitMask = PhysicsCatagory.monster
            self.monster.physicsBody?.collisionBitMask = PhysicsCatagory.trash
            self.monster.physicsBody?.contactTestBitMask = PhysicsCatagory.trash
            self.monster.physicsBody?.affectedByGravity = false
            self.monster.physicsBody?.isDynamic = false
            self.monster.name = "monster"
            self.monster.zPosition = -1
            self.kidYum = SKSpriteNode(imageNamed: "Kid\(self.level)-2")
            self.kidYum.position = self.kid.position
            self.kidYum.size = self.kid.size
            self.kidYum.isHidden = true
            self.kidYuk = SKSpriteNode(imageNamed: "Kid\(self.level)-3")
            self.kidYuk.position = self.kid.position
            self.kidYuk.size = self.kid.size
            self.kidYuk.isHidden = true
            self.monsterYum = SKSpriteNode(imageNamed: "Monster\(self.level)-2")
            self.monsterYum.position = self.monster.position
            self.monsterYum.size = self.monster.size
            self.monsterYum.isHidden = true
            self.monsterYuk = SKSpriteNode(imageNamed: "Monster\(self.level)-3")
            self.monsterYuk.position = self.monster.position
            self.monsterYuk.size = self.monster.size
            self.monsterYuk.isHidden = true
            self.addChild(self.bg)
            self.addChild(self.kid)
            self.addChild(self.monster)
            self.addChild(self.monsterYuk)
            self.addChild(self.monsterYum)
            self.addChild(self.kidYuk)
            self.addChild(self.kidYum)
        })
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if object1.contains(pos) {
            touching1 = true
        } else if object2.contains(pos) {
            touching2 = true
        } else if object3.contains(pos) {
            touching3 = true
        } else if object4.contains(pos) {
            touching4 = true
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if touching1 == true {
            object1.removeAllActions()
            let action = SKAction.move(to: CGPoint(x: pos.x, y: pos.y), duration: 0)
            object1.run(action)
        } else if touching2 == true {
            object2.removeAllActions()
            let action = SKAction.move(to: CGPoint(x: pos.x, y: pos.y), duration: 0)
            object2.run(action)
        } else if touching3 == true {
            object3.removeAllActions()
            let action = SKAction.move(to: CGPoint(x: pos.x, y: pos.y), duration: 0)
            object3.run(action)
        } else if touching4 == true {
            object4.removeAllActions()
            let action = SKAction.move(to: CGPoint(x: pos.x, y: pos.y), duration: 0)
            object4.run(action)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if openeingDone == true && levelStarted == false {
            startLevel(lev: level)
        } else if levelStarted == true {
            if object1.contains(pos) {
                let action = SKAction.moveBy(x: 0, y: -self.frame.height * 1.2, duration: TimeInterval(garbageSpeed))
                object1.run(action)
            } else if object2.contains(pos) {
                let action = SKAction.moveBy(x: 0, y: -self.frame.height * 1.2, duration: TimeInterval(garbageSpeed))
                object2.run(action)
            } else if object3.contains(pos) {
                let action = SKAction.moveBy(x: 0, y: -self.frame.height * 1.2, duration: TimeInterval(garbageSpeed))
                object3.run(action)
            } else if object4.contains(pos) {
                let action = SKAction.moveBy(x: 0, y: -self.frame.height * 1.2, duration: TimeInterval(garbageSpeed))
                object4.run(action)
            }
            touching1 = false
            touching2 = false
            touching3 = false
            touching4 = false
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
