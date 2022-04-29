//
//  User.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation

//Request
struct LoginRequestDTO: Codable {
    var email: String?
    var password: String?
}

//Response

struct UserInfoResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: UserData?
}

struct LoginResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: JWTToken?
}

struct WithdrawalResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: String?
}

struct CheckPasswordResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: String?
}

struct UpdateUserResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: UserInfo?
}


struct JWTToken: Codable {
    var token: String?
}

struct UserInfo: Codable {
    var nickname: String?
    var birth: String?
}

struct UserId: Codable {
    var id: CLong?
}


struct UserData: Codable {
    var email: String?
    var nickname: String?
    var birth: String?
    var authorities: [AuthorityName]?
}

struct AuthorityName: Codable {
    var authorityName: String?
}



