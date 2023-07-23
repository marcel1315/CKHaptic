//
//  ViewController.swift
//  CKHaptic
//
//  Created by Marcel on 07/22/2023.
//  Copyright (c) 2023 Marcel. All rights reserved.
//

import CKHaptic
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var buzz: UITextField!
    @IBOutlet weak var beat: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buzz.text = "---__---__--"
        beat.text = "__|____|____"
    }
    
    @IBAction func playHaptic(_ sender: UIButton) {
        errorLabel.text = ""
        
        do {
            // In UITextField, To input dash "-" twice might become a long dash("—") because of smart punctuation. So replace it to "-".
            let buzzText = buzz.text?.replacingOccurrences(of: "—", with: "-") ?? ""
            let beatText = beat.text ?? ""
            let events = [
                try CKHapticBuzz.create(buzzText, intensity: 0.5, sharpness: 0.5),
                try CKHapticBeat.create(beatText, intensity: 1, sharpness: 1)
            ]
            
            try CKHaptic.shared.play(events: events, duration: .milliseconds(1000))
            
        } catch {
            errorLabel.text = "Error: \(error.localizedDescription)"
            errorLabel.sizeToFit()
        }
    }
}
