//
//  UserEndpointCases.swift
//  GProject
//
//  Created by 서정 on 2022/04/25.
//

import Foundation

enum UserEndpointCases: EndPoint {
    case postSignUp
    case postGetToken(user: LoginRequestDTO)
    case getUserInfo
    case deleteWithdrawal
    case putUpdateUserInfo
    case postCheckCorrectPassword
}

extension UserEndpointCases {
    var httpMethod: String {
        switch self {
        case .postSignUp:
            return "POST"
        case .postGetToken:
            return "POST"
        case .getUserInfo:
            return "GET"
        case .deleteWithdrawal:
            return "DELETE"
        case .putUpdateUserInfo:
            return "PUT"
        case .postCheckCorrectPassword:
            return "POST"
        }
    }
}

extension UserEndpointCases {
    var baseURLString: String {
        return "http://192.168.0.114:8080/api"
    }
}

extension UserEndpointCases {
    var path: String {
        switch self {
        case .postSignUp:
            return baseURLString + "/signup"
        case .postGetToken:
            return baseURLString + "/authenticate"
        case .getUserInfo:
            return baseURLString + "/user"
        case .deleteWithdrawal:
            return baseURLString + "/withdrawal"
        case .putUpdateUserInfo:
            return baseURLString + "/update"
        case .postCheckCorrectPassword:
            return baseURLString + "/check/password"
        }
    }
}

extension UserEndpointCases {
    var headers: [String : Any]? {
        guard let token = TokenUtils.shared.readJwt()
        else {
            return nil
        }

        return [
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer \(token)"
        ]
    }
}

extension UserEndpointCases {
    var body: [String : Any]? {
        switch self {
        case .postSignUp:
            return [
                    "email" : "aaa@naver.com",
                    "password" : "aaapassword",
                    "nickname" : "haewonnickname",
                    "birth" : "2021-09-09"
                ]
        case .postGetToken(let user):
            return [
                "email" : user.email ?? "",
                "password" : user.password ?? "" 
            ]
        case .putUpdateUserInfo:
            return [
                    "currentPassword" : "aaapassword",
                    "newPassword" : "newpassword",
                    "nickname" : "updateNickname",
                    "birth" : "1999-09-09"
            ]
        case .postCheckCorrectPassword:
            return [
                    "password" : "aaapassword"
            ]
            
        default: return [:]
        }
    }
}
