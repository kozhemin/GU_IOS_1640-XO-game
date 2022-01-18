//
//  ConfigViewController.swift
//  XO-game
//
//  Created by Егор Кожемин on 26.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    @IBOutlet var gemeModeSegment: UISegmentedControl!
    public var configDelegate: GameConfigDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func changeMode(_: Any) {
        let gameMode: GameMode
        switch gemeModeSegment.selectedSegmentIndex {
        case 0:
            gameMode = .TwoPlayers
        case 1:
            gameMode = .againstTheComputer
        case 2:
            gameMode = .fiveMarks
        default:
            gameMode = .TwoPlayers
        }

        configDelegate?.setNewMode(newMode: gameMode)
    }
}
