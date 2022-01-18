//
//  LoggerInvoker.swift
//  XO-game
//
//  Created by Егор Кожемин on 26.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

internal final class LoggerInvoker {
    // MARK: Singleton

    internal static let shared = LoggerInvoker()

    private init() {}

    // MARK: Private properties

    private let logger = Logger()

    private let batchSize = 10

    private var commands: [LogCommand] = []

    // MARK: Internal

    internal func addLogCommand(_ command: LogCommand) {
        commands.append(command)
        executeCommandsIfNeeded()
    }

    // MARK: Private

    private func executeCommandsIfNeeded() {
        guard commands.count >= batchSize else {
            return
        }
        commands.forEach { self.logger.writeMessageToLog($0.logMessage) }
        commands = []
    }
}
