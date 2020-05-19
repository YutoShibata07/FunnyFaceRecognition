//
//  ResultViewController.swift
//  FunnyFaceRecognition
//
//  Created by 柴田優斗 on 2020/01/02.
//  Copyright © 2020 柴田優斗. All rights reserved.
//

import UIKit
import GoogleMobileAds
import LTMorphingLabel

class ResultViewController: UIViewController,GADInterstitialDelegate,LTMorphingLabelDelegate {
    
    
    @IBOutlet weak var numberLabel: LTMorphingLabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scoreTitle: UILabel!
    @IBOutlet weak var funnyFaceImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    var imageString:String!
    var interstitial:GADInterstitial!
    var count:Int!
    var result :Double!
    var string_score:String!
    var funnyImageString:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.delegate = self
        // Do any additional setup after loading the view.
        string_score = String(format: "%.2f", result)
        scoreTitle.layer.cornerRadius = 10
        commentLabel.layer.cornerRadius = 10
        
        numberLabel.morphingEffect = .burn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        interstitial = createAndLoadInterstitial()
        interstitial.delegate = self
        commentLabel.text = ""
        numberLabel.text = self.string_score
        count = Int.random(in: 0..<2)
        print(self.count)
        guard let stringScore = self.string_score else{ return }
        scoreTitle.text = "  あなたの変顔偏差値は..."
        self.imageView.image = StringToImage(imageString: imageString)
        self.funnyFaceImageView.image = StringToImage(imageString: funnyImageString)
        
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        if let result = self.result{
            switch result {
            case (75.0...90.0):
                self.commentLabel.text = "人間の所業とは思えないレベル"
            case (65.0..<75.0):
                self.commentLabel.text = "顔面崩壊っ🌟"
            case (60.0..<65.0):
                self.commentLabel.text = "間違いなく変顔。完成度に脱帽"
            case (55.0..<60.0):
                self.commentLabel.text = "気になる子の前ではこのくらいで笑いを取りたい"
            case (50.0..<55.0):
                self.commentLabel.text = "賛否両論あるが変顔といって良いレベル。。"
            case (45.0..<50.0):
                self.commentLabel.text = "もう少し自分の殻を破ろ？"
            case (40.0..<45.0):
                self.commentLabel.text = "これで変顔は見せる人に失礼！"
            case (35.0..<40.0):
                self.commentLabel.text = "なってない...!!変顔....!!まるでダメ！！"
            case(30.0..<35.0):
                self.commentLabel.text = "(あんたの変顔全然可愛すぎるんですけど)"
            case(25.0..<30.0):
                self.commentLabel.text = "むしろ何を変化させたのかを問いたい"
            default:
                self.commentLabel.text = "すみません。エラーの可能性が高いです"
            }
        }
    }
    
    

    
    func createAndLoadInterstitial() -> GADInterstitial{
        var interstitial = GADInterstitial.init(adUnitID: "ca-app-pub-7252408232726748/9270342362")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        performSegue(withIdentifier: "toHomeVCSegue", sender: self)
    }
    
    
    
    func StringToImage(imageString:String) -> UIImage?{

            //空白を+に変換する
            var base64String = imageString.replacingOccurrences(of: " ", with: "+")

            //BASE64の文字列をデコードしてNSDataを生成
            let decodeBase64:NSData? =
                NSData(base64Encoded:base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)

            //NSDataの生成が成功していたら
            if let decodeSuccess = decodeBase64 {

                //NSDataからUIImageを生成
                let img = UIImage(data: decodeSuccess as Data)

                //結果を返却
                return img
            }

            return nil

    }

    @IBAction func toHomeButtonClicked(_ sender: Any) {
        print(interstitial.isReady)
        guard let count = count else{ return }
        if interstitial.isReady && self.count == 0{
            interstitial.present(fromRootViewController: self)
        }else{
            print("ad wasn't ready")
            performSegue(withIdentifier: "toHomeVCSegue", sender: self)
        }
    }
    

}
