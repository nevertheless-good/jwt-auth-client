//
//  ContentView.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authenticatorVM: AuthenticatorViewModel
    @EnvironmentObject var writePostVM: WritePostViewModel

    var body: some View {
        if authenticatorVM.isAuthenticated {
            ListView()
        } else {
            AuthenticateView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticatorViewModel())
    }
}
