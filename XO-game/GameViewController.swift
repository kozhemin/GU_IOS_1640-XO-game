//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

protocol GameConfigDelegate {
    func setNewMode(newMode: GameMode)
}

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
    private var gameMode = GameMode.TwoPlayers {
        didSet {
            goToFirstState()
        }
    }

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

    // MARK: Игрок по умолчанию

    private func goToFirstState() {
        let player = Player.first

        switch gameMode {
        case .TwoPlayers, .againstTheComputer:
            currentState = PlayerInputState(player: .first, markViewPrototype: player.markViewPrototype,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView)
        case .fiveMarks:
            currentState = PlayerFiveMarksState(player: .first, markViewPrototype: player.markViewPrototype,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView)
        }
    }

    // MARK: Другая логика выбора игрока

    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }

        var player = Player.first
        if let playerInputState = currentState as? PlayerInputState {
            player = playerInputState.player.next
        }
        if let playerComputerState = currentState as? PlayerComputerState {
            player = playerComputerState.player.next
        }
        if let playerFiveMarksState = currentState as? PlayerFiveMarksState {
            player = playerFiveMarksState.player.next
        }

        switch gameMode {
        case .TwoPlayers:
            currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView)
        case .againstTheComputer:
            switch player {
            case .first:
                currentState = PlayerInputState(player: .first, markViewPrototype: player.markViewPrototype,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView)
            case .second:
                currentState = PlayerComputerState(player: .second, markViewPrototype: player.markViewPrototype,
                                                   gameViewController: self,
                                                   gameboard: gameboard,
                                                   gameboardView: gameboardView)
            }
        case .fiveMarks:
            currentState = PlayerFiveMarksState(player: player, markViewPrototype: player.markViewPrototype,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView)
        }
    }

    @IBAction func restartButtonTapped(_: UIButton) {
        Log(.restartGame)

        gameboard.clear()
        gameboardView.clear()
        gameMode = .TwoPlayers
        goToFirstState()
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        switch segue.identifier {
        case "ShowConfigSegue":
            guard let vc = segue.destination as? ConfigViewController else { return }
            vc.configDelegate = self
        default:
            return
        }
    }
}

extension GameViewController: GameConfigDelegate {
    func setNewMode(newMode: GameMode) {
        gameMode = newMode
    }
}
