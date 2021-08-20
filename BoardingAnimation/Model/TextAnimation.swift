//
//  TextAnimation.swift
//  TextAnimation
//
//  Created by Michele Manniello on 20/08/21.
//

import SwiftUI
struct TextAnimation: Identifiable {
    var id = UUID().uuidString
    var text : String
    var offset : CGFloat = 110
}
