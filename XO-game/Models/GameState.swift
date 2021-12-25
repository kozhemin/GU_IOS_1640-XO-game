//
//  GameState.swift
//  XO-game
//
//  Created by Егор Кожемин on 25.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

public protocol GameState {
    var isCompleted: Bool { get }

    func begin()

    func addMark(at position: GameboardPosition)
}
