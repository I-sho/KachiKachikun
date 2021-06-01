//
//  KoyakuViewController.swift
//  KachiKachiExtra
//
//  Created by 犬 on 2020/06/14.
//  Copyright © 2020 吉井 駿一. All rights reserved.
//

import Foundation
import UIKit


class KoyakuViewController: UIViewController{
    
    // スリープしないようにする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    let maxLength = 4
    var udStatus = 1
    var abStatus = 0
    var receives = ["", "", "", "", ""]
    var sends = ["", "", "", "", ""]
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBAction func tappedFinishButton(_ sender: Any) {
        
        if white == "" {
            white = "0"
        }
        if red == ""{
            red = "0"
        }
        if green == ""{
            green = "0"
        }
        if yellow == ""{
            yellow = "0"
        }
        if blue == ""{
            blue = "0"
        }
        
        if Int(white) == nil || Int(red)  == nil || Int(green) == nil || Int(yellow) == nil || Int(blue) == nil{
            errLabel.textColor = .red
        }
        else{
            let viewController = self.presentingViewController as! ViewController
            
            viewController.wN[abStatus][udStatus - 1] = self.white
            viewController.rN[abStatus][udStatus - 1] = self.red
            viewController.gN[abStatus][udStatus - 1] = self.green
            viewController.yN[abStatus][udStatus - 1] = self.yellow
            viewController.bN[abStatus][udStatus - 1] = self.blue
            
            if udStatus == 1{
                viewController.whiteNumber1Label.text = self.white
                viewController.redNumber1Label.text = self.red
                viewController.greenNumber1Label.text = self.green
                viewController.yellowNumber1Label.text = self.yellow
                viewController.blueNumber1Label.text = self.blue
            }
            else if udStatus == 2{
                viewController.whiteNumber2Label.text = self.white
                viewController.redNumber2Label.text = self.red
                viewController.greenNumber2Label.text = self.green
                viewController.yellowNumber2Label.text = self.yellow
                viewController.blueNumber2Label.text = self.blue
            }
            viewController.abStatus = self.abStatus
            viewController.udStatus = self.udStatus
            viewController.reloadRates()
            viewController.saveData()
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBOutlet weak var whiteTextField: CustomTextField!
    @IBOutlet weak var redTextField: CustomTextField!
    @IBOutlet weak var greenTextField: CustomTextField!
    @IBOutlet weak var yellowTextField: CustomTextField!
    @IBOutlet weak var blueTextField: CustomTextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    var white = "0"
    var red = "0"
    var green = "0"
    var yellow = "0"
    var blue = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if abStatus == 0{
            if udStatus == 1{
                statusLabel.text = "モード：A / 上"
            }
            else if udStatus == 2{
                statusLabel.text = "モード：A / 下"
            }
        }
        else if abStatus == 1{
            if udStatus == 1{
                statusLabel.text = "モード：B / 上"
            }
            else if udStatus == 2{
                statusLabel.text = "モード：B / 下"
            }
        }
        
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        timeLabel.text = dateFormatter.string(from: dt)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTime(_ :)), userInfo: nil, repeats: true)
        
        errLabel.textColor = .clear
        whiteTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 174, green: 174, blue: 178)])
        redTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 174, green: 174, blue: 178)])
        greenTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 174, green: 174, blue: 178)])
        yellowTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 174, green: 174, blue: 178)])
        blueTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 174, green: 174, blue: 178)])
        
        finishButton.layer.cornerRadius = 15
        finishButton.layer.borderWidth = 2
        finishButton.layer.borderColor = UIColor.black.cgColor
        
        titleLabel.layer.cornerRadius = 15
        
        // mainから受け取った値を入れる
        var i = 0
        while i < 5{
            if receives[i] == "0"{
                receives[i] = ""
            }
            i += 1
        }
        white = receives[0]
        red = receives[1]
        green = receives[2]
        yellow = receives[3]
        blue = receives[4]
        whiteTextField.text = receives[0]
        redTextField.text = receives[1]
        greenTextField.text = receives[2]
        yellowTextField.text = receives[3]
        blueTextField.text = receives[4]
        
        whiteTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        redTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        greenTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        yellowTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        blueTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//           whiteTextField.becomeFirstResponder()
//       }
       
    @objc func textFieldDidChange(){
        
        errLabel.textColor = .clear
        //whiteの字数制限
        guard let whiteText = whiteTextField.text else {return}
        whiteTextField.text = String(whiteText.prefix(maxLength))
        
        //redの字数制限
        guard let redText = redTextField.text else {return}
        redTextField.text = String(redText.prefix(maxLength))
        
        //greenの字数制限
        guard let greenText = greenTextField.text else {return}
        greenTextField.text = String(greenText.prefix(maxLength))
        
        //yellowの字数制限
        guard let yellowText = yellowTextField.text else {return}
        yellowTextField.text = String(yellowText.prefix(maxLength))
        
        //blueの字数制限
        guard let blueText = blueTextField.text else {return}
        blueTextField.text = String(blueText.prefix(maxLength))
        
        if whiteText == "0"{
            whiteTextField.text = ""
        }
        if redText == "0"{
            redTextField.text = ""
        }
        if greenText == "0"{
            greenTextField.text = ""
        }
        if yellowText == "0"{
            yellowTextField.text = ""
        }
        if blueText == "0"{
            blueTextField.text = ""
        }
        white = whiteTextField.text ?? "0"
        red = redTextField.text ?? "0"
        green = greenTextField.text ?? "0"
        yellow = yellowTextField.text ?? "0"
        blue = blueTextField.text ?? "0"
    }
    @objc func reloadTime(_ sender: Timer){
           let dt = Date()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmm", options: 0, locale: Locale(identifier: "ja_JP"))
           timeLabel.text = dateFormatter.string(from: dt)
       }
}
