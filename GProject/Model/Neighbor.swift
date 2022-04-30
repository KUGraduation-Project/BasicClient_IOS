//
//  Neighbor.swift
//  GProject
//
//  Created by 서정 on 2022/04/28.
//

import Foundation


//Response
struct SearchNeighborResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: [Neighbor]?
}

struct ApplyNeighborResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: String?
}

struct NeighborListResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: [NeighborDetail]?
}

struct DeleteNeighborResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: [NeighborDetail]?
}

struct ApproveNeighborResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: [NeighborDetail]?
}

//
struct Neighbor: Decodable {
    var nickname: String?
    var userId: Int?
}

struct NeighborDetail: Codable {
    var nickname: String?
    var neighborId: Int?
    var userId: Int?
    var isApprove: Bool?
}
