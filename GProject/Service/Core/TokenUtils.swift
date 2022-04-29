//
//  KeyChainService.swift
//  GProject
//
//  Created by 서정 on 2021/07/20.
//

import Foundation


class TokenUtils {
    
    static let shared = TokenUtils()
    
    func createJwt(value: String) {
        let keyChainQuery: NSDictionary = [
                   kSecClass : kSecClassGenericPassword,
                   kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!
               ]
        
        SecItemDelete(keyChainQuery)
        
        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
                assert(status == noErr, "failed to saving Token")
    }
    
    func readJwt() -> String? {
        let KeyChainQuery: NSDictionary = [
                   kSecClass: kSecClassGenericPassword,
            kSecReturnData: kCFBooleanTrue!, // CFData타입으로 불러오라는 의미
                   kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우 하나의 값만 가져오라는 의미
               ]
        
        // Read
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(KeyChainQuery, &dataTypeRef)
        
        // Read 성공 및 실패한 경우
        if(status == errSecSuccess) {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else {
            print("failed to loading, status code = \(status)")
            return nil
        }
    }
    
    // Delete
    func delete() {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
        ]
        
        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
