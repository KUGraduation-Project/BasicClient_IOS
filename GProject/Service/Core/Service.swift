//
//  Service.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//
import Foundation

class Service {

    func makeRequest(endpoint: EndPoint) -> URLRequest {

        let url = URL(string: endpoint.url)!
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        endpoint.headers?.forEach({ header in
            request.setValue(header.value as? String, forHTTPHeaderField: header.key)
        })
        if let body = try endpoint.body {
            if !body.isEmpty {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            }
        }

        return request
    }
}
