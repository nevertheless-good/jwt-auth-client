//
//  DetailViewModel.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/20.
//

import SwiftUI
//import JWTDecode

class ContentDetailViewModel: ObservableObject {
    @Published var detail: String = ""

    func getContent(at: Int) {
        
        if ACCESS_TOKEN_EXPIRE < Date() {
            guard let refresh_token = UserDefaults.standard.string(forKey: "refresh_token") else { return }

            Task(priority: .background) {
                let resultUpdate = await Webservice().updateAccessToken(refresh_token: refresh_token)
                guard case .success(let access_token) = resultUpdate else { return }
                let resultDetail = await Webservice().getDetail(index: at, access_token: access_token)
                guard case .success(let detail) = resultDetail else { return }
                DispatchQueue.main.async {
                    self.detail = detail
                }
            }
        } else {
            guard let access_token = UserDefaults.standard.string(forKey: "access_token") else { return }
            
            Task(priority: .background) {
                let resultDetail = await Webservice().getDetail(index: at, access_token: access_token)
                guard case .success(let detail) = resultDetail else { return }
                DispatchQueue.main.async {
                    self.detail = detail
                }
            }
        }
    }
}
