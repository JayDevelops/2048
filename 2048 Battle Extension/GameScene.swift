//
//  GameScene.swift
//  2048 Battle
//
//  Created by James Jackson on 6/25/17.
//  Copyright © 2017 James Jackson. All rights reserved.
//

import SpriteKit
import StoreKit
import SwiftyStoreKit

class GameScene: SKScene {
    
    var viewController: GameViewController!
    
    var board = Board()
    
    
    var timerValue = 180 {
        didSet {
            (self.childNode(withName: "Timer")?.childNode(withName: "TimerLabel") as! SKLabelNode).text = "\(timerString(time: timerValue))"
        }
    }
    
    var opponentScore = 0 {
        didSet {
            if GameStatus.current == .InPlay {
                (self.childNode(withName: "Vs")?.childNode(withName: "VsBestScore") as! SKLabelNode).text = "\(opponentScore)"
            } else {
                (self.childNode(withName: "You")?.childNode(withName: "YouBestScore") as! SKLabelNode).text = "\(opponentScore)"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        //add board to scene
        board.position = CGPoint(x: frame.midX - board.frame.midX, y: (frame.minY - board.frame.minY) + 70)
        addChild(board)
        addSwipeRecognizers(view)
        
        //If the score is greater than 0 then we shall start the timer
        if UserDefaults.standard.integer(forKey: "score") > 0 {
            self.board.score = UserDefaults.standard.integer(forKey: "score")
            self.timerValue = UserDefaults.standard.integer(forKey: "timer")
            
        }
        
        //Let's start the timer
        //What this does is count the timer down until it reaches 0
        let wait = SKAction.wait(forDuration: 1.0)
        let block = SKAction.run({
            [weak self] in
            if self!.timerValue > 0 {
                self!.timerValue -= 1
            } else {
                self!.isPaused = true
                self!.endGame()
            }
        })
        let sequence = SKAction.sequence([wait,block])
        run(SKAction.repeatForever(sequence), withKey: "countdown")
        
        if GameStatus.current == .Waiting {
            self.isPaused = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first?.location(in: self) {
            let nodes = self.nodes(at: touch)
            if nodes.count > 0 {
                if (nodes[0].name == "Pause"){
                    self.run(SKAction.playSoundFileNamed("move.wav", waitForCompletion: false), completion: {
                        self.isPaused = true
                    })
                    self.childNode(withName: "PauseMenu")?.isHidden = false
                    
                } else if (nodes[0].name == "Resume"){
                    self.isPaused = false
                    run(SKAction.playSoundFileNamed("move.wav", waitForCompletion: false))
                    self.childNode(withName: "PauseMenu")?.isHidden = true
                }
            }
        }
    }
    
    private func timerString(time:Int) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%2i:%02i", minutes, seconds)
    }
    
    fileprivate func endGame() {
        
        //Prevent cheating with the following code and save the data PERSISTENTLY!
        let preventCheatingIn = UserDefaults.standard
        preventCheatingIn.set(0, forKey: "timer")
        preventCheatingIn.set(self.board.score, forKey: "score")
        
        
        //Sends the other user with your score
        self.viewController.sendScore(score: self.board.bestScore)
        
        //Stops the countdown timer with a SK function call
        self.removeAction(forKey: "countdown")
    }
    
    //** Recognize Swipe */
    func addSwipeRecognizers(_ view: SKView) {
        let dirs: [UISwipeGestureRecognizer.Direction] = [.up, .down, .right, .left]
        for d in dirs {
            let r = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeHandler(_:)))
            r.cancelsTouchesInView = true
            r.direction = d
            view.addGestureRecognizer(r)
        }
    }
    
    //** Swipe Handler */
    @objc func swipeHandler(_ sender:UISwipeGestureRecognizer) {
        if !(self.isPaused) {
            board.swipe(sender.direction)
        }
        
        /* This is another way to end the game, basically when the board is filled with tiles then the game is over
            Otherwise, the other way to end the game is beating the opponents score!*/
        
        //This one check the user score is greater than the opponent score
        if (board.score > self.opponentScore) && (viewController.opponentScore != nil) {
            self.endGame()
            //Wow
        }
        
        //This one checks when the user has ran out of moves and will end the game
        if board.isGameOver() {
            self.isPaused = true
//            let alert = UIAlertController(title: "You're out of moves", message: "You're board will reset and score be saved", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Save Me", style: .default, handler: { (true) in
//                //In app store purchase
//                SwiftyStoreKit.purchaseProduct("saveMe", completion: { (true) in
//                    switch Result {
//                    case .sucess(let purchase):
//                        print("Purchase Sucess: \(purchase.productID)")
//                        self.isPaused = false
//                        self.board.reset()
//                    case .error(_):
//                        self.endGame()
//                    }
//                })
//            }))
//            alert.addAction(UIAlertAction(title: "End Turn", style: .destructive, handler: { (true) in
//                self.endGame()
//            }))
//            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
