//
//  jwtAuthClientModel.swift
//  jwt-auth-client
//
//  Created by Nevertheless Good on 2022/04/19.
//

import Foundation

let BASE_URL = "http://127.0.0.1:8080"

let QUERY_COUNT = 10

var ACCESS_TOKEN_EXPIRE = Date()
var REFRESH_TOKEN_EXPIRE = Date()

struct AuthRequestBody: Codable {
    let username: String
    let password: String
}

struct SaveContnetBody: Codable {
    let title: String
    let detail: String
}

struct ResponseUpdateToken: Codable {
    let access_token: String?
}

struct ResponseLogin: Codable {
    let access_token: String?
    let refresh_token: String?
    let detail: String?
}

struct ResponseRegister: Codable {
    let username: String?
    let id: Int?
    let is_active: Bool?
    let detail: String?
}

struct ResponseTitleLists: Identifiable, Codable {
    var id: Int
    var title: String
    var username: String
    var date_last_updated: String
}

struct ResponseDetail: Codable {
    var detail: String
}

struct ResponsePost: Codable {
    let title: String?
    let detail: String?
}
