//
//  ConfigViewController.swift
//  XO-game
//
//  Created by Егор Кожемин on 26.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    @IBOutlet weak var gemeModeSegment: UISegmentedControl!
    public var configDelegate: GameConfigDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeMode(_ sender: Any) {
        let gameMode: GameMode
        switch self.gemeModeSegment.selectedSegmentIndex {
        case 0:
            gameMode = .TwoPlayers
        case 1:
            gameMode = .againstTheComputer
        default:
            gameMode = .TwoPlayers
        }
        
        configDelegate?.setNewMode(newMode: gameMode)
    }
}
