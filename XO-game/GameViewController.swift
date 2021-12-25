//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!

    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }

    private lazy var referee = Referee(gameboard: self.gameboard)

    override func viewDidLoad() {
        super.viewDidLoad()
        goToFirstState()

        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }

    private func goToFirstState() {
        let player = Player.first
        currentState = PlayerInputState(player: .first, markViewPrototype: player.markViewPrototype,
                                        gameViewController: self,
                                        gameboard: gameboard,
                                        gameboardView: gameboardView)
    }

    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }

        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView)
        }
    }

    @IBAction func restartButtonTapped(_: UIButton) {
        Log(.restartGame)
    }
}
