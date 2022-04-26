//
//  AuthenticateView.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/20.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AuthenticateView: View {
    @EnvironmentObject var authenticatorVM: AuthenticatorViewModel
    
    @State var index = 0
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .top) {
                Color("Color").edgesIgnoringSafeArea(.all)

                ZStack {
                    RegisterView(index: self.$index)
                        // changing view order...
                        .zIndex(Double(self.index))

                    LoginView(index: self.$index)
                }
                Spacer()
            }
            .alert(isPresented: $authenticatorVM.existAlertMsg) {
                Alert(title: Text("Alert"), message: Text("\(authenticatorVM.alertMsg)"), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            self.dismissKeyboard()
        }
    }
}

struct AuthenticateView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticateView()
            .environmentObject(AuthenticatorViewModel())
    }
}
