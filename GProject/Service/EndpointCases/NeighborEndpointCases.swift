//
//  NeighborEndpointCases.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Foundation

enum NeighborEndpointCases: EndPoint {
    case getSearchNeighbor(nickname: String)
    case getNeighborApplicationList
    case getNeighborList
    case postRequestNeighbor(neighbor: Neighbor)
    case deleteNeighbor(neighborId: Int)
    case postApproveNeighbor(neighborDetail: NeighborDetail)
}

extension NeighborEndpointCases {
    var httpMethod: String {
        switch self {
        case .getSearchNeighbor:
            return "GET"
        case .getNeighborApplicationList:
            return "GET"
        case .getNeighborList:
            return "GET"
        case .postRequestNeighbor:
            return "POST"
        case .deleteNeighbor:
            return "DELETE"
        case .postApproveNeighbor:
            return "POST"
        }
    }
}

extension NeighborEndpointCases {
    var baseURLString: String {
        return "http://192.168.0.114:8080/neighbor"
    }
}

extension NeighborEndpointCases {
    var path: String {
        switch self {
        case .getSearchNeighbor(let nickname):
            return baseURLString + "/\(nickname)/search"
        case .getNeighborList:
            return baseURLString + "/list"
        case .getNeighborApplicationList:
            return baseURLString + "/application/list"
        case .postRequestNeighbor:
            return baseURLString + "/request"
        case .deleteNeighbor(let neighborId):
            return baseURLString + "/\(neighborId)/delete"
        case .postApproveNeighbor:
            return baseURLString + "/approve"
        }
    }
}

extension NeighborEndpointCases {
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

extension NeighborEndpointCases {
    var body: [String : Any]? {
        switch self {
        case .postRequestNeighbor(let neighbor):
            return [
                "nickname" : neighbor.nickname ?? "" ,
                "userId" : neighbor.userId ?? 0
            ]
        case .postApproveNeighbor(let neighborDetail):
            return [
                "nickname" : neighborDetail.nickname ?? "" ,
                "neighborId" : neighborDetail.neighborId ?? 0,
                "userId" : neighborDetail.userId ?? 0,
                "isApprove" : neighborDetail.isApprove ?? false
            ]
        default: return [:]
        }
    }
}
