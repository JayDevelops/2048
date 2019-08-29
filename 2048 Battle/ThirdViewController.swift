//
//  ThirdViewController.swift
//  2048 Battle
//
//  Created by James Jackson on 6/25/17.
//  Copyright © 2017 James Jackson. All rights reserved.
//

import UIKit
import Messages
import MessageUI

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var letsBattleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.letsBattleButton.alpha = 1
        }
    }
    
    
    //When this button is pressed, this will open up in the iMessage environment
    @IBAction func startGame(_ sender: Any) {
        let messageComposer = configureMessageComposer()
        
        if MFMessageComposeViewController.canSendText() {
            let session = MSSession()
            let layout = MSMessageTemplateLayout()
            
            layout.image = UIImage(named: "PlayApp")
            layout.caption = "Let's Play 2048 Battle"
            
            let message = MSMessage(session: session)
            message.layout = layout
            message.summaryText = "Sent 2048 Battle Message"
            messageComposer.message = message
            
            present(messageComposer, animated: true, completion: nil)
            
        }
        //Wow
        
        
    }
    
    //This is the message preparationto send data from the app view controller to the iMessage view controller
    func configureMessageComposer() -> MFMessageComposeViewController {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        return messageComposer
    }
}


extension ThirdViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
}
