//
//  NeighborService.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Alamofire
import RxAlamofire
import RxSwift

class NeighborService: Service {
    
    static let shared = NeighborService()
    
    func getSearchNeighbor(nickname: String) -> Observable<SearchNeighborResponse> {
        let endpoint = NeighborEndpointCases.getSearchNeighbor(nickname: nickname)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> SearchNeighborResponse  in
                print(http)
                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(SearchNeighborResponse.self, from: resData)
                    print(result)
                    return result
                } catch {
                    print(error)
                }

                return SearchNeighborResponse()
            }
    }
    
    func getNeighborList() -> Observable<NeighborListResponse> {
        let endpoint = NeighborEndpointCases.getNeighborList
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> NeighborListResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(NeighborListResponse.self, from: resData)
                    
                    print(result)
                    return result
                } catch {
                    print(error)
                }

                return NeighborListResponse()
            }
    }
    
    func getNeighborApplicationList() -> Observable<NeighborListResponse> {
        let endpoint = NeighborEndpointCases.getNeighborApplicationList
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> NeighborListResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(NeighborListResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return NeighborListResponse()
            }
    }
    
    func postRequestNeighbor(neighbor: Neighbor) -> Observable<ApplyNeighborResponse> {
        let endpoint = NeighborEndpointCases.postRequestNeighbor(neighbor: neighbor)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> ApplyNeighborResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(ApplyNeighborResponse.self, from: resData)
                    return result
                } catch {
                    print(error)
                }

                return ApplyNeighborResponse()
            }
    }
    
    func deleteNeighbor(neighborId: Int) -> Observable<DeleteNeighborResponse> {
        let endpoint = NeighborEndpointCases.deleteNeighbor(neighborId: neighborId)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> DeleteNeighborResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(DeleteNeighborResponse.self, from: resData)
                    print(result)
                    return result
                } catch {
                    print(error)
                }

                return DeleteNeighborResponse()
            }
    }
    
    func postApproveNeighbor(neighborDetail: NeighborDetail) -> Observable<ApproveNeighborResponse> {
        let endpoint = NeighborEndpointCases.postApproveNeighbor(neighborDetail: neighborDetail)
        let request = makeRequest(endpoint: endpoint)
        
        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { http, resData -> ApproveNeighborResponse  in

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(ApproveNeighborResponse.self, from: resData)
                    print(result)
                    return result
                } catch {
                    print(error)
                }

                return ApproveNeighborResponse()
            }
    }
    
}
