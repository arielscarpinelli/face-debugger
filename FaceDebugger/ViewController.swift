//
//  ViewController.swift
//  FaceDebugger
//
//  Created by Ariel Scarpinelli on 1/29/18.
//  Copyright © 2018 Ariel Scarpinelli. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var blendShapes : [ARFaceAnchor.BlendShapeLocation : NSNumber] = [:];
    
    let blendShapeSortOrder = [
        // Left
        ARFaceAnchor.BlendShapeLocation.browOuterUpLeft,
        ARFaceAnchor.BlendShapeLocation.browDownLeft,
        ARFaceAnchor.BlendShapeLocation.cheekSquintLeft,
        ARFaceAnchor.BlendShapeLocation.eyeBlinkLeft,
        ARFaceAnchor.BlendShapeLocation.eyeLookDownLeft,
        ARFaceAnchor.BlendShapeLocation.eyeLookInLeft,
        ARFaceAnchor.BlendShapeLocation.eyeLookOutLeft,
        ARFaceAnchor.BlendShapeLocation.eyeLookUpLeft,
        ARFaceAnchor.BlendShapeLocation.eyeSquintLeft,
        ARFaceAnchor.BlendShapeLocation.eyeWideLeft,
        ARFaceAnchor.BlendShapeLocation.mouthDimpleLeft,
        ARFaceAnchor.BlendShapeLocation.mouthFrownLeft,
        ARFaceAnchor.BlendShapeLocation.mouthLeft,
        ARFaceAnchor.BlendShapeLocation.jawLeft,
        ARFaceAnchor.BlendShapeLocation.mouthLowerDownLeft,
        ARFaceAnchor.BlendShapeLocation.mouthPressLeft,
        ARFaceAnchor.BlendShapeLocation.mouthSmileLeft,
        ARFaceAnchor.BlendShapeLocation.mouthStretchLeft,
        ARFaceAnchor.BlendShapeLocation.mouthUpperUpLeft,
        ARFaceAnchor.BlendShapeLocation.noseSneerLeft,

        // Center
        ARFaceAnchor.BlendShapeLocation.jawForward,
        ARFaceAnchor.BlendShapeLocation.jawOpen,
        ARFaceAnchor.BlendShapeLocation.mouthClose,
        ARFaceAnchor.BlendShapeLocation.mouthFunnel,
        ARFaceAnchor.BlendShapeLocation.mouthPucker,
        ARFaceAnchor.BlendShapeLocation.mouthRollLower,
        ARFaceAnchor.BlendShapeLocation.mouthRollUpper,
        ARFaceAnchor.BlendShapeLocation.mouthShrugLower,
        ARFaceAnchor.BlendShapeLocation.mouthShrugUpper,
        ARFaceAnchor.BlendShapeLocation.browInnerUp,
        ARFaceAnchor.BlendShapeLocation.cheekPuff,

        // Right
        ARFaceAnchor.BlendShapeLocation.noseSneerRight,
        ARFaceAnchor.BlendShapeLocation.mouthUpperUpRight,
        ARFaceAnchor.BlendShapeLocation.mouthStretchRight,
        ARFaceAnchor.BlendShapeLocation.mouthSmileRight,
        ARFaceAnchor.BlendShapeLocation.mouthPressRight,
        ARFaceAnchor.BlendShapeLocation.mouthLowerDownRight,
        ARFaceAnchor.BlendShapeLocation.jawRight,
        ARFaceAnchor.BlendShapeLocation.mouthRight,
        ARFaceAnchor.BlendShapeLocation.mouthFrownRight,
        ARFaceAnchor.BlendShapeLocation.mouthDimpleRight,
        ARFaceAnchor.BlendShapeLocation.eyeWideRight,
        ARFaceAnchor.BlendShapeLocation.eyeSquintRight,
        ARFaceAnchor.BlendShapeLocation.eyeLookUpRight,
        ARFaceAnchor.BlendShapeLocation.eyeLookOutRight,
        ARFaceAnchor.BlendShapeLocation.eyeLookInRight,
        ARFaceAnchor.BlendShapeLocation.eyeLookDownRight,
        ARFaceAnchor.BlendShapeLocation.eyeBlinkRight,
        ARFaceAnchor.BlendShapeLocation.cheekSquintRight,
        ARFaceAnchor.BlendShapeLocation.browDownRight,
        ARFaceAnchor.BlendShapeLocation.browOuterUpRight
    ];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else { return }

        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true


        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        self.blendShapes = faceAnchor.blendShapes;
        
        DispatchQueue.main.async {
            self.collectionView.reloadData();
        }

    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return self.blendShapeSortOrder.count;
        }
        return 0;
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlendShapeCollectionViewCell", for: indexPath) as! BlendShapeCollectionViewCell;
        
        let blendShape = getBlendShapeAtIndexPath(indexPath: indexPath);
        
        cell.name = blendShape.key.rawValue
        cell.blendShapeValue = max(0, blendShape.value?.floatValue ?? 0);

        return cell;
    }
    
    func getBlendShapeAtIndexPath(indexPath: IndexPath) -> (key: ARFaceAnchor.BlendShapeLocation, value: NSNumber?)  {
        let key = blendShapeSortOrder[indexPath.item]
        return (key: key, value: blendShapes[key])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 6, height: collectionView.frame.height)
    }

}
