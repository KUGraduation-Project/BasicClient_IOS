//
//  UserService.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Alamofire
import RxAlamofire
import RxSwift

class UserService: Service {
    
    static let shared = UserService()
    
    func postSignUp() -> Observable<UserInfoResponse> {
        let endpoint = UserEndpointCases.postSignUp
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> UserInfoResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(UserInfoResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return UserInfoResponse()
            }
    }
    
    func postGetToken(user: LoginRequestDTO) -> Observable<LoginResponse> {
        let endpoint = UserEndpointCases.postGetToken(user: user)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> LoginResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(LoginResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return LoginResponse()
            }
        
    }
    
    func getUserInfo() -> Observable<UserInfoResponse> {
        let endpoint = UserEndpointCases.getUserInfo
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> UserInfoResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(UserInfoResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return UserInfoResponse()
            }
    }
    
    func deleteWithdrawal() -> Observable<WithdrawalResponse> {
        let endpoint = UserEndpointCases.deleteWithdrawal
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> WithdrawalResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(WithdrawalResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return WithdrawalResponse()
            }
    }
    
    func putUpdateUserInfo() -> Observable<UpdateUserResponse> {
        let endpoint = UserEndpointCases.putUpdateUserInfo
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> UpdateUserResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(UpdateUserResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return UpdateUserResponse()
            }
    }
    
    func postCheckCorrectPassword() -> Observable<CheckPasswordResponse> {
        let endpoint = UserEndpointCases.postCheckCorrectPassword
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> CheckPasswordResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(CheckPasswordResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return CheckPasswordResponse()
            }
    }
}
