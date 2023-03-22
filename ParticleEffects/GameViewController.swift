//
//  GameViewController.swift
//  ParticleEffects
//
//  Created by Tuan Le on 2023-01-19.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        
        scene = GameScene(size: skView.bounds.size)
        
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
