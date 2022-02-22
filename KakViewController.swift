//
//  GameViewController.swift
//  Kids and Kreeps
//
//  Created by Alexander Eckert on 9/15/19.
//  Copyright © 2019 Alexander Eckert. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class KakViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = SKScene(fileNamed: "KakScene"){
            let skView = self.view as! SKView
            
            skView.presentScene(scene)
        }
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .top
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
