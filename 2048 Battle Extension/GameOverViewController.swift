//
//  GameOverViewController.swift
//  2048 Battle
//
//  Created by James Jackson on 6/25/17.
//  Copyright © 2017 James Jackson. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverViewController: UIViewController {

    @IBOutlet weak var result: UILabel!
    
    var audioPlayer: AVAudioPlayer!
    var resultText = ""
    var onTap : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //call our audio function and other functions to appear in the view
        self.setupAudio()
        result.text = resultText
    }
    
    func setupAudio() {
        guard let pathFile = Bundle.main.path(forResource: "move", ofType: "wav") else { return }
        
        let urlAudio = URL(fileURLWithPath: pathFile)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: urlAudio)
    }
    
    @IBAction func rematch(_ sender: Any) {
        self.audioPlayer.play()
        onTap!()
    }
    
    @IBAction func rate(_ sender: Any) {
        self.audioPlayer.play()
        if let url = URL(string: "A-2048Battle://"){
            self.extensionContext?.open(url, completionHandler: nil)
        }
    }
}
