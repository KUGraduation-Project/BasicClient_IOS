//
//  EndPoint.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Alamofire

protocol EndPoint {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: Any]? { get }
    var body: [String: Any]? { get}
}

extension EndPoint {
    var url: String {
        let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedStr
    }
}

