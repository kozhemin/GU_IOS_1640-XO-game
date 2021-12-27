//
//  LogAction.swift
//  XO-game
//
//  Created by Егор Кожемин on 26.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

public enum LogAction {
    case playerInput(player: Player, position: GameboardPosition)

    case gameFinished(winner: Player?)

    case restartGame
}

public func Log(_ action: LogAction) {
    let command = LogCommand(action: action)
    LoggerInvoker.shared.addLogCommand(command)
}
