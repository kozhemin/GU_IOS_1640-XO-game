//
//  PlayerFiveMarksState.swift
//  XO-game
//
//  Created by Егор Кожемин on 26.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

public class PlayerFiveMarksState: GameState {
    private static var playerMarks: [Player: [GameboardPosition]] = [:]
    public private(set) var isCompleted = false

    public let markViewPrototype: MarkView
    public let player: Player

    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?

    init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }

    public func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        gameViewController?.winnerLabel.isHidden = true
    }

    public func addMark(at position: GameboardPosition) {
        Log(.playerInput(player: player, position: position))

        guard let gameboardView = self.gameboardView,
              gameboardView.canPlaceMarkView(at: position),
              let gameboard = self.gameboard
        else { return }

        gameboard.setPlayer(player, at: position)
        self.gameboardView?.placeMarkView(markViewPrototype.copy(), at: position)

        // Создаем комманду и добавлем ее в очередь

        let command = PlayerCommand(
            gameboardView: gameboardView,
            gameboard: gameboard,
            position: position, player: player
        )

        PlayerInvoker.shared.addCommand(player: player, command: command)

        if PlayerInvoker.shared.isCommandByPlayerComplete(player: player) {
            playerComplete()
            return
        }
    }

    private func playerComplete() {
        isCompleted = true
        gameboard?.clear()
        gameboardView?.clear()

        if PlayerInvoker.shared.isCommandsComplete() {
            PlayerInvoker.shared.runCommands()
        }
    }
}
