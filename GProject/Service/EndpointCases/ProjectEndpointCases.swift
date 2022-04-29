//
//  ProjectEndpointCases.swift
//  GProject
//
//  Created by 서정 on 2022/04/25.
//

import Foundation

enum ProjectEndpointCases: EndPoint {
    case postUploadFile
    case getDownloadFileById
    case postCreateProject(data: ProjectRequestData)
    case getShowProjectList
    case deleteProject
    case getImageList
    case getOpenProject(projectId : Int)
    case getCheck3DModel(imageFileId: Int)
    case postSaveProject(projectId : Int, furnitureValue : [[String : Any]])
}

extension ProjectEndpointCases {
    var httpMethod: String {
        switch self {
        case .postUploadFile:
            return "GET"
        case .getDownloadFileById:
            return "GET"
        case .postCreateProject:
            return "POST"
        case .getShowProjectList:
            return "GET"
        case .deleteProject:
            return "DELETE"
        case .getImageList:
            return "GET"
        case .getOpenProject:
            return "GET"
        case .getCheck3DModel:
            return "GET"
        case .postSaveProject:
            return "POST"
        }
    }
}


extension ProjectEndpointCases {
    var baseURLString: String {
        return "http://192.168.0.114:8080"
    }
}

extension ProjectEndpointCases {
    var path: String {
        switch self {
        case .postUploadFile:
            return baseURLString + "/post/uploadFile"
        case .getDownloadFileById:
            return baseURLString + "/post/3/files"
        case .postCreateProject:
            return baseURLString + "/project/new"
        case .getShowProjectList:
            return baseURLString + "/project/findAll"
        case .deleteProject:
            return baseURLString + "/project/1/delete"
        case .getImageList:
            return baseURLString + "/image/list"
        case .getOpenProject(let projectId):
            return baseURLString + "/project/\(projectId)/open"
        case .getCheck3DModel(let imageFileId):
            return baseURLString + "/check/\(imageFileId)/exist"
        case .postSaveProject:
            return baseURLString + "/project/save"
        }
    }
}

extension ProjectEndpointCases {
    var headers: [String: Any]? {
        guard let token = TokenUtils.shared.readJwt() else {
            return nil
        }

        return [
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer \(token)"
        ]
    }
}

extension ProjectEndpointCases {
    var body: [String : Any]? {
        switch self {
        case .postUploadFile:
            return [:]
        case .postCreateProject(let data):
            return [
                "name": data.projectName ?? "",
                "imageFileId": data.projectId ?? ""
            ]
        case .postSaveProject(let projectId, let furnitureValue):
            return [
                "projectId": projectId,
                "furnitures" : furnitureValue
            ]
        default:
            return [:]
        }
    }
}
