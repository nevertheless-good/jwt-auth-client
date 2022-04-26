//
//  WriteViewModel.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/20.
//

import SwiftUI

class WritePostViewModel: ObservableObject {
    @Published var existSuccessPostContent = false
    @Published var existAlertMsg = false
    @Published var isEditContent = false
    @Published var alertMsg = ""
    
    @ObservedObject var titleText = InputTextLimiter(limit: 50)

    func saveContent(title titleString: String, detail detailString: String) {
        
        if titleString.isEmpty {
            self.alertMsg = "Input Title"
            self.existAlertMsg = true
            return
        }
        if detailString.isEmpty {
            self.alertMsg = "Input Detail"
            self.existAlertMsg = true
            return
        }
        
        if ACCESS_TOKEN_EXPIRE < Date() {
            guard let refresh_token = UserDefaults.standard.string(forKey: "refresh_token") else { return }

            Task(priority: .background) {
                let resultUpdate = await Webservice().updateAccessToken(refresh_token: refresh_token)
                guard case .success(let access_token) = resultUpdate else { return }
                let resultPost = await Webservice().saveContent(title: titleString, detail: detailString, access_token: access_token)
                guard case .success(let resultPost) = resultPost else { return }
                let result = try! JSONDecoder().decode(ResponsePost.self, from: resultPost)

                DispatchQueue.main.async {
                    if result.title != nil {
                        self.alertMsg = "\(result.title!) is posted"
                        self.existAlertMsg = true
                    } else {
                        self.alertMsg = result.detail!
                        self.existAlertMsg = true
                    }
                }
            }
        } else {
            guard let access_token = UserDefaults.standard.string(forKey: "access_token") else { return }
            
            Task(priority: .background) {
                let resultPost = await Webservice().saveContent(title: titleString, detail: detailString, access_token: access_token)
                guard case .success(let resultPost) = resultPost else { return }
                let result = try! JSONDecoder().decode(ResponsePost.self, from: resultPost)

                DispatchQueue.main.async {
                    if result.title != nil {
                        self.alertMsg = "SUCCESS"
//                        self.alertMsg = "\(result.title!) is posted"
                        self.existAlertMsg = true
                    } else {
                        self.alertMsg = result.detail!
                        self.existAlertMsg = true
                    }
                }
            }
        }
    }
    
//    func time() -> String {
//        let date = DateFormatter()
//        date.locale = Locale(identifier: Locale.current.identifier)
//        date.timeZone = TimeZone(identifier: TimeZone.current.identifier)
//        date.locale = Locale(identifier: "ko_KR")
//        date.timeZone = TimeZone(identifier: "KST")
//        date.dateFormat = "yyyy.MM.dd HH:mm:ss"
//        print(date.string(from: Date()))
//
//        return date.string(from: Date())
//    }
}
