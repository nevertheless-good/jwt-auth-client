//
//  jwt_auth_clientApp.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/19.
//

import SwiftUI

@main
struct jwt_auth_clientApp: App {
    @StateObject var writePostVM = WritePostViewModel()
    @StateObject var authenticatorVM = AuthenticatorViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(writePostVM)
                .environmentObject(authenticatorVM)
        }
    }
}
