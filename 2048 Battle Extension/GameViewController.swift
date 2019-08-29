//
//  GameViewController.swift
//  2048 Battle
//
//  Created by James Jackson on 6/25/17.
//  Copyright © 2017 James Jackson. All rights reserved.
//

import UIKit
import SpriteKit

enum GameStatus {
    case Waiting, InPlay
    static var current = GameStatus.Waiting
}

//This is our protocol and delegate function
protocol GameViewControllerDelegate : class {
    func sendMove(score: Int)
    func endGame(score: Int, opponentScore: Int)
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var spriteView: SKView!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingLabel: UILabel!
    
    weak var delegate : GameViewControllerDelegate?
    
    public var opponentScore : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The current view is including our sprite view (making a game)
        if let view = spriteView {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.scaleMode = .aspectFill
                
                scene.viewController = self
                
                if let opponentScore = self.opponentScore {
                    scene.opponentScore = opponentScore
                }
                
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
        //If the user is playing then we will hide the waiting view controller
        if GameStatus.current == .InPlay {
            waitingView.isHidden = true
        }
        
        
        //This adds onto a dot effect in which the user waits for his/her turn
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { (true) in
            let messageText : String = self.waitingLabel.text!
            let dotCount : Int = (self.waitingLabel.text?.count)! - messageText.replacingOccurrences(of: ".", with: "").count + 1
            
            self.waitingLabel.text = "Waiting for Opponent"
            var addOn : String = "."
            if dotCount < 4 {
                addOn = "".padding(toLength: dotCount, withPad: ".", startingAt: 0)
            }
            self.waitingLabel.text = self.waitingLabel.text!.appending(addOn)
        }
        
        
    }
    
    public func sendScore(score: Int) {
        //If there's a score at the end of the game, send the score to the other user
        if let opponentScore = self.opponentScore {
            self.delegate?.endGame(score: score, opponentScore: opponentScore)
        }   else    {
            self.delegate?.sendMove(score: score)
        }
    }
}
