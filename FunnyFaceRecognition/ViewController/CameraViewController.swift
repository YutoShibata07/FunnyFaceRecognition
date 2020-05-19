//
//  CameraViewController.swift
//  FunnyFaceRecognition
//
//  Created by 柴田優斗 on 2019/12/29.
//  Copyright © 2019 柴田優斗. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraPreview: UIView!
    
    
    @IBOutlet weak var scoreTextView: UITextView!
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var secondPhoto:String!
    var firstPhoto:String!
    var string_score:String!
    var isFirstPhoto = 1
    var funny_score:Double!
    var api_key = "oLdw7KUjqHkvbsYh6GAG4x5OvdYUK51Z"
    var api_secret = "wM9HPbf7CnCV_qBmFzpqOTuuOAvbGrdQ"
    var captureSession:AVCaptureSession?
    var videoPreviewayer:AVCaptureVideoPreviewLayer?
    var photoOutput = AVCapturePhotoOutput()
    var inputDevice:AVCaptureDeviceInput?
    var flash: AVCaptureDevice.FlashMode = .off
    var usingFrontCamera = false
    var usingFlash = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.loadCamera()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.scoreTextView.text = "①「真顔」を撮影してください🌟"
        self.scoreTextView.layer.cornerRadius = 8
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.default(.builtInWideAngleCamera, for:AVMediaType.video, position: AVCaptureDevice.Position.front)!
    }
    
    func getBackCamera() -> AVCaptureDevice{
        return AVCaptureDevice.default(.builtInWideAngleCamera, for:AVMediaType.video, position: AVCaptureDevice.Position.back)!
    }
    
    func loadCamera() {
        var isFirst = false
        
        DispatchQueue.global().async {
            if(self.captureSession == nil){
                isFirst = true
                self.captureSession = AVCaptureSession()
                self.captureSession!.sessionPreset = AVCaptureSession.Preset.high
            }
            var error: NSError?
            var input: AVCaptureDeviceInput!
            
            let currentCaptureDevice = (self.usingFrontCamera ? self.getFrontCamera() : self.getBackCamera())
            
            do {
                input = try AVCaptureDeviceInput(device: currentCaptureDevice!)
            } catch let error1 as NSError {
                error = error1
                input = nil
                print(error!.localizedDescription)
            }
            
            for i : AVCaptureDeviceInput in (self.captureSession?.inputs as! [AVCaptureDeviceInput]) {
                self.captureSession?.removeInput(i)
            }
            
            for i : AVCaptureOutput in (self.captureSession!.outputs) {
                self.captureSession?.removeOutput(i)
            }
            
            if error == nil && self.captureSession!.canAddInput(input) {
                self.captureSession!.addInput(input)
            }
            
            if (self.captureSession?.canAddOutput(self.photoOutput))! {
                self.captureSession?.addOutput(self.photoOutput)
            } else {
                print("Error: Couldn't add meta data output")
                return
            }
            
            DispatchQueue.main.async {
                if isFirst {
                    self.videoPreviewayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                    self.videoPreviewayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.videoPreviewayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.videoPreviewayer?.frame = self.cameraPreview.layer.bounds
                    self.cameraPreview.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                    self.cameraPreview.layer.addSublayer(self.videoPreviewayer!)
                    self.captureSession!.startRunning()
                }
            }
        }
        
    }
    
    @objc func capture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flash
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func captureAction(_ sender: Any) {
        capture()
    }
    
    @IBAction func rotateAction(_ sender: Any) {
        self.usingFrontCamera = !self.usingFrontCamera
        self.loadCamera()
    }
    
    @IBAction func flashAction(_ sender: Any) {
        self.usingFlash = !self.usingFlash
        
        if(self.usingFlash) {
            flash = .on
        } else {
            flash = .off
        }
    }
    
    
    
    
    
    func recognize(imageBase64: String, imageBase64_2: String) {
        scoreTextView.text = "③変顔偏差値を計算中です"
        spinner.startAnimating()
        var request = URLRequest(url: URL(string: "https://api-us.faceplusplus.com/facepp/v3/compare")!)
        let params : NSMutableDictionary? = [
            "api_key":api_key,
            "api_secret":api_secret,
            "image_base64_1" : imageBase64,
            "image_base64_2":imageBase64_2
        ]
        let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)

        Alamofire.request("https://api-us.faceplusplus.com/facepp/v3/compare",method: .post,parameters: params as! Parameters,encoding: URLEncoding.default,headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON { (response) in
            self.spinner.stopAnimating()
            print(response)

            if((response.result.value) != nil) {
                if let error = response.result.error{
                    debugPrint(error.localizedDescription)
                    return
                }
                guard let data = response.data else{ return }
                do{
                    let json = try JSON(data: data)
                    let personData = self.parsePersonSwifty(json: json)
                    self.funny_score = (95 - personData.confidence) * 3 + 30
                    self.performSegue(withIdentifier: "toResultVC", sender: self)
                }catch{
                    debugPrint(error.localizedDescription)
                }
                
                
            }else{print("fail!!!!")}
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var destination = segue.destination as? ResultViewController{
            destination.result = self.funny_score
            destination.imageString = self.firstPhoto
            destination.funnyImageString = self.secondPhoto
        }
    }
    
    
    
    private func parsePersonSwifty(json:JSON) -> PersonData{
        //SwiftyJsonを使うとダウンキャスティングとnilの時の対応を簡単にできる。
        let confidence = json["confidence"].double
        return PersonData(confidence:confidence ?? 13.0)
    }
    

}

extension CameraViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let image = UIImage(data: imageData!)
        
        let imagedata = image!.jpegData(compressionQuality: 1.0)
        let base64String : String = imagedata!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        let imageStr : String = base64String.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if isFirstPhoto == 1{
            self.firstPhoto = imageStr
            isFirstPhoto = 0
            self.scoreTextView.text = "②「変顔」を撮影してください🌟"
        }else{
            self.secondPhoto = imageStr
             recognize(imageBase64: firstPhoto,imageBase64_2: secondPhoto)
        }
       
    }

}

