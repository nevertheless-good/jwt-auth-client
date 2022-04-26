//
//  AuthenticateViewModel.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/19.
//

import SwiftUI

class AuthenticatorViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    
    @Published var existAlertMsg = false
    @Published var alertMsg = ""
    
    func login(user username: String, pass password: String) {
        if username.isEmpty {
            self.alertMsg = "Input User Name"
            self.existAlertMsg = true
            return
        }
        if password.isEmpty {
            self.alertMsg = "Input Password"
            self.existAlertMsg = true
            return
        }
        
        Task(priority: .background) {
            let resultLogin = await Webservice().login(username: username, password: password)
            guard case .success(let resultLogin) = resultLogin else { return }

            let result = try! JSONDecoder().decode(ResponseLogin.self, from: resultLogin)
            
            DispatchQueue.main.async {
                if result.access_token != nil, result.refresh_token != nil {
                    self.isAuthenticated = true
                } else {
                    self.alertMsg = result.detail!
                    self.existAlertMsg = true
                }
            }
        }
    }
    
    func register(user username: String, pass password: String, rePass rePassword: String) {
        
        if username.isEmpty {
            self.alertMsg = "Input User Name"
            self.existAlertMsg = true
            return
        }
        if password.isEmpty {
            self.alertMsg = "Input Password"
            self.existAlertMsg = true
            return
        }
        if rePassword.isEmpty {
            self.alertMsg = "Input RePassword"
            self.existAlertMsg = true
            return
        }
        
        Task(priority: .background) {
            let resultRegister = await Webservice().register(username: username, password: password)
            guard case .success(let resultRegister) = resultRegister else { return }

            let result = try! JSONDecoder().decode(ResponseRegister.self, from: resultRegister)

            DispatchQueue.main.async {
                if result.username != nil {
                    self.alertMsg = "\(result.username!) is created"
                    self.existAlertMsg = true
                } else {
                    self.alertMsg = result.detail!
                    self.existAlertMsg = true
                }
            }
        }
    }

    func isValidEmail(email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
}
