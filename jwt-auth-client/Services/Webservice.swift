//
//  Webservice.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/22.
//

import Foundation

class Webservice {
    
    func updateAccessToken(refresh_token: String) async -> Result<String, Error> {
        do {
            let url = URL(string: "\(BASE_URL)/update_token")
            var request = URLRequest(url: url!)
            request.addValue("Bearer \(refresh_token)", forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: request)
            let responseUpdateToken = try JSONDecoder().decode(ResponseUpdateToken.self, from: data)
            
            UserDefaults.standard.setValue(responseUpdateToken.access_token!, forKey: "access_token")
            do {
                let access_token_jwt = try decode(jwt: responseUpdateToken.access_token!)
                ACCESS_TOKEN_EXPIRE = access_token_jwt.expiresAt!
            } catch(let error){
                return .failure(error)
            }
            
            return .success(responseUpdateToken.access_token!)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    func saveContent(title: String, detail: String, access_token: String) async -> Result<Data, Error> {
        
        do {
            let url = URL(string: "\(BASE_URL)/posts")
            
            let body = SaveContnetBody(title: title, detail: detail)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.httpBody = try? JSONEncoder().encode(body)
            request.addValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)

            return .success(data)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    func getDetail(index: Int, access_token: String) async -> Result<String, Error> {
        do {
            let url = URL(string: "\(BASE_URL)/posts/\(index)")
            var request = URLRequest(url: url!)
            request.addValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: request)
            let content = try JSONDecoder().decode(ResponseDetail.self, from: data)
            return .success(content.detail)
        } catch(let error) {
            return .failure(error)
        }
    }

    func getList(mode: Int, access_token: String) async -> Result<Data, Error> {
        var queryUrl: String = ""
        
        if mode == INIT || (startLoadIdx > lastLoadIdx) {
            queryUrl = BASE_URL + "/posts?start=0&limit=\(QUERY_COUNT)&order=desc"
        } else if mode == DOWN {
            queryUrl = BASE_URL + "/posts?start=\(lastLoadIdx + 1)&limit=\(QUERY_COUNT)&order=asc"
        } else if mode == UP {
            queryUrl = BASE_URL + "/posts?start=\(startLoadIdx - 1)&limit=\(QUERY_COUNT)&order=desc"
        }
        
        do {
            let url = URL(string: queryUrl)
            var request = URLRequest(url: url!)
            request.addValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: request)
            return .success(data)
        } catch(let error) {
            return .failure(error)
        }
    }
 
    func login(username: String, password: String) async -> Result<Data, Error> {
        
        do {
            let url = URL(string: "\(BASE_URL)/login")
            
            let body = AuthRequestBody(username: username, password: password)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.httpBody = try? JSONEncoder().encode(body)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let result = try! JSONDecoder().decode(ResponseLogin.self, from: data)
            
            if result.detail != nil {
                return .success(data)
            }
            
            do {
                let access_token_jwt = try decode(jwt: result.access_token!)
                ACCESS_TOKEN_EXPIRE = access_token_jwt.expiresAt!
                
                let refresh_token_jwt = try decode(jwt: result.refresh_token!)
                REFRESH_TOKEN_EXPIRE = refresh_token_jwt.expiresAt!
                
                UserDefaults.standard.setValue(result.access_token!, forKey: "access_token")
                UserDefaults.standard.setValue(result.refresh_token!, forKey: "refresh_token")
                
                return .success(data)
            } catch(let error){
                return .failure(error)
            }
        } catch(let error) {
            return .failure(error)
        }
    }
    
    
    func register(username: String, password: String) async -> Result<Data, Error> {
        
        do {
            let url = URL(string: "\(BASE_URL)/register")
            
            let body = AuthRequestBody(username: username, password: password)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.httpBody = try? JSONEncoder().encode(body)
            
            let (data, _) = try await URLSession.shared.data(for: request)

            return .success(data)
        } catch(let error) {
            return .failure(error)
        }
    }
}
