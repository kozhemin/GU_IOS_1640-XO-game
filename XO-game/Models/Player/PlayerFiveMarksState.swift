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

    let maxMark = 5
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
              gameboardView.canPlaceMarkView(at: position)
        else { return }

        gameboard?.setPlayer(player, at: position)
        self.gameboardView?.placeMarkView(markViewPrototype.copy(), at: position)

        setMarksState(position: position)

        if PlayerFiveMarksState.playerMarks[player]?.count == maxMark {
            isCompleted = true
            runGame()
            return
        }
    }

    private func setMarksState(position: GameboardPosition) {
        if PlayerFiveMarksState.playerMarks[player] == nil {
            PlayerFiveMarksState.playerMarks[player] = [position]
        } else {
            PlayerFiveMarksState.playerMarks[player]?.append(position)
        }
    }

    // MARK: реализация игры по указанным меткам

    private func runGame() {
        gameboard?.clear()
        gameboardView?.clear()

        if !checkGameBefore() {
            return
        }

        guard let gameboardView = self.gameboardView
        else { return }

        for i in 0 ..< maxMark {
            guard
                let positionFirstPlayer = PlayerFiveMarksState.playerMarks[.first]?[i],
                let positionSecondPlayer = PlayerFiveMarksState.playerMarks[.second]?[i]
            else { continue }

            if gameboardView.canPlaceMarkView(at: positionFirstPlayer) {
                gameboard?.setPlayer(.first, at: positionFirstPlayer)
                self.gameboardView?.placeMarkView(XView(), at: positionFirstPlayer)
            }

            if gameboardView.canPlaceMarkView(at: positionSecondPlayer) {
                gameboard?.setPlayer(.second, at: positionSecondPlayer)
                self.gameboardView?.placeMarkView(OView(), at: positionSecondPlayer)
            }
        }

        PlayerFiveMarksState.playerMarks = [:]
    }

    // MARK: Проверка что каждый игрок сделал нужное к-во отметок н доске
    
    private func checkGameBefore() -> Bool {
        for player in Player.allCases {
            if PlayerFiveMarksState.playerMarks[player]?.count != maxMark {
                return false
            }
        }
        return true
    }
}
