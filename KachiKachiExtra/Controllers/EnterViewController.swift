//
//  EnterViewController.swift
//  KachiKachiExtra
//
//  Created by 犬 on 2020/06/12.
//  Copyright © 2020 吉井 駿一. All rights reserved.
//

import Foundation
import UIKit

class EnterViewController: UIViewController{
    
    // スリープしないようにする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    // main画面からデータ受け取る
    var abStatus = 0
    var udStatus = 1
    var game1 = ["0", "0"]
    var game2 = ["0", "0"]
    var all1 = ["0", "0"]
    var all2 = ["0", "0"]
    var start1 = ["0", "0"]
    var start2 = ["0", "0"]
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBAction func tappedFinishButton(_ sender: Any) {

        var allText = allTextField.text ?? "0"
        var startText = startTextField.text ?? "0"
        if allText == ""{
            allText = "0"
        }
        if startText ==  ""{
            startText = "0"
        }
        if (Int(allText) == nil) || (Int(startText) == nil){
            print("alltext:"+allText)
            print("starttext:"+startText)
            errorLabel.textColor = .red
        }
        else{
            
            let viewController = self.presentingViewController as! ViewController
            
            // viewcontrollerに値を渡す
            viewController.abStatus = self.abStatus
            viewController.udStatus = udStatus
            viewController.gameNumber1Label.text = self.game1[abStatus]
            viewController.gameNumber2Label.text = self.game2[abStatus]
            viewController.game1[abStatus] = self.game1[abStatus]
            viewController.game2[abStatus] = self.game2[abStatus]
            viewController.reloadRates()
            viewController.all1[abStatus] = self.all1[abStatus]
            viewController.all2[abStatus] = self.all2[abStatus]
            viewController.start1[abStatus] = self.start1[abStatus]
            viewController.start2[abStatus] = self.start2[abStatus]
            viewController.saveData()
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var allTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var kojinLabel: UILabel!
    let maxLength: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        errorLabel.textColor = .clear
        
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        timeLabel.text = dateFormatter.string(from: dt)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTime(_ :)), userInfo: nil, repeats: true)
        
        allTextField.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        startTextField.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        finishButton.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        allTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 174, green: 174, blue: 178)])
        startTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 174, green: 174, blue: 178)])
        
        finishButton.layer.cornerRadius = 20
        finishButton.layer.borderWidth = 2
        finishButton.layer.borderColor = UIColor.black.cgColor
        
        
        allTextField.addTarget(self, action: #selector(allTextFieldDidChange), for: UIControl.Event.editingChanged)
        startTextField.addTarget(self, action: #selector(allTextFieldDidChange), for: UIControl.Event.editingChanged)
        if udStatus == 1{
            gameLabel.text = "ゲーム数 1 を入力"
            if abStatus == 0{
                statusLabel.text = "モード：A / 上"
            }
            else if abStatus == 1{
                statusLabel.text = "モード：B / 上"
            }
        }
        else if udStatus == 2{
            gameLabel.text = "ゲーム数 2 を入力"
            if abStatus == 0{
                statusLabel.text = "モード：A / 下"
            }
            else if abStatus == 1{
                statusLabel.text = "モード：B / 下"
            }
        }
        
        // allとstartがあれば入れとく
        switch udStatus {
        case 1:
            allTextField.text = all1[abStatus]
            startTextField.text = start1[abStatus]
            if all1[abStatus] == "0"{
                allTextField.text = ""
            }
            if start1[abStatus] == "0"{
                startTextField.text = ""
            }
        case 2:
            allTextField.text = all2[abStatus]
            startTextField.text = start2[abStatus]
            if all2[abStatus] == "0"{
                allTextField.text = ""
            }
            if start2[abStatus] == "0"{
                startTextField.text = ""
            }
        default:
            break
        }
        let kojin = (Int(allTextField.text ?? "") ?? 0) - (Int(startTextField.text ?? "") ?? 0)
        if kojin >= 0{
            kojinLabel.text = String(kojin)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func allTextFieldDidChange(){
        
        //alltextfieldの文字数制限
        guard let allText = allTextField.text else {return}
        allTextField.text = String(allText.prefix(maxLength))
        
        //startTextFieldの文字数制限
        guard let startText = startTextField.text else {return}
        startTextField.text = String(startText.prefix(maxLength))
        
        if allText == "0"{
            allTextField.text =  ""
        }
        if startText == "0"{
            startTextField.text = ""
        }
        // 総ゲーム数 - スタートゲーム数 = 個人ゲーム数
        let all = Int(allTextField.text ?? "") ?? 0
        let start = Int(startTextField.text ?? "") ?? 0
        if all - start >= 0{
            errorLabel.textColor = .clear
            kojinLabel.text = String(all - start)
            switch udStatus{
            case 1:
                game1[abStatus] = String(all - start)
                all1[abStatus] = allTextField.text ?? "0"
                start1[abStatus] = startTextField.text ?? "0"
            case 2:
                game2[abStatus] = String(all - start)
                all2[abStatus] = allTextField.text ?? "0"
                start2[abStatus] = startTextField.text ?? "0"
            default:
                break
            }
        }
        else {
            kojinLabel.text = "0"
            switch udStatus {
            case 1:
                game1[abStatus] = "0"
                all1[abStatus] = allTextField.text ?? "0"
                start1[abStatus] = startTextField.text ?? "0"
            case 2:
                game2[abStatus] = "0"
                all2[abStatus] = allTextField.text ?? "0"
                start2[abStatus] = startTextField.text ?? "0"
            default:
                break
            }
        }
    }
    @objc func reloadTime(_ sender: Timer){
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        timeLabel.text = dateFormatter.string(from: dt)
    }
}

