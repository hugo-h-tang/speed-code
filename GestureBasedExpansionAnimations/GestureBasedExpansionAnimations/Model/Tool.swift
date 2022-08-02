//
//  Tool.swift
//  GestureBasedExpansionAnimations
//
//  Created by Hugo L on 2022/8/2.
//

import Foundation
import SwiftUI

struct Tool: Identifiable {
    var id: String = UUID().uuidString
    var icon: String
    var name: String
    var color: Color
    var toolPosition: CGRect = .zero
}
