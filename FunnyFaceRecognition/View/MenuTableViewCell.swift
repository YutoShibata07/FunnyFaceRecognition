//
//  MenuTableViewCell.swift
//  FunnyFaceRecognition
//
//  Created by 柴田優斗 on 2020/01/03.
//  Copyright © 2020 柴田優斗. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(imageName:String,title:String){
        print(imageName)
        self.menuImageView.image = UIImage(named: imageName)
        self.titleLabel.text = title
    }

}
