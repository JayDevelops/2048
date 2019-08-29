//
//  StartGameViewController.swift
//  2048 Battle
//
//  Created by James Jackson on 6/25/17.
//  Copyright © 2017 James Jackson. All rights reserved.
//

import UIKit
import AVFoundation

class StartGameViewController: UIViewController {
    
    var onTap : (() -> Void)?
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAudio()
    }
    
    //This is the button to start the game
    @IBAction func startGame(_ sender: Any) {
        //Now we call the function of the messages sending function and the audio file
        self.audioPlayer.play()
        onTap?()
    }
    
    //This is the function to call in the button for audio
    func setupAudio() {
        //Find the file source of the audio from the bundle path
        guard let pathFile = Bundle.main.path(forResource: "move", ofType: "wav") else {return}
        
        //Make a variable to contain the path file url
        let urlAudio = URL(fileURLWithPath: pathFile)
        
        //Now, let's insert the audio file into the audio player
        self.audioPlayer = try? AVAudioPlayer(contentsOf: urlAudio)
    }
}
