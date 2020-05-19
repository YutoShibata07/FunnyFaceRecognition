//
//  QuestionViewController.swift
//  FunnyFaceRecognition
//
//  Created by 柴田優斗 on 2020/01/04.
//  Copyright © 2020 柴田優斗. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var title3Label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title1Label.layer.cornerRadius = 7
        title2Label.layer.cornerRadius = 7
        title3Label.layer.cornerRadius = 7
    }
    


}
