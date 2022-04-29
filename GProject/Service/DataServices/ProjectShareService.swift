//
//  ProjectShareService.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Alamofire
import RxAlamofire
import RxSwift

class ProjectShareService: Service {
    
    static let shared = ProjectShareService()
    
    func getShowNeighborProject(neighborId: Int) -> Observable<AllProjectResponse> {
        let endpoint = ProjectShareEndpointCases.getShowNeighborProject(neighborId: neighborId)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> AllProjectResponse  in
                print(http)

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(AllProjectResponse.self, from: resData)
                    
                    print(result)
                    return result
                } catch {
                    print(error)
                }

                return AllProjectResponse()
            }
    }
    
    func getDownloadProject(projectId: Int) -> Observable<DeleteProjectResponse> {
        let endpoint = ProjectShareEndpointCases.getDownloadProject(projectId: projectId)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> DeleteProjectResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(DeleteProjectResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return DeleteProjectResponse()
            }
    }
}
