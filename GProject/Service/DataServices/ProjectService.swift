//
//  ProjectService.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Alamofire
import RxAlamofire
import RxSwift
import SwiftyJSON

class ProjectService: Service {
    
    static let shared = ProjectService()
    
    func postUploadFile(imageData: Data) -> Observable<Int> {
        
        let endpoint = ProjectEndpointCases.postUploadFile
        let jwt = TokenUtils.shared.readJwt()
        let headers: HTTPHeaders = ["Authorization": "Bearer \(jwt ?? "")"]
      
        return Observable<Int>.create({observer in
            
            AF.upload(multipartFormData: { multipartFormData in
                
                    multipartFormData.append(imageData, withName: "file", fileName: "file17.jpg", mimeType: "image/jpg")
            }, to: endpoint.path, method: .post, headers: headers)
            .responseJSON { (response) in
                    switch response.result {
                    case .success(let successData):
                        if let successData = successData as? [String: Any], let projectData = successData["data"] as? [String: Any], let id = projectData["imageFileId"] as? Int {
                            observer.onNext(id)
                        }

                    case .failure(let error):
                        print("multipart error: \(error)")
                    }
                }

            return Disposables.create()
        })
    }
    
    func getDownloadFileById() {
        let endpoint = ProjectEndpointCases.getDownloadFileById
        let request = makeRequest(endpoint: endpoint)
        
        
    }
    
    func postCreateProject(data: ProjectRequestData) -> Observable<CreateProjectResponse> {
        let endpoint = ProjectEndpointCases.postCreateProject(data: data)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> CreateProjectResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(CreateProjectResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return CreateProjectResponse()
            }
        
    }
    
    func getShowProjectList() -> Observable<AllProjectResponse> {
        let endpoint = ProjectEndpointCases.getShowProjectList
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> AllProjectResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(AllProjectResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return AllProjectResponse()
            }
    }
    
    func deleteProject() -> Observable<LoginResponse> {
        let endpoint = ProjectEndpointCases.deleteProject
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
    
    func getImageList() -> Observable<ImageListResponse> {
        let endpoint = ProjectEndpointCases.getImageList
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> ImageListResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(ImageListResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return ImageListResponse()
            }
    }
    
    func getOpenProject(projectId : Int) -> Observable<CoordinateModel> {
        let endpoint = ProjectEndpointCases.getOpenProject(projectId: projectId)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { res, data  ->  CoordinateModel in
                let json = JSON(data)
                var model = CoordinateModel(data: [],width: 1,height: 1, furnitures: [])
                var temp : [([Int],[Int])] = []
                
                let horizontal : Int = json["data"]["length"]["horizontal"].intValue
                let vertical : Int = json["data"]["length"]["vertical"].intValue
                
                print("json",json)
                for model in json["data"]["wall"].arrayValue {
                    let start = [model["startPoint"]["x"].intValue, model["startPoint"]["y"].intValue]
                    let end = [model["endPoint"]["x"].intValue, model["endPoint"]["y"].intValue]
                    temp.append((start, end))
                }
                
                var tempFurniture : [FurniturePostModel] = []
                
                for model in json["data"]["furnitures"].arrayValue {
                    tempFurniture.append(FurniturePostModel(name: model["name"].stringValue,
                                                            x: model["x"].doubleValue,
                                                            y: model["y"].doubleValue))
                }
                
                
                model = CoordinateModel(data: temp,width: horizontal,height : vertical,furnitures: tempFurniture)
                return model
            }
    }
    
    func getCheck3DModel(imageFileId: Int) -> Observable<Check3DModelResponse> {
        let endpoint = ProjectEndpointCases.getCheck3DModel(imageFileId: imageFileId)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> Check3DModelResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(Check3DModelResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return Check3DModelResponse()
            }

    }
    
    func postSaveProject(projectId : Int, furnitures : [FurniturePostModel]) -> Observable<Bool> {
        
        var furnitureValue : [[String : Any]] = []
        for f in furnitures {
            var temp : [String : Any] = [:]
            temp["name"] = f.name
            temp["x"] = f.x
            temp["y"] = f.y
            furnitureValue.append(temp)
        }
        
        let endpoint = ProjectEndpointCases.postSaveProject(projectId: projectId, furnitureValue: furnitureValue)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> Bool in
                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(SaveProjectResponse.self, from: resData)
                    return result.statusCode ?? 0 >= 200 && result.statusCode ?? 0 < 400
                    
                } catch {
                    print(error)
                }
                
                return false
            }
    }
    
}
