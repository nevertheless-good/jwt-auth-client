//
//  ListViewModel.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/20.
//

import Foundation

let INIT = 0
let DOWN = 1
let UP = 2

var startLoadIdx : Int = 9999999999999
var lastLoadIdx :Int = 0


class TitleListViewModel: ObservableObject {
    @Published var titleLists = [ResponseTitleLists]()
    
    
    init() {
        self.getList(mode: INIT)
    }
    
    func getList(mode refreshMode: Int){
        
        if ACCESS_TOKEN_EXPIRE < Date() {
            
            guard let refresh_token = UserDefaults.standard.string(forKey: "refresh_token") else { return }
            
            Task(priority: .background) {
                
                let resultUpdate = await Webservice().updateAccessToken(refresh_token: refresh_token)
                guard case .success(let access_token) = resultUpdate else { return }
                let responseTitleLists = await Webservice().getList(mode: refreshMode, access_token: access_token)
                guard case .success(let responseTitleLists) = responseTitleLists else { return }
                
                let titles = try? JSONDecoder().decode([ResponseTitleLists].self, from: responseTitleLists)
                
                DispatchQueue.main.async {
                    
                    for i in titles! {
                        
                        if refreshMode == INIT || (startLoadIdx > lastLoadIdx) {
                            self.titleLists.append(i)
                        } else if refreshMode == DOWN {
                            self.titleLists.insert(i, at: 0)
                        } else if refreshMode == UP {
                            self.titleLists.append(i)
                        }
                        
                        startLoadIdx = min(startLoadIdx, i.id)
                        lastLoadIdx = max(lastLoadIdx, i.id)
                    }
                }
            }
        } else {
            guard let access_token = UserDefaults.standard.string(forKey: "access_token") else { return }
            
            Task(priority: .background) {
                
                let responseTitleLists = await Webservice().getList(mode: refreshMode,  access_token: access_token)
                guard case .success(let responseTitleLists) = responseTitleLists else { return }
                
                let titles = try! JSONDecoder().decode([ResponseTitleLists].self, from: responseTitleLists)
                
                DispatchQueue.main.async {
                    for i in titles {
                        
                        if refreshMode == INIT || (startLoadIdx > lastLoadIdx) {
                            self.titleLists.append(i)
                        } else if refreshMode == DOWN {
                            self.titleLists.insert(i, at: 0)
                        } else if refreshMode == UP {
                            self.titleLists.append(i)
                        }
                        
                        startLoadIdx = min(startLoadIdx, i.id)
                        lastLoadIdx = max(lastLoadIdx, i.id)
                    }
                }
            }
        }
    }
}
