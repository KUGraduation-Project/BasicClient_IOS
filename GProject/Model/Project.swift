//
//  Board.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import SwiftyJSON

//Request


//Response
struct AllProjectResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: [ProjectListObjectData]?
}

struct DeleteProjectResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: String?
}

struct OpenProjectResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: ProjectDetailNumber?
}

struct CreateProjectResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: CreateProjectData?
}

struct Check3DModelResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: Check3DProjectData?
}

struct ImageListResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: [ImageListData]?
}

struct SaveProjectResponse: Decodable {
    var statusCode: Int?
    var responseMessage: String?
    var data: Int?
}


///////

struct Check3DProjectData: Decodable {
    var projectDto: ProjectDetailNumber?
    var modelExist: Bool?
}


struct ProjectDetailNumber: Decodable {
    var length: LengthData?
    var wall: [StartEndPointData]?
    //TODO
    var furnitures: String?
}



struct LengthData: Decodable {
    var horizontal: Double?
    var vertical: Double?
}

struct StartEndPointData: Decodable {
    var startPoint: Point?
    var endPoint: Point?
}

struct Point: Decodable {
    var x: Double?
    var y: Double?
}

struct ProjectData: Codable {
    var fileDownloadUri: String?
    var fileName: String?
    var fileType: String?
    var imageFileId: Int?
    var size: CLong?
}

struct ProjectRequestData: Codable {
    var projectId: Int?
    var projectName: String?
}

struct ProjectResultData: Codable {
    var name: String?
    var createdTime: String?
}

struct ProjectListObjectData: Codable {
    var projectId: Int?
    var name: String?
    var date: String?
    var imageFileUri: String?
    var imageFileId: Int?
    
}
struct ImageListData : Codable {
    var imageFileId : Int?
    var url : String?
}

struct CheckProjectData : Codable {
    var isModelExist: Bool?
    var model: String?
}

struct CreateProjectData : Codable {
    var isModelExist: Bool?
    var name: String?
    var createdTime: String?
    var model: String?
    var projectId: CLong?
}

struct Model: Codable {
    
}

struct CoordinateModel {
    var coordinates : [([Int],[Int])] = []
    var width : CGFloat
    var height : CGFloat
    var furnitures : [FurniturePostModel]
    
    
    
    init(data : [([Int], [Int])], width : Int, height : Int, furnitures : [FurniturePostModel] ){
        self.coordinates = data
        self.width = width == 0 ? 1.0 : CGFloat(width)
        self.height = height == 0 ? 1.0 : CGFloat(height)
        self.furnitures = furnitures
    }
    

    
}


struct FurniturePostModel : Decodable {
    var name : String
    var x : Double
    var y : Double
}
