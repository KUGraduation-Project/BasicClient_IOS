//
//  DataService.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

import SwiftyJSON



class DataService: DataServiceType {

    
    let BASE_URL = "http://3.38.95.177:8080"
    var urlString: String!
    let disposeBag = DisposeBag()
    let tk = TokenUtils()
    
    
    func addUser(userInfo: UserInfo) -> Observable<Bool> {
        urlString = BASE_URL.appending("/api/signup")
        
        var request = URLRequest(url: URL(string: urlString)!)
        var params : Any

        
        params = ["email": "userInfo", "password": "password", "nickname": "nickname","birth": "birth"]
    
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .debug()
            .map{ (http, data) -> Bool in
                if http.statusCode >= 200 && http.statusCode < 400, let registerResponse = try? JSONDecoder().decode(UserInfoResponse.self, from: data) {
                    if registerResponse.data?.email?.count ?? 0 > 0 {
                        return true
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
            }
            
        }
            
            
    
//    func loginUser(userInfo: UserInfo) -> Observable<Bool> {
//        urlString = BASE_URL.appending("/api/authenticate")
//        var params: Any
//        params = ["email": userInfo.email, "password": userInfo.password]
//
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.timeoutInterval = 10
//
//        do {
//            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
//        } catch {
//            print("http Body Error")
//        }
//
//        return RxAlamofire.request(request as URLRequestConvertible)
//            .responseString()
//            .asObservable()
//            .map { res, str -> Bool in
//                if let loginRes = try? JSONDecoder().decode(LoginResponseData.self, from: str.data(using: .utf8)!) {
//
//                    print("loginRes",loginRes.data.token)
//                    self.tk.createJwt(value: loginRes.data.token)
//
//                    return true
//                } else {
//                    return false
//                }
//            }
//    }
//
//    func getMe() -> Observable<UserData> {
//        urlString = BASE_URL.appending("/api/user")
//
//        let jwt = tk.readJwt()
//        guard let jwt = jwt else {
//            print("JWT NIL")
//            return Observable.just(UserData(email: "", nickname: "", birth: "", authorities: []))
//        }
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
//        request.timeoutInterval = 10
//
//
//        return RxAlamofire
//            .request(request as URLRequestConvertible)
//            .responseString()
//            .asObservable()
//            .map { (res, str) -> UserData in
//
//                if let userRes = try? JSONDecoder().decode(RegisterResponse.self, from: str.data(using: .utf8)!) {
//
//                    return userRes.data
//                }
//                //에러 리턴해야함
//                print("Error..")
//                return UserData(email: "", nickname: "", birth: "", authorities: [])
//            }
//    }
    
//    func postImage(imageData: Data) -> Observable<Int> {
//
//        urlString = BASE_URL.appending("/post/uploadFile")
//        let jwt = tk.readJwt()
//        guard let jwt = jwt else {
//            print("JWT NIL")
//            return Observable.just(0)
//        }
//
//        return Observable<Int>.create({observer in
//            let headers: HTTPHeaders = ["Authorization": "Bearer \(jwt)"]
//
//            AF.upload(multipartFormData: { multipartFormData in
//
//                    multipartFormData.append(imageData, withName: "file", fileName: "file17.jpg", mimeType: "image/jpg")
//            }, to: self.urlString, method: .post, headers: headers)
//            .responseJSON { (response) in
//                    switch response.result {
//                    case .success(let successData):
//                        if let successData = successData as? [String: Any], let projectData = successData["data"] as? [String: Any], let id = projectData["imageFileId"] as? Int {
//                            observer.onNext(id)
//                        }
//
//                    case .failure(let error):
//                        print("multipart error: \(error)")
//                    }
//                }
//
//            return Disposables.create()
//        })
//    }
    
//    func postProjectInfo(data: ProjectRequestData) -> Observable<CreateProjectData> {
//        urlString = BASE_URL.appending("/project/new")
//        let jwt = tk.readJwt()
//        guard let jwt = jwt else {
//            print("JWT NIL")
//            return Observable.just(CreateProjectData(isModelExist: false, name: "", createdTime: "", model: nil, projectId: 0))
//        }
//
//        var params: Any
//        params = ["name": data.projectName, "imageFileId": data.projectId]
//
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
//
//        do {
//            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
//        } catch {
//            print("http Body Error")
//        }
//
//        return RxAlamofire.request(request as URLRequestConvertible)
//            .responseJSON()
//            .asObservable()
//            .map { response -> CreateProjectData in
//
//                if let result = response.value {
//                    let json = result as! NSDictionary
//                    let temp = json["data"] as! NSDictionary
//
//                    let createdProjectDto = temp["createdProjectDto"] as! NSDictionary
//
//                    return CreateProjectData(
//                        isModelExist: (temp["modelExist"]) as! Bool,
//                      name: createdProjectDto["name"] as! String,
//                      createdTime: createdProjectDto["createdTime"] as! String,
//                        model: createdProjectDto["model"] as? String,
//                      projectId: createdProjectDto["projectId"] as! Int)
//
//                }
//
//                return CreateProjectData(isModelExist: false, name: "", createdTime: "", model: nil, projectId: 0)
//
//            }
//    }
    
//    func getAllProject() -> Observable<[ProjectListObjectData]> {
//        urlString = BASE_URL.appending("/project/findAll")
//        let jwt = tk.readJwt()
//        guard let jwt = jwt else {
//            print("JWT NIL")
//            return Observable.of([])
//        }
//
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
//        request.timeoutInterval = 10
//
//        return RxAlamofire.request(request as URLRequestConvertible)
//            .responseData()
//            .asObservable()
//            .map { res, str -> [ProjectListObjectData] in
//                print("findall",str)
//
//                let json = JSON(str)
//                var temp : [ProjectListObjectData] = []
//
//                for model in json["data"].arrayValue {
//                    temp.append(ProjectListObjectData(projectId: model["projectId"].intValue,
//                                                      name: model["name"].stringValue,
//                                                      date: model["date"].stringValue,
//                                                      imageFileUri: model["imageFileUri"].stringValue,
//                                                      imageFileId: model["imageFileId"].intValue))
//                }
//                return temp
//            }
//
//    }
    
    
    
    
//    func getImageList() -> Observable<[ImageListData]> {
//        urlString = BASE_URL.appending("/image/list")
//        let jwt = tk.readJwt()
//        guard let jwt = jwt else {
//            print("JWT NIL")
//            return Observable.just([])
//        }
//
//        var params: Any
//        params = [ : ]
//        print(params)
//
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
//        request.timeoutInterval = 5
//
//
//        return RxAlamofire.request(request as URLRequestConvertible)
//            .responseData()
//            .asObservable()
//            .map { res, data  -> [ImageListData] in
//                let json = JSON(data)
//                print("json",json)
//                var temp : [ImageListData] = []
//
//                for model in json["data"].arrayValue {
//                    temp.append(ImageListData(imageFileId: model["imageFileId"].intValue,
//                                              url: model["url"].stringValue))
//                }
//                return temp
//            }
//    }
    
    func withdrawal() -> Observable<Bool> {
        urlString = BASE_URL.appending("/api/withdrawal")
        let jwt = tk.readJwt()
        guard let jwt = jwt else {
            print("JWT NIL")
            return Observable.just(false)
        }
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 5
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { res, data  -> Bool in
                // 나중에 추가 데이터 처리...
                // let json = JSON(data)
                
                if res.statusCode == 200 {
                    return true
                } else {
                    return false
                }
            }
        
        
    }
    
//    func getProjectDetail(projectId : Int) -> Observable<CoordinateModel> {
//        urlString = BASE_URL.appending("/project/\(projectId)/open")
//
//
//        let jwt = tk.readJwt()
//        guard let jwt = jwt else {
//            print("JWT NIL")
//            return Observable.just(CoordinateModel(data: [],width: 1,height: 1, furnitures: []))
//        }
//
//        var params: Any
//        params = [ : ]
//
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
//        request.timeoutInterval = 5
//
//        return RxAlamofire.request(request as URLRequestConvertible)
//            .responseData()
//            .asObservable()
//            .map { res, data  ->  CoordinateModel in
//                let json = JSON(data)
//                var model = CoordinateModel(data: [],width: 1,height: 1, furnitures: [])
//                var temp : [([Int],[Int])] = []
//
//                let horizontal : Int = json["data"]["length"]["horizontal"].intValue
//                let vertical : Int = json["data"]["length"]["vertical"].intValue
//
//                print("json",json)
//                for model in json["data"]["wall"].arrayValue {
//                    let start = [model["startPoint"]["x"].intValue, model["startPoint"]["y"].intValue]
//                    let end = [model["endPoint"]["x"].intValue, model["endPoint"]["y"].intValue]
//                    temp.append((start, end))
//                }
//
//                var tempFurniture : [FurniturePostModel] = []
//
//                for model in json["data"]["furnitures"].arrayValue {
//                    tempFurniture.append(FurniturePostModel(name: model["name"].stringValue,
//                                                            x: model["x"].doubleValue,
//                                                            y: model["y"].doubleValue))
//                }
//
//
//                model = CoordinateModel(data: temp,width: horizontal,height : vertical,furnitures: tempFurniture)
//                return model
//            }
//
//
//    }
    
//    func saveProject(projectId : Int,furnitures : [FurniturePostModel]) -> Observable<Bool> {
//        
//        urlString = BASE_URL.appending("/project/save")
//        let jwt = tk.readJwt()
//        guard let jwt = jwt else {
//            print("JWT NIL")
//            return Observable.just(false)
//        }
//        
//        var furnitureValue : [[String : Any]] = []
//        for f in furnitures {
//            var temp : [String : Any] = [:]
//            temp["name"] = f.name
//            temp["x"] = f.x
//            temp["y"] = f.y
//            furnitureValue.append(temp)
//        }
//        let param: Parameters = ["projectId": projectId, "furnitures" : furnitureValue ]
//        print("param",param)
//        let header : HTTPHeaders = ["Content-Type" : "application/json" , "Authorization" : "Bearer \(jwt)" ]
//      
//        return RxAlamofire.request(.post, urlString, parameters: param, encoding: JSONEncoding.default, headers: header, interceptor: nil)
//            .responseData()
//            .asObservable()
//            .map { res, data  ->  Bool in
//                let json = JSON(data)
//                print(json)
//                return json["statusCode"].intValue >= 200 && json["status"].intValue < 400
//            }
//        
//        
//    }
    
//    func check3dModel(imageFileId: Int) -> Observable<CheckProjectData> {
//        urlString = BASE_URL.appending("/check/\(imageFileId)/exist")
//
//        let jwt = tk.readJwt()
//        guard let jwt = jwt else {
//            print("JWT NIL")
//            return Observable.just(CheckProjectData(isModelExist: false, model: "모델링중.."))
//        }
//
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
//        request.timeoutInterval = 10
//
//
//        return RxAlamofire
//            .request(request as URLRequestConvertible)
//            .responseJSON()
//            .asObservable()
//            .map { response -> CheckProjectData in
//
//                if let result = response.value {
//                    let json = result as! NSDictionary
//                    print(json)
//                    let temp = json["data"] as! NSDictionary
//
////                    let projectDto = temp["projectDto"] as! NSDictionary
//
//                    return CheckProjectData(isModelExist: temp["modelExist"] as! Bool, model: temp["projectDto"] as? String)
//
//                }
//
//                return CheckProjectData(isModelExist: false, model: "모델링중...")
//            }
//
//    }
//
}

