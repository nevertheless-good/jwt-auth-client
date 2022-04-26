//
//  RefreshViewModel.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/20.
//

import SwiftUI

struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var downStarted: Bool
    var upStarted: Bool
    var released: Bool
    var invalid: Bool = false
}
