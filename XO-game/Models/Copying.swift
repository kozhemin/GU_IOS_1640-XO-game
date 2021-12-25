//
//  Copying.swift
//  XO-game
//
//  Created by Егор Кожемин on 25.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

protocol Copying {
    init(_ prototype: Self)
}

extension Copying {
    func copy() -> Self {
        return type(of: self).init(self)
    }
}
