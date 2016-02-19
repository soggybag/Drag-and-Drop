//
//  GameScene.swift
//  Drag and Drop
//
//  Created by mitchell hudson on 2/18/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//


import UIKit
import SpriteKit

class GameScene: SKScene {
    
    var background = SKSpriteNode()
    var selectedNode = SKNode()
    
    let kAnimalName = "movable"
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch?.locationInNode(self)
        self.selectedNodeForTouch(positionInScene!)
    }
    
    func selectedNodeForTouch(positionInScene: CGPoint) {
        let touchNode = self.nodeAtPoint(positionInScene)
        if selectedNode != touchNode {
            print("???")
            selectedNode.removeAllActions()
            selectedNode.runAction(SKAction.rotateToAngle(0, duration: 0.1))
            selectedNode = touchNode
            
            if touchNode.name == kAnimalName {
                let sequence = SKAction.sequence([
                    SKAction.rotateToAngle(0.1, duration: 0.1),
                    SKAction.rotateToAngle(0, duration: 0.1),
                    SKAction.rotateToAngle(-0.1, duration: 0.1)])
                selectedNode.runAction(SKAction.repeatActionForever(sequence))
                
            }
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.locationInNode(self)
            let previousPosition = touch.previousLocationInNode(self)
            let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
            panForTranslation(translation)
        }
    }
    
    
    
    override func didMoveToView(view: SKView) {
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        background = SKSpriteNode(imageNamed: "background")
        background.size = size
        background.anchorPoint = CGPointZero
        background.position.x = size.width / 2
        background.position.y = size.height / 2
        background.zPosition = -1
        background.name = "background"
        addChild(background)
        
        let imageNames = ["n", "o", "p", "q"]
        var i = 0
        for imageName in imageNames {
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = kAnimalName
            
            let offset = CGFloat(i + 0) / CGFloat(imageNames.count)
            sprite.position = CGPoint(x: (size.width * offset)+48, y: size.height/2)
            addChild(sprite)
            i++
        }
    }
    
    
    func boundLayersPos(newPos: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = newPos
        if retval.x < 0 { retval.x = 0 }
        if retval.x > background.size.width + winSize.width { retval.x = background.size.width + winSize.width }
        retval.y = self.position.y
        return retval
    }
    
    
    func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position
        let point = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        if selectedNode.name == kAnimalName {
            selectedNode.position = point
        } else {
            background.position = self.boundLayersPos(point)
        }
    }
    
    
    func degToRad(degree: CGFloat) -> CGFloat {
        return degree / 180 * CGFloat(M_PI)
    }
    
}