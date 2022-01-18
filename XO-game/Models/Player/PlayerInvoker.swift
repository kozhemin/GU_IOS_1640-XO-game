//
//  PlayerInvoker.swift
//  XO-game
//
//  Created by Егор Кожемин on 27.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

class PlayerInvoker {
    static let shared = PlayerInvoker()
    private init() {}

    private var commands: [Player: [PlayerCommand]] = [:]
    let maxCommand = 5

    func addCommand(player: Player, command: PlayerCommand) {
        if commands[player] == nil {
            commands[player] = [command]
        } else {
            commands[player]?.append(command)
        }
    }

    func runCommands() {
        for i in 0 ..< maxCommand {
            for player in Player.allCases {
                guard let commandPlayer = commands[player]?[i] else { continue }
                commandPlayer.execute()
            }
        }

        clearCommands()
    }

    func clearCommands() {
        commands = [:]
    }

    func isCommandsComplete() -> Bool {
        for player in Player.allCases {
            if !isCommandByPlayerComplete(player: player) {
                return false
            }
        }
        return true
    }

    func isCommandByPlayerComplete(player: Player) -> Bool {
        return commands[player]?.count == maxCommand
    }

    private func getCountCommandByPlayer(player: Player) -> Int? {
        return commands[player]?.count
    }
}
