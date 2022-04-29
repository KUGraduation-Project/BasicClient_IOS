//
//  ARViewModel.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import ARKit






class ARViewModel: NSObject {

    //datas
    private var furnitureDatasToPost :  [FurniturePostModel] = [] // -> 현재 추가한 가구 서버에서 내려받은 가구 다 합쳐서 올려야함
    private var projectId : Int = 0
    
    //input
    var furnitureInput = PublishSubject<(name : String, point : CGPoint)>() //-> 현재 추가하려는 가구
    
    
    
    //output
    struct walls2Model {
        var wall : [SCNNode]
    }
    lazy var randomcolors : [UIColor] = {
        var colors : [UIColor] = []
        for _ in 0...200 {
            colors.append(self.getRandomColor())
        }
        
        return colors
    }()
    var walls2 = BehaviorRelay<walls2Model>.init(value: walls2Model(wall: []))
    var coordinates = BehaviorRelay<[[CGPoint]]>(value: []) // -> 우상단 이미지 위한것
    var furnitureOutPut = BehaviorRelay<[(point : CGPoint,object : VirtualObject)]>(value: []) //-> 서버에서 내려받은 가구
    
    
    
    private var service : DataServiceType!
    
    var disposebag = DisposeBag()
    
    weak var coordinator : ViewCoordinator?
    
    
    init(service : DataServiceType = DataService()) {
        
        self.service = service
        super.init()
        furnitureInput
            .subscribe(onNext : { [unowned self] data in
                furnitureDatasToPost.removeAll(where: { $0.name == data.name })
                furnitureDatasToPost.append(FurniturePostModel(name: data.name, x: Double(data.point.x), y: Double(data.point.y)))
               
            })
            .disposed(by: disposebag)
    }
    
    
    
    func getCoordinates(projectId : Int) -> Observable<([([Int],[Int])],height : CGFloat, width : CGFloat)> {
        self.projectId = projectId
        
        return ProjectService.shared.getOpenProject(projectId: projectId)
            .map{ [unowned self] data -> ([([Int],[Int])],height : CGFloat, width : CGFloat) in
                if data.coordinates.count == 0 {
                    coordinator?.goback()
                    return ([],-1,-1)
                }
                
                print("width",data.width)
                print("height",data.height)
                if data.width <= 100 {
                    coordinator?.goback()
                    return ([],-1,0)
                }
                if data.height <= 100 {
                    coordinator?.goback()
                    return ([],0,-1)
                }
                
                
                
                //우상단 이미지
                var widthScalefactor : CGFloat = 1
                var heightScalefactor : CGFloat = 1
                let maxX : CGFloat = CGFloat(data.coordinates.map{ Double($0.0[0]) }.max() ?? 100.0)
                widthScalefactor = maxX <= 200 ? 1 : 200 / maxX
                let maxy : CGFloat = CGFloat(data.coordinates.map{ Double($0.0[1]) }.max() ?? 100.0)
                heightScalefactor = maxy <= 200 ? 1 : 200 / maxy
                let coordArray = data.coordinates.map{ [CGPoint(x : (CGFloat($0.0[0]) * widthScalefactor)  , y : (CGFloat($0.0[1]) * heightScalefactor ) ) ,
                                                        CGPoint(x : (CGFloat($0.1[0]) * widthScalefactor) , y : (CGFloat($0.1[1]) * heightScalefactor) )]}
                
                
                var tempcoord : [[CGPoint]] = []
                for index in 0...coordArray.count - 1 {
                    tempcoord.append(coordArray[index])
                }
                self.coordinates.accept(tempcoord)
                
                //실제 3d 모델링
                var temp :[([Int],[Int])] = []
                
                for index in 0...data.coordinates.count - 1 {
                    temp.append(data.coordinates[index])
                }
                
                //가구 배치
                var tempFurnitures : [(CGPoint,VirtualObject)] = []
                for object in VirtualObject.availableObjects {
                    for furniture in data.furnitures {
                        if object.modelName == furniture.name {
                            tempFurnitures.append((CGPoint(x: furniture.x, y: furniture.y), object))
                            furnitureDatasToPost.append(FurniturePostModel(name: furniture.name, x: furniture.x, y: furniture.y))
                        }
                    }
                }
                
                furnitureOutPut.accept(tempFurnitures)
                return (temp,data.width,data.height)
            }
    }
    
    
    
    func showObjectSelectionViewController(){
//        coordinator?.showObjectselectionViewController()
    }
    
    func setUpScene(data : [([Int],[Int])],width : CGFloat, height : CGFloat) {
        
        print("data.count",data.count)
        
        
        var maxX : CGFloat = CGFloat(data.map{ Double($0.0[0]) }.max() ?? 100.0)
        maxX = maxX <= 1 ? 1 : maxX
        var maxy : CGFloat = CGFloat(data.map{ Double($0.0[1]) }.max() ?? 100.0)
        maxy = maxy <= 1 ? 1 : maxy
        
        let widthScale : CGFloat = width / 1000
        let heightScale : CGFloat = height / 1000
        var walls : [SCNNode] = []
        
        for (index, coords) in data.enumerated() {
            let firstPoint = CGPoint(x: (CGFloat(coords.0[0]) / maxX) * widthScale,
                                     y: (CGFloat(coords.0[1]) / maxy) * heightScale).clean
            let lastPoint = CGPoint(x: (CGFloat(coords.1[0]) / maxX) * widthScale,
                                    y: (CGFloat(coords.1[1]) / maxy) * heightScale).clean
            let midPoint = self.calculateMidPoint(lhs: firstPoint, rhs: lastPoint)
            let length = self.calculateLength(lhs: firstPoint, rhs: lastPoint)
            let incline : CGFloat = self.calculateIncline(lhs: firstPoint, rhs: lastPoint)
            
            let wall = createdMyBox(isDoor: false,length: length,color: self.randomcolors[index])
            
            wall.worldPosition = SCNVector3.init(midPoint.x - (0.5 * widthScale), 0, midPoint.y - (1 * heightScale))
            wall.eulerAngles = SCNVector3.init(0, incline.degreesToRadians, 0)
            
            
            
            walls.append(wall)
        }
        
        
        self.walls2.accept(walls2Model(wall: walls))
        
    }
    
    
    func uploadFurnitures(){
        print("uploadFurnitures pressed")
        
        ProjectService.shared.postSaveProject(projectId: projectId, furnitures: self.furnitureDatasToPost)
            .subscribe(onNext : { done in
                if done {
                    ToastView.shared.short(txt_msg: "가구가저장 되었습니다.")
                }
                else {
                    ToastView.shared.short(txt_msg: "잠시 후 시도해주세요")
                }
                
            })
            .disposed(by: disposebag)
    }
    
    
}
extension ARViewModel {
    
    
    private func calculateMidPoint(lhs : CGPoint , rhs : CGPoint) -> CGPoint {
        
        let x = (lhs.x + rhs.x)/2
        
        let y = (lhs.y + rhs.y)/2
        
        return CGPoint(x: x, y: y)
    }
    
    private func calculateLength(lhs  : CGPoint, rhs : CGPoint) -> CGFloat {
//
//        print("(lhs.x - rhs.x)",(lhs.x - rhs.x))
//        print("(lhs.y - rhs.y )",(lhs.y - rhs.y ))
        return sqrt( ((lhs.x - rhs.x)*(lhs.x - rhs.x)) +  ((lhs.y - rhs.y )*(lhs.y - rhs.y)) )
        
    }
    
    func calculateIncline(lhs : CGPoint, rhs : CGPoint) -> CGFloat {
        
        
        let originX = rhs.x - lhs.x
        let originY = rhs.y - lhs.y
//        print("originX",originX)
//        print("originY",originY)
        
        if abs(originX) <= 0.1 && abs(originY) <= 0.1 {
            if abs(originX) > abs(originY) {
                 return 90
            }
            else {
                return 0
            }
        }
        if abs(originX) <= 0.1  {
            return 0
        }
        if abs(originY) <= 0.1 {
            return 90
        }

        let bearingRadians = atan2f(Float(originY), Float(originX))
//        print("bearingRadians",bearingRadians)
        let bearingDegrees = CGFloat(bearingRadians).radiansToDegree
//        print("bearingDegrees",bearingDegrees)
//        while bearingDegrees < 0 {
//            bearingDegrees += 360
//        }

        
        return bearingDegrees
    }
    
   
    
    
    
    
    
    
    
    private func findFirstTwoPoint(a : CGFloat, b : CGFloat, c : CGFloat) -> (left : CGPoint, right : CGPoint) {
        
        let s = ( a + b + c) / 2
        let area = sqrt(s*(s-a)*(s-b)*(s-c))
        
        let height = (2*area)/c
        
        let leftpoint = CGPoint(x: -sqrt((a * a) - (height * height)),y: height).clean
        let rightpoint = CGPoint(x: c - abs(leftpoint.x), y: height).clean
        
        return (leftpoint,rightpoint)
    }
    
    
    enum section {
        case quad1
        case quad2
        case quad3
        case quad4
    }
    
    
    private func findPoint(section : section, lastpoint : CGPoint, a : CGFloat, b : CGFloat, c: CGFloat) -> CGPoint{
        
        
        
        let a1 = 4*((lastpoint.x*lastpoint.x) + (lastpoint.y*lastpoint.y))
        let k = (-(lastpoint.x*lastpoint.x) + (-(lastpoint.y*lastpoint.y)) + (c*c) + (-(a*a)))
        let b1 = 4*(lastpoint.y)*k
        let c1 = (k*k) + (-(4*(lastpoint.x*lastpoint.x)*(a*a)))
        
        let y = (-b1 - sqrt((b1*b1) - (4*a1*c1))) / (2*a1)
        
        let x = sqrt((a*a) - (y*y))
        
        
        if section == .quad3 {
            return CGPoint(x: x < 0 ? x : -x, y: y < 0 ? y : -y ).clean
        }
        else if section == .quad4 {
            return CGPoint(x: x < 0 ? -x : x, y: y < 0 ? y : -y ).clean
        }
        else {
            return CGPoint(x: x , y: y ).clean
        }
        
    }
    
    enum direction {
        case back
        case left
        case front
        case right
    }
    
    private func calculateYaw(for direction: direction, incline : CGFloat) -> CGFloat {
        
        switch direction {
        
        case .back:
            return incline.degreesToRadians.clean
        case .left:
            return floor(90 - incline).degreesToRadians.clean
        case .front:
            return floor(90 - incline).degreesToRadians.clean
        case .right:
            return floor(90 - incline).degreesToRadians.clean
        }
        
    }
    
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

    
    
    
    
    
    
    
    
}
