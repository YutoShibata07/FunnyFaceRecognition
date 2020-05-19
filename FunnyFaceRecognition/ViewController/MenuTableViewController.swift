//
//  MenuTableViewController.swift
//  FunnyFaceRecognition
//
//  Created by 柴田優斗 on 2020/01/03.
//  Copyright © 2020 柴田優斗. All rights reserved.
//

import UIKit
import MessageUI

class MenuTableViewController: UITableViewController,MFMailComposeViewControllerDelegate {

    
    var menuModel = MenuModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(menuModel.images)
        return menuModel.images.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let menuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell",for: indexPath) as? MenuTableViewCell{
            menuCell.configureCell(imageName:menuModel.images[indexPath.item], title: menuModel.titles[indexPath.item])
            menuCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return menuCell
        }
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let YOUR_APP_ID = "1493966241"
            let urlString = "itms-apps://itunes.apple.com/jp/app/id\(YOUR_APP_ID)?mt=8&action=write-review"
            if let url = URL(string: urlString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        if indexPath.row == 1{
            sendMail()
        }
        
        if indexPath.row == 2{
           performSegue(withIdentifier: "toQuestionVC", sender: self)
        }
        
        if indexPath.row == 3{
            performSegue(withIdentifier: "toPrivacyPolicy", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   

    
    func sendMail(){
          
          guard MFMailComposeViewController.canSendMail() else { return }
          let mailComposeViewController = MFMailComposeViewController()
          mailComposeViewController.mailComposeDelegate = self
          mailComposeViewController.setToRecipients(["yutoappdeveloper07@gmail.com"])
          mailComposeViewController.setSubject("「ゆう子の変顔えぐいてwww」に関して")
          present(mailComposeViewController, animated: true, completion: nil)
      }
      
      // MARK: - MFMailComposeViewControllerDelegate
      
      func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
          switch result {
          case .cancelled:
              print("cancelled")
          case .saved:
              print("saved")
          case .sent:
              print("sent")
          case .failed:
              print("failed")
          @unknown default:
              print("unknown")
          }
          self.dismiss(animated: true, completion: nil)
          
      }
    
    
}

