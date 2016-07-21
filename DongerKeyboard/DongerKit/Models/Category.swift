//
//  Category.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/21/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import Foundation

public indirect enum Category {
    case Root(id: Int, name: String)
    case Node(id: Int, name: String, parent: Category)
}