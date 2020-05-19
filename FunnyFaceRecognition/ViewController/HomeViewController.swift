//
//  HomeViewController.swift
//  FunnyFaceRecognition
//
//  Created by 柴田優斗 on 2019/12/29.
//  Copyright © 2019 柴田優斗. All rights reserved.
//

import UIKit
import SideMenu
import  GoogleMobileAds

class HomeViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var aloneButton: UIButton!
    
    @IBOutlet weak var menuButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.layer.cornerRadius = 8
        self.aloneButton.layer.cornerRadius = 8
        self.menuButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let deg = 5.0 //時計回りに7度
        titleLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI*deg/180.0))
    }
    
    

}
