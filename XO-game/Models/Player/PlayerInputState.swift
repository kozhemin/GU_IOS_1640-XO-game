//
//  PlayerInputState.swift
//  XO-game
//
//  Created by Егор Кожемин on 25.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

public class PlayerInputState: GameState {
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
              gameboardView.canPlaceMarkView(at: position)
        else { return }

        //        let markView: MarkView
        //        switch self.player {
        //        case .first:
        //            markView = XView()
        //        case .second:
        //            markView = OView()
        //        }
        //        self.gameboard?.setPlayer(self.player, at: position)
        //        self.gameboardView?.placeMarkView(markView, at: position)
        //        self.isCompleted = true

        gameboard?.setPlayer(player, at: position)
        self.gameboardView?.placeMarkView(markViewPrototype.copy(), at: position)
        isCompleted = true
    }
}
