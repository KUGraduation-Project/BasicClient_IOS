//
//  ARViewController.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import RxSwift
import RxCocoa
import CoreMotion
import RealityKit


class ARViewController : UIViewController , ARSCNViewDelegate {
    
    
    var planeGeometry : SCNPlane!
    
    var currentTransform : simd_float4x4?
    
    var sceneView = VirtualObjectARView()
    
    var viewmodel : ARViewModel!
    
    var disposebag = DisposeBag()
    
    let node = SCNNode()
    
    let coachingOverlay = ARCoachingOverlayView()
    
    var focusSquare = FocusSquare()
    
    let updateQueue = DispatchQueue(label: "updateQueue")
    
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView, viewController: self)
    
    let virtualObjectLoader = VirtualObjectLoader()
    
    
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(sceneView)
        sceneView.frame = self.view.frame
        
        sceneView.delegate = self

        makecoachingView()
        coachingViewConfiguration()
        updateFocusSquare(isObjectVisible: false)
        
        setupScene()
        makeimage()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    func setupScene(){
        
        let anchor = ARAnchor(transform: simd_float4x4([1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]))
        sceneView.session.add(anchor: anchor)
        sceneView.autoenablesDefaultLighting = false
        
        
        
        //        node.position = SCNVector3.init(0, 0, 0)
        ////        self.sceneView.scene.rootNode.worldPosition = SCNVector3.init(0, 0, 0)
        //        self.sceneView.scene.rootNode.addChildNode(node)
        
        
        
    }
    
    
    
    
    func coachingViewConfiguration(){
        coachingOverlay.goal = .anyPlane
        coachingOverlay.activatesAutomatically = true
        
    }
    
    
    func bindView(){
        viewmodel.walls2.subscribe(onNext : { [unowned self] walls in
            for wall in walls.wall {
                print("??")
                self.node.addChildNode(wall)
            }
        })
        .disposed(by: disposebag)
        
        
        viewmodel.coordinates
            .subscribe(onNext : { [unowned self] coordinateArray in
                for (index, coord) in coordinateArray.enumerated() {
                    let path = UIBezierPath()
                    path.move(to: coord[0])
                    path.addLine(to: coord[1])
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = path.cgPath
                    shapeLayer.strokeColor = viewmodel.randomcolors[index].cgColor
                    //UIColor.black.cgColor
                    image.layer.addSublayer(shapeLayer)
                }
                
            })
            .disposed(by: disposebag)
        
        

    }
    
    
    func updateFocusSquare(isObjectVisible: Bool) {
        
        if isObjectVisible || coachingOverlay.isActive {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
        }
        
        // Perform ray casting only when ARKit tracking is in a good state.
        if let camera = sceneView.session.currentFrame?.camera, case .normal = camera.trackingState,
           let query = sceneView.getRaycastQuery(),
           let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
            if !coachingOverlay.isActive {
                //                addObjectButton.isHidden = false
            }
            //            statusViewController.cancelScheduledMessage(for: .focusSquare)
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            //            addObjectButton.isHidden = true
            //            objectsViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    
    
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        self.node.worldPosition = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
        
        node.addChildNode(self.node)
        
        
        let floorPlane = SCNFloor()
        let groundPlane = SCNNode()
        let groundMaterial = SCNMaterial()
        groundMaterial.lightingModel = .constant
        groundMaterial.writesToDepthBuffer = true
        groundMaterial.isDoubleSided = false
        floorPlane.materials = [groundMaterial]
        floorPlane.firstMaterial?.diffuse.contents = UIColor.lightGray.cgColor
        floorPlane.reflectivity = 0.01

        groundPlane.geometry = floorPlane
                    groundPlane.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray.cgColor
        groundPlane.worldPosition = SCNVector3(0, -1.5, 0)
        //        //
        node.addChildNode(groundPlane)


        let floorPlane2 = SCNFloor()
        let groundPlane2 = SCNNode()
        let groundMaterial2 = SCNMaterial()
        groundMaterial2.lightingModel = .constant
        groundMaterial2.writesToDepthBuffer = true
        groundMaterial2.isDoubleSided = true
        floorPlane2.materials = [groundMaterial2]
        floorPlane2.firstMaterial?.diffuse.contents = UIColor.lightGray.cgColor
        floorPlane2.reflectivity = 0.01
        groundPlane2.geometry = floorPlane2
        groundPlane2.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray.cgColor
        groundPlane2.worldPosition = SCNVector3(0, 1.5, 0)
        //        //
        node.addChildNode(groundPlane2)

        //        // Create a ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.shadowMode = .deferred
        ambientLight.light?.color = UIColor.white
        ambientLight.light?.type = SCNLight.LightType.ambient
        ambientLight.position = SCNVector3(x: 0,y: 1,z: 0)
        // Create a directional light node with shadow
        let myNode = SCNNode()
        myNode.light = SCNLight()
        myNode.light?.type = SCNLight.LightType.directional
        myNode.light?.color = UIColor.white
        myNode.light?.castsShadow = true
        myNode.light?.automaticallyAdjustsShadowProjection = true
        myNode.light?.shadowSampleCount = 64
        myNode.light?.shadowRadius = 16
        myNode.light?.shadowMode = .deferred
        myNode.light?.shadowMapSize = CGSize(width: 2048, height: 2048)
        myNode.light?.shadowColor = UIColor.black.withAlphaComponent(0.75)
        myNode.position = SCNVector3(x: 0,y: 1,z: 0)
        myNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        // Add the lights to the container
        node.addChildNode(ambientLight)
        node.addChildNode(myNode)
        
        
    }
    
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Do something with the new transform
        
        currentTransform = frame.camera.transform
        print("currentTransform",currentTransform)
    }
    
    
    
    
    
    
}
extension ARViewController {
    private func makeimage(){
        self.view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        image.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 30).isActive = true
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.backgroundColor = .white
    }
    private func makecoachingView(){
        sceneView.addSubview(coachingOverlay)
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        coachingOverlay.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        coachingOverlay.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        coachingOverlay.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        coachingOverlay.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        coachingOverlay.delegate = self
        coachingOverlay.session = sceneView.session
        
        
    }
}
extension ARViewController : ARCoachingOverlayViewDelegate {
    
    
    //애플 왈 이때 코칭에 집중할 수 있게 화면을 최대한 비우랜다.
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
    }
    
    //골 달성 했을때 자동적으로 코칭뷰가 취소됨
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        
    }
    
}
extension ARViewController {
    func addChildNode(_ node: SCNNode, name : String) {
        let cameraRelativePosition = SCNVector3(0,0,-1)
        guard let currentFrame = self.sceneView.session.currentFrame else { return }
        let camera = currentFrame.camera
        let transform = camera.transform
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = cameraRelativePosition.x
        translationMatrix.columns.3.y = cameraRelativePosition.y
        translationMatrix.columns.3.z = cameraRelativePosition.z
        let modifiedMatrix = simd_mul(transform, translationMatrix)
        node.simdTransform = modifiedMatrix
        node.eulerAngles = SCNVector3(0, 90, 0)
        let furniturePos = node.worldPosition
        viewmodel.furnitureInput.onNext((name, point: CGPoint(x: CGFloat(furniturePos.x) , y: CGFloat(furniturePos.z))))
        
        self.node.addChildNode(node)
    }
    
    
    func loadObject(object : VirtualObject){
        object.load()
        object.isHidden = false
        virtualObjectInteraction.selectedObject = object
        self.addChildNode(object,name : object.name ?? "")
        
        
    }
    
    //==================== not needed =========================
    
    
    /** Adds the specified virtual object to the scene, placed at the world-space position
     estimated by a hit test from the center of the screen.
     - Tag: PlaceVirtualObject
     */
    func placeVirtualObject(_ virtualObject: VirtualObject) {
        guard let query = virtualObject.raycastQuery else {
            return
        }
        
        
        let trackedRaycast = createTrackedRaycastAndSet3DPosition(of: virtualObject,
                                                                  from: query,
                                                                  withInitialResult: virtualObject.mostRecentInitialPlacementResult)

        virtualObject.raycast = trackedRaycast
        virtualObjectInteraction.selectedObject = virtualObject

        virtualObject.isHidden = false
    }
    
    // - Tag: GetTrackedRaycast
    func createTrackedRaycastAndSet3DPosition(of virtualObject: VirtualObject, from query: ARRaycastQuery,
                                              withInitialResult initialResult: ARRaycastResult? = nil) -> ARTrackedRaycast? {
        if let initialResult = initialResult {
            self.setTransform(of: virtualObject, with: initialResult)
        }
        
        return sceneView.session.trackedRaycast(query) { (results) in
            self.setVirtualObject3DPosition(results, with: virtualObject)
        }
    }
    
    func createRaycastAndUpdate3DPosition(of virtualObject: VirtualObject, from query: ARRaycastQuery) {
        guard let result = sceneView.session.raycast(query).first else {
            return
        }
        
        if virtualObject.allowedAlignment == .any && self.virtualObjectInteraction.trackedObject == virtualObject {
            // If an object that's aligned to a surface is being dragged, then
            // smoothen its orientation to avoid visible jumps, and apply only the translation directly.
            virtualObject.simdWorldPosition = result.worldTransform.translation
            let previousOrientation = virtualObject.simdWorldTransform.orientation
            let currentOrientation = result.worldTransform.orientation
            virtualObject.simdWorldOrientation = simd_slerp(previousOrientation, currentOrientation, 0.1)
        } else {
            self.setTransform(of: virtualObject, with: result)
        }
    }
    
    // - Tag: ProcessRaycastResults
    private func setVirtualObject3DPosition(_ results: [ARRaycastResult], with virtualObject: VirtualObject) {
        
        guard let result = results.first else {
            fatalError("Unexpected case: the update handler is always supposed to return at least one result.")
        }
        
        self.setTransform(of: virtualObject, with: result)
        
        // If the virtual object is not yet in the scene, add it.
        if virtualObject.parent == nil {
            node.addChildNode(virtualObject)
//            self.sceneView.scene.rootNode.addChildNode(virtualObject)
            virtualObject.shouldUpdateAnchor = true
        }
        
        if virtualObject.shouldUpdateAnchor {
            virtualObject.shouldUpdateAnchor = false
            self.updateQueue.async {
                self.sceneView.addOrUpdateAnchor(for: virtualObject)
            }
        }
    }
    
    func setTransform(of virtualObject: VirtualObject, with result: ARRaycastResult) {
        guard let transfrom = currentTransform else { return }
        virtualObject.simdWorldTransform = transfrom
        //result.worldTransform
    }
    
}
