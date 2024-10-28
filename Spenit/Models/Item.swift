//
//  Data.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//

import SwiftData
import Foundation

@Model
class Item {
    var timestamp: Date
    
    init(timestamp: Date = .now) {
        self.timestamp = timestamp
    }
}
