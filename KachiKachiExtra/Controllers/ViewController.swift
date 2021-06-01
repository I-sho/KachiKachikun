//
//  ViewController.swift
//  KachiKachiExtra
//
//  Created by 犬 on 2020/06/09.
//  Copyright © 2020 吉井 駿一. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // スリープしないようにする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    var abStatus = 0
    // 入力画面からデータ受け取る
    var game1 = ["0", "0"]
    var game2 = ["0", "0"]
    var all1 = ["0", "0"]
    var all2 = ["0", "0"]
    var start1 = ["0", "0"]
    var start2 = ["0", "0"]
    
    var wN = [["0", "0"], ["0", "0"]]
    var rN = [["0", "0"], ["0", "0"]]
    var gN = [["0", "0"], ["0", "0"]]
    var yN = [["0", "0"], ["0", "0"]]
    var bN = [["0", "0"], ["0", "0"]]
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func tappedResetButton(_ sender: Any) {
        alert(title: "データをリセットします", message: "この動作は元に戻せません")
    }
    
    //小役入力画面に遷移
    @IBOutlet weak var koyakuButton: UIButton!
    @IBAction func tappedKoyakuButton(_ sender: Any) {
        
        self.initializeRenzoku()
        let storyboard = UIStoryboard(name: "Koyaku", bundle: nil)
        let koyakuViewController = storyboard.instantiateViewController(identifier: "KoyakuViewController") as! KoyakuViewController
        
        koyakuViewController.udStatus = self.udStatus
        koyakuViewController.abStatus = self.abStatus
        if udStatus == 1{
            koyakuViewController.receives = [whiteNumber1Label.text ?? "", redNumber1Label.text ?? "", greenNumber1Label.text ?? "", yellowNumber1Label.text ?? "", blueNumber1Label.text ?? ""]
        }
        else if udStatus == 2{
            koyakuViewController.receives = [whiteNumber2Label.text ?? "", redNumber2Label.text ?? "", greenNumber2Label.text ?? "", yellowNumber2Label.text ?? "", blueNumber2Label.text ?? ""]
        }
        
        
        self.present(koyakuViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var gameNumber1Label: UILabel!
    @IBOutlet weak var whiteNumber1Label: UILabel!
    @IBOutlet weak var redNumber1Label: UILabel!
    @IBOutlet weak var greenNumber1Label: UILabel!
    @IBOutlet weak var yellowNumber1Label: UILabel!
    @IBOutlet weak var blueNumber1Label: UILabel!
    
    @IBOutlet weak var game1Label: UILabel!
    @IBOutlet weak var whiteRate1Label: UILabel!
    @IBOutlet weak var redRate1Label: UILabel!
    @IBOutlet weak var greenRate1Label: UILabel!
    @IBOutlet weak var yellowRate1Label: UILabel!
    @IBOutlet weak var blueRate1Label: UILabel!
    
    @IBOutlet weak var gameNumber2Label: UILabel!
    @IBOutlet weak var whiteNumber2Label: UILabel!
    @IBOutlet weak var redNumber2Label: UILabel!
    @IBOutlet weak var greenNumber2Label: UILabel!
    @IBOutlet weak var yellowNumber2Label: UILabel!
    @IBOutlet weak var blueNumber2Label: UILabel!
    
    @IBOutlet weak var game2Label: UILabel!
    @IBOutlet weak var whiteRate2Label: UILabel!
    @IBOutlet weak var redRate2Label: UILabel!
    @IBOutlet weak var greenRate2Label: UILabel!
    @IBOutlet weak var yellowRate2Label: UILabel!
    @IBOutlet weak var blueRate2Label: UILabel!
    
    @IBOutlet weak var gameEnterButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    //ゲーム数入力画面へ遷移
    @IBAction func tappedEnterButton(_ sender: Any) {
        
        self.initializeRenzoku()
        let storyboard = UIStoryboard(name: "Enter", bundle: nil)
        let enterViewController = storyboard.instantiateViewController(identifier: "EnterViewController") as! EnterViewController
        
        // データを入力画面に渡す
        enterViewController.abStatus = self.abStatus
        enterViewController.udStatus = self.udStatus
        enterViewController.game1[abStatus] = self.gameNumber1Label.text ?? "0"
        enterViewController.game2[abStatus] = self.gameNumber2Label.text ?? "0"
        enterViewController.all1[abStatus] = self.all1[abStatus]
        enterViewController.all2[abStatus] = self.all2[abStatus]
        enterViewController.start1[abStatus] = self.start1[abStatus]
        enterViewController.start2[abStatus] = self.start2[abStatus]
        
        self.saveData()
        self.present(enterViewController, animated: true, completion: nil)
    }
    //こいつで上下のモード管理
    var udStatus: Int = 1
    
    @IBOutlet weak var udButton: UIButton!
    @IBAction func tappedUDButton(_ sender: Any) {
        
        self.initializeRenzoku()
        
        // 上から下へ
        if udStatus == 1{
            self.uTod()
            udStatus = 2
        }
            
            // 下から上へ
        else{
            self.dtou()
            udStatus = 1
        }
        self.saveData()
    }
    
    @IBOutlet weak var modeLabel: UILabel!
    var modeStatus = "+"
    //こいつで+モードと-モード管理
    @IBOutlet weak var modeButton: UIButton!
    @IBAction func modeButton(_ sender: Any) {
        self.initializeRenzoku()
        if modeStatus == "+"{
            modeStatus = "-"
            modeLabel.text = "ー"
            modeLabel.textColor = .systemPink
            modeLabel.layer.borderColor = UIColor.systemPink.cgColor
        }
        else if modeStatus == "-"{
            modeStatus = "+"
            modeLabel.text = "＋"
            modeLabel.textColor = .systemTeal
            modeLabel.layer.borderColor = UIColor.systemTeal.cgColor
        }
        self.saveData()
    }
    
    //押した瞬間色を薄くする
    @IBAction func momentWhiteButton(_ sender: Any) {
        whiteButton.alpha = 0.3
        if udStatus == 1{
            gameNumber1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            whiteNumber1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            redNumber1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            greenNumber1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            yellowNumber1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            blueNumber1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            
            game1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            whiteRate1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            redRate1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            greenRate1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            yellowRate1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            blueRate1Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
        }
        else if udStatus == 2{
            gameNumber2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            whiteNumber2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            redNumber2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            greenNumber2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            yellowNumber2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            blueNumber2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            
            game2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            whiteRate2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            redRate2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            greenRate2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            yellowRate2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
            blueRate2Label.backgroundColor = .rgb(red: 160, green: 170, blue: 180)
        }
    }
    
    var renzokuStatus = ""
    
    // 白ボタンが押された時
    @IBAction func tappedWhiteButton(_ sender: Any) {
        
        var wr = Int(whiteRenzoku.text ?? "0")  ?? 0
        if renzokuStatus == "W" && modeStatus == "+"{
            wr += 1
            whiteRenzoku.text = String(wr)
        }
        else{
            self.initializeRenzoku()
            if modeStatus != "-"{
                renzokuStatus = "W"
                wr += 1
                whiteRenzoku.text = String(wr)
            }
        }
        
        if udStatus == 1{
            gameNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            
            game1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        }
        else if udStatus == 2{
            gameNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            
            game2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        }
        
        whiteButton.alpha = 1
        switch udStatus{
        case 1:
            switch modeStatus {
            case "+":
                var whiteNumber = Int(whiteNumber1Label.text ?? "") ?? 0
                whiteNumber += 1
                whiteNumber1Label.text = String(whiteNumber)
            case "-":
                var whiteNumber = Int(whiteNumber1Label.text ?? "") ?? 0
                if whiteNumber > 0{
                    whiteNumber -= 1
                }
                whiteNumber1Label.text = String(whiteNumber)
            default:
                break
            }
            let wN1 = Int(whiteNumber1Label.text ?? "") ?? 0
            if wN1 != 0{
                let wRate1 = (Double(gameNumber1Label.text ?? "") ?? 0) / Double(wN1)
                whiteRate1Label.text = "1/" + String(round(wRate1 * 100)/100)
            }
            else {
                whiteRate1Label.text = "1/0.0"
            }
        case 2:
            switch modeStatus {
            case "+":
                var whiteNumber = Int(whiteNumber2Label.text ?? "") ?? 0
                whiteNumber += 1
                whiteNumber2Label.text = String(whiteNumber)
            case "-":
                var whiteNumber = Int(whiteNumber2Label.text ?? "") ?? 0
                if whiteNumber > 0{
                    whiteNumber -= 1
                }
                whiteNumber2Label.text = String(whiteNumber)
            default:
                break
            }
            let wN2 = Int(whiteNumber2Label.text ?? "") ?? 0
            if wN2 != 0{
                let wRate2 = (Double(gameNumber2Label.text ?? "") ?? 0) / Double(wN2)
                whiteRate2Label.text = "1/" + String(round(wRate2 * 100)/100)
            }
            else {
                whiteRate2Label.text = "1/0.0"
            }
        default:
            break
        }
        self.saveData()
    }
    //押した瞬間色を薄く
    @IBAction func momentRedButton(_ sender: Any) {
        redButton.alpha = 0.3
        
        if udStatus == 1{
            gameNumber1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            whiteNumber1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            redNumber1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            greenNumber1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            yellowNumber1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            blueNumber1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            
            game1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            whiteRate1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            redRate1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            greenRate1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            yellowRate1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            blueRate1Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
        }
        else if udStatus == 2{
            gameNumber2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            whiteNumber2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            redNumber2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            greenNumber2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            yellowNumber2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            blueNumber2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            
            game2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            whiteRate2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            redRate2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            greenRate2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            yellowRate2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
            blueRate2Label.backgroundColor = .rgb(red: 240, green: 120, blue: 120)
        }
    }
    // 赤ボタンが押された時
    @IBAction func tappedRedButton(_ sender: Any) {
        
        if udStatus == 1{
            gameNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            
            game1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        }
        else if udStatus == 2{
            gameNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            
            game2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        }
        
        var rr = Int(redRenzoku.text ?? "0")  ?? 0
        if renzokuStatus == "R" && modeStatus == "+"{
            rr += 1
            redRenzoku.text = String(rr)
        }
        else{
            self.initializeRenzoku()
            if modeStatus != "-"{
                renzokuStatus = "R"
                rr += 1
                redRenzoku.text = String(rr)
            }
        }
        
        redButton.alpha = 1
        switch udStatus{
        case 1:
            switch modeStatus {
            case "+":
                var redNumber = Int(redNumber1Label.text ?? "") ?? 0
                redNumber += 1
                redNumber1Label.text = String(redNumber)
            case "-":
                var redNumber = Int(redNumber1Label.text ?? "") ?? 0
                if redNumber > 0{
                    redNumber -= 1
                }
                redNumber1Label.text = String(redNumber)
            default:
                break
            }
            let rN1 = Int(redNumber1Label.text ?? "") ?? 0
            if rN1 != 0{
                let rRate1 = (Double(gameNumber1Label.text ?? "") ?? 0) / Double(rN1)
                redRate1Label.text = "1/" + String(round(rRate1 * 100)/100)
            }
            else {
                redRate1Label.text = "1/0.0"
            }
            
        case 2:
            switch modeStatus {
            case "+":
                var redNumber = Int(redNumber2Label.text ?? "") ?? 0
                redNumber += 1
                redNumber2Label.text = String(redNumber)
            case "-":
                var redNumber = Int(redNumber2Label.text ?? "") ?? 0
                if redNumber > 0{
                    redNumber -= 1
                }
                redNumber2Label.text = String(redNumber)
            default:
                break
            }
            let rN2 = Int(redNumber2Label.text ?? "") ?? 0
            if rN2 != 0{
                let rRate2 = (Double(gameNumber2Label.text ?? "") ?? 0) / Double(rN2)
                redRate2Label.text = "1/" + String(round(rRate2 * 100)/100)
            }
            else {
                redRate2Label.text = "1/0.0"
            }
            
        default:
            break
        }
        self.saveData()
    }
    
    
    //押した瞬間色を薄く
    @IBAction func momentGreenButton(_ sender: Any) {
        greenButton.alpha = 0.3
        
        if udStatus == 1{
            gameNumber1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            whiteNumber1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            redNumber1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            greenNumber1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            yellowNumber1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            blueNumber1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            
            game1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            whiteRate1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            redRate1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            greenRate1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            yellowRate1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            blueRate1Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
        }
        else if udStatus == 2{
            gameNumber2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            whiteNumber2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            redNumber2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            greenNumber2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            yellowNumber2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            blueNumber2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            
            game2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            whiteRate2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            redRate2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            greenRate2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            yellowRate2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
            blueRate2Label.backgroundColor = .rgb(red: 110, green: 240, blue: 130)
        }
    }
    //緑ボタンが押された時
    @IBAction func tappedGreenButton(_ sender: Any) {
        
        if udStatus == 1{
            gameNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            
            game1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        }
        else if udStatus == 2{
            gameNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            
            game2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        }
        
        var gr = Int(greenRenzoku.text ?? "0")  ?? 0
        if renzokuStatus == "G" && modeStatus == "+"{
            gr += 1
            greenRenzoku.text = String(gr)
        }
        else{
            self.initializeRenzoku()
            if modeStatus != "-"{
                renzokuStatus = "G"
                gr += 1
                greenRenzoku.text = String(gr)
            }
        }
        
        greenButton.alpha = 1
        switch udStatus{
        case 1:
            switch modeStatus {
            case "+":
                var greenNumber = Int(greenNumber1Label.text ?? "") ?? 0
                greenNumber += 1
                greenNumber1Label.text = String(greenNumber)
            case "-":
                var greenNumber = Int(greenNumber1Label.text ?? "") ?? 0
                if greenNumber > 0{
                    greenNumber -= 1
                }
                greenNumber1Label.text = String(greenNumber)
            default:
                break
            }
            let gN1 = Int(greenNumber1Label.text ?? "") ?? 0
            if gN1 != 0{
                let gRate1 = (Double(gameNumber1Label.text ?? "") ?? 0) / Double(gN1)
                greenRate1Label.text = "1/" + String(round(gRate1 * 100)/100)
            }
            else {
                greenRate1Label.text = "1/0.0"
            }
            
        case 2:
            switch modeStatus {
            case "+":
                var greenNumber = Int(greenNumber2Label.text ?? "") ?? 0
                greenNumber += 1
                greenNumber2Label.text = String(greenNumber)
            case "-":
                var greenNumber = Int(greenNumber2Label.text ?? "") ?? 0
                if greenNumber > 0{
                    greenNumber -= 1
                }
                greenNumber2Label.text = String(greenNumber)
            default:
                break
            }
            let gN2 = Int(greenNumber2Label.text ?? "") ?? 0
            if gN2 != 0{
                let gRate2 = (Double(gameNumber2Label.text ?? "") ?? 0) / Double(gN2)
                greenRate2Label.text = "1/" + String(round(gRate2 * 100)/100)
            }
            else {
                greenRate2Label.text = "1/0.0"
            }
        default:
            break
        }
        self.saveData()
    }
    
    //押した瞬間色を薄く
    @IBAction func momentYellowButton(_ sender: Any) {
        yellowButton.alpha = 0.3
        
        if udStatus == 1{
            gameNumber1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            whiteNumber1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            redNumber1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            greenNumber1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            yellowNumber1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            blueNumber1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            
            game1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            whiteRate1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            redRate1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            greenRate1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            yellowRate1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            blueRate1Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
        }
        else if udStatus == 2{
            gameNumber2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            whiteNumber2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            redNumber2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            greenNumber2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            yellowNumber2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            blueNumber2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)

            game2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            whiteRate2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            redRate2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            greenRate2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            yellowRate2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
            blueRate2Label.backgroundColor = .rgb(red: 240, green: 230, blue: 140)
        }
        
    }
    //黄色ボタンが押された時
    @IBAction func tappedYellowButton(_ sender: Any) {
        
        if udStatus == 1{
            gameNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            
            game1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        }
        else if udStatus == 2{
            gameNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            
            game2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            whiteRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            redRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            greenRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            yellowRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
            blueRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        }
        
        var yr = Int(yellowRenzoku.text ?? "0")  ?? 0
        if renzokuStatus == "Y" && modeStatus == "+"{
            yr += 1
            yellowRenzoku.text = String(yr)
        }
        else{
            self.initializeRenzoku()
            if modeStatus != "-"{
                renzokuStatus = "Y"
                yr += 1
                yellowRenzoku.text = String(yr)
            }
        }
        
        yellowButton.alpha = 1
        switch udStatus{
        case 1:
            switch modeStatus {
            case "+":
                var yellowNumber = Int(yellowNumber1Label.text ?? "") ?? 0
                yellowNumber += 1
                yellowNumber1Label.text = String(yellowNumber)
            case "-":
                var yellowNumber = Int(yellowNumber1Label.text ?? "") ?? 0
                if yellowNumber > 0{
                    yellowNumber -= 1
                }
                yellowNumber1Label.text = String(yellowNumber)
            default:
                break
            }
            let yN1 = Int(yellowNumber1Label.text ?? "") ?? 0
            if yN1 != 0{
                let yRate1 = (Double(gameNumber1Label.text ?? "") ?? 0) / Double(yN1)
                yellowRate1Label.text = "1/" + String(round(yRate1 * 100)/100)
            }
            else {
                yellowRate1Label.text = "1/0.0"
            }
        case 2:
            switch modeStatus {
            case "+":
                var yellowNumber = Int(yellowNumber2Label.text ?? "") ?? 0
                yellowNumber += 1
                yellowNumber2Label.text = String(yellowNumber)
            case "-":
                var yellowNumber = Int(yellowNumber2Label.text ?? "") ?? 0
                if yellowNumber > 0{
                    yellowNumber -= 1
                }
                yellowNumber2Label.text = String(yellowNumber)
            default:
                break
            }
            let yN2 = Int(yellowNumber2Label.text ?? "") ?? 0
            if yN2 != 0{
                let yRate2 = (Double(gameNumber2Label.text ?? "") ?? 0) / Double(yN2)
                yellowRate2Label.text = "1/" + String(round(yRate2 * 100)/100)
            }
            else {
                yellowRate2Label.text = "1/0.0"
            }
        default:
            break
        }
        self.saveData()
    }
    
    //押した瞬間色を薄く
    @IBAction func momentBlueButton(_ sender: Any) {
        blueButton.alpha = 0.3
        
        if udStatus == 1{
            gameNumber1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            whiteNumber1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            redNumber1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            greenNumber1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            yellowNumber1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            blueNumber1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            
            game1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            whiteRate1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            redRate1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            greenRate1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            yellowRate1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            blueRate1Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
        }
        else if udStatus == 2{
            gameNumber2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            whiteNumber2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            redNumber2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            greenNumber2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            yellowNumber2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            blueNumber2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            
            game2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            whiteRate2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            redRate2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            greenRate2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            yellowRate2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
            blueRate2Label.backgroundColor = .rgb(red: 100, green: 150, blue: 240)
        }
    }
    // 青ボタンが押された時
    @IBAction func tappedBlueButton(_ sender: Any) {
        
        if udStatus == 1{
                  gameNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  whiteNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  redNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  greenNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  yellowNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  blueNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  
                  game1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  whiteRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  redRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  greenRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  yellowRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  blueRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
              }
              else if udStatus == 2{
                  gameNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  whiteNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  redNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  greenNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  yellowNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  blueNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  
                  game2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  whiteRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  redRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  greenRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  yellowRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
                  blueRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
              }
        
        var br = Int(blueRenzoku.text ?? "0")  ?? 0
        if renzokuStatus == "B" && modeStatus == "+"{
            br += 1
            blueRenzoku.text = String(br)
        }
        else{
            self.initializeRenzoku()
            if modeStatus != "-"{
                renzokuStatus = "B"
                br += 1
                blueRenzoku.text = String(br)
            }
            
        }
        
        blueButton.alpha = 1
        
        switch udStatus{
        case 1:
            switch modeStatus {
            case "+":
                var blueNumber = Int(blueNumber1Label.text ?? "") ?? 0
                blueNumber += 1
                blueNumber1Label.text = String(blueNumber)
            case "-":
                var blueNumber = Int(blueNumber1Label.text ?? "") ?? 0
                if blueNumber > 0{
                    blueNumber -= 1
                }
                blueNumber1Label.text = String(blueNumber)
            default:
                break
            }
            let bN1 = Int(blueNumber1Label.text ?? "") ?? 0
            if bN1 != 0{
                let bRate1 = (Double(gameNumber1Label.text ?? "") ?? 0) / Double(bN1)
                blueRate1Label.text = "1/" + String(round(bRate1 * 100)/100)
            }
            else {
                blueRate1Label.text = "1/0.0"
            }
        case 2:
            switch modeStatus {
            case "+":
                var blueNumber = Int(blueNumber2Label.text ?? "") ?? 0
                blueNumber += 1
                blueNumber2Label.text = String(blueNumber)
            case "-":
                var blueNumber = Int(blueNumber2Label.text ?? "") ?? 0
                if blueNumber > 0{
                    blueNumber -= 1
                }
                blueNumber2Label.text = String(blueNumber)
            default:
                break
            }
            let bN2 = Int(blueNumber2Label.text ?? "") ?? 0
            if bN2 != 0{
                let bRate2 = (Double(gameNumber2Label.text ?? "") ?? 0) / Double(bN2)
                blueRate2Label.text = "1/" + String(round(bRate2 * 100)/100)
            }
            else {
                blueRate2Label.text = "1/0.0"
            }
            
        default:
            break
        }
        self.saveData()
    }
    
    @IBOutlet weak var renzokuLabel: UILabel!
    @IBOutlet weak var whiteRenzoku: UILabel!
    @IBOutlet weak var redRenzoku: UILabel!
    @IBOutlet weak var greenRenzoku: UILabel!
    @IBOutlet weak var yellowRenzoku: UILabel!
    @IBOutlet weak var blueRenzoku: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 保持してたデータを取得
        let defaults = UserDefaults.standard
        
        game1 = defaults.array(forKey: "game1") as? [String] ?? ["0", "0"]
        game2 = defaults.array(forKey: "game2") as? [String] ?? ["0", "0"]
        
        all1 = defaults.array(forKey: "all1") as? [String] ?? ["0", "0"]
        all2 = defaults.array(forKey: "all2") as? [String] ?? ["0", "0"]
        
        start1 = defaults.array(forKey: "start1") as? [String] ?? ["0", "0"]
        start2 = defaults.array(forKey: "start2") as? [String] ?? ["0", "0"]
        
        wN = defaults.array(forKey: "wN") as? [[String]] ?? [["0", "0"],  ["0", "0"]]
        rN = defaults.array(forKey: "rN") as? [[String]]  ?? [["0", "0"],  ["0", "0"]]
        gN = defaults.array(forKey: "gN") as? [[String]] ?? [["0", "0"],  ["0", "0"]]
        yN = defaults.array(forKey: "yN") as? [[String]] ?? [["0", "0"], ["0", "0"]]
        bN = defaults.array(forKey: "bN") as? [[String]] ?? [["0", "0"],  ["0", "0"]]
        
        abStatus = defaults.integer(forKey: "abStatus")
        udStatus = defaults.integer(forKey: "udStatus")
        if udStatus == 0{
            udStatus = 1
        }
        
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        timeLabel.text = dateFormatter.string(from: dt)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTime(_ :)), userInfo: nil, repeats: true)
        
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = UIColor.red.cgColor
        resetButton.layer.cornerRadius = 15
        
        koyakuButton.layer.cornerRadius = 15
        koyakuButton.layer.borderColor = UIColor.rgb(red: 70, green: 244, blue: 150).cgColor
        koyakuButton.layer.borderWidth = 2
        
        gameEnterButton.layer.borderWidth = 2
        gameEnterButton.layer.borderColor = UIColor.rgb(red: 70, green: 244, blue: 150).cgColor
        gameEnterButton.layer.cornerRadius = 15
        
        udButton.layer.borderWidth = 2
        udButton.layer.borderColor = UIColor.rgb(red: 70, green: 244, blue: 150).cgColor
        udButton.layer.cornerRadius = 15
        
        modeLabel.layer.cornerRadius = 15
        modeLabel.layer.borderWidth = 2
        modeLabel.layer.borderColor = UIColor.systemTeal.cgColor
        
        modeButton.layer.borderWidth = 2
        modeButton.layer.borderColor = UIColor.rgb(red: 70, green: 244, blue: 150).cgColor
        modeButton.layer.cornerRadius = 15
        
        whiteButton.layer.cornerRadius = 5
        redButton.layer.cornerRadius = 5
        greenButton.layer.cornerRadius = 5
        yellowButton.layer.cornerRadius = 5
        blueButton.layer.cornerRadius = 5
        
        aButton.layer.cornerRadius = 20
        bButton.layer.cornerRadius = 20
        aButton.layer.borderWidth = 2
        bButton.layer.borderWidth = 2
        aButton.layer.borderColor = UIColor.link.cgColor
        bButton.layer.borderColor = UIColor.lightGray.cgColor
        bButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        gameNumber1Label.layer.borderColor = UIColor.orange.cgColor
        whiteNumber1Label.layer.borderColor = UIColor.orange.cgColor
        redNumber1Label.layer.borderColor = UIColor.orange.cgColor
        greenNumber1Label.layer.borderColor = UIColor.orange.cgColor
        yellowNumber1Label.layer.borderColor = UIColor.orange.cgColor
        blueNumber1Label.layer.borderColor = UIColor.orange.cgColor
        game1Label.layer.borderColor = UIColor.orange.cgColor
        whiteRate1Label.layer.borderColor = UIColor.orange.cgColor
        redRate1Label.layer.borderColor = UIColor.orange.cgColor
        greenRate1Label.layer.borderColor = UIColor.orange.cgColor
        yellowRate1Label.layer.borderColor = UIColor.orange.cgColor
        blueRate1Label.layer.borderColor = UIColor.orange.cgColor
        gameNumber2Label.layer.borderColor = UIColor.orange.cgColor
        whiteNumber2Label.layer.borderColor = UIColor.orange.cgColor
        redNumber2Label.layer.borderColor = UIColor.orange.cgColor
        greenNumber2Label.layer.borderColor = UIColor.orange.cgColor
        yellowNumber2Label.layer.borderColor = UIColor.orange.cgColor
        blueNumber2Label.layer.borderColor = UIColor.orange.cgColor
        game2Label.layer.borderColor = UIColor.orange.cgColor
        whiteRate2Label.layer.borderColor = UIColor.orange.cgColor
        redRate2Label.layer.borderColor = UIColor.orange.cgColor
        greenRate2Label.layer.borderColor = UIColor.orange.cgColor
        yellowRate2Label.layer.borderColor = UIColor.orange.cgColor
        blueRate2Label.layer.borderColor = UIColor.orange.cgColor
        
        
        
        
        
        // 受け取ったゲーム数を入れる
        if udStatus == 1{
            gameNumber1Label.text = game1[abStatus]
            gameNumber2Label.text = game2[abStatus]
        }
        else if udStatus == 2{
            gameNumber2Label.text = game2[abStatus]
            gameNumber1Label.text = game1[abStatus]
        }
        
        //データを受け取っていたら表示
        if abStatus == 0{
            
            aButton.layer.borderColor = UIColor.link.cgColor
            aButton.setTitleColor(UIColor.link, for: .normal)
            bButton.layer.borderColor = UIColor.lightGray.cgColor
            bButton.setTitleColor(UIColor.lightGray, for: .normal)
            
            whiteNumber1Label.text = wN[0][0]
            whiteNumber2Label.text = wN[0][1]
            
            redNumber1Label.text = rN[0][0]
            redNumber2Label.text = rN[0][1]
            
            greenNumber1Label.text = gN[0][0]
            greenNumber2Label.text = gN[0][1]
            
            yellowNumber1Label.text = yN[0][0]
            yellowNumber2Label.text = yN[0][1]
            
            blueNumber1Label.text = bN[0][0]
            blueNumber2Label.text = bN[0][1]
        }
        else if abStatus == 1{
            
            aButton.layer.borderColor = UIColor.lightGray.cgColor
            aButton.setTitleColor(UIColor.lightGray, for: .normal)
            bButton.layer.borderColor = UIColor.link.cgColor
            bButton.setTitleColor(UIColor.link, for: .normal)
            
            whiteNumber1Label.text = wN[1][0]
            whiteNumber2Label.text = wN[1][1]
            
            redNumber1Label.text = rN[1][0]
            redNumber2Label.text = rN[1][1]
            
            greenNumber1Label.text = gN[1][0]
            greenNumber2Label.text = gN[1][1]
            
            yellowNumber1Label.text = yN[1][0]
            yellowNumber2Label.text = yN[1][1]
            
            blueNumber1Label.text = bN[1][0]
            blueNumber2Label.text = bN[1][1]
        }
        
        // 起動時の上下
        if udStatus == 1{
            self.dtou()
        }
        else if udStatus == 2{
            self.uTod()
        }
        
        //起動時の+-モード
        if modeStatus == "+"{
            modeStatus = "+"
            modeLabel.text = "＋"
            modeLabel.textColor = .systemTeal
            modeLabel.layer.borderColor = UIColor.systemTeal.cgColor
        }
        else if modeStatus == "-"{
            modeLabel.text = "ー"
            modeLabel.textColor = .systemPink
            modeLabel.layer.borderColor = UIColor.systemPink.cgColor
        }
        
        self.reloadRates()
        self.saveData()
        
    }
    
    // AB管理
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    //Aボタン押された時
    @IBAction func tappedAbutton(_ sender: Any) {
        self.initializeRenzoku()
        if abStatus == 1{
            abStatus = 0
            aButton.layer.borderColor = UIColor.link.cgColor
            aButton.setTitleColor(UIColor.link, for: .normal)
            bButton.layer.borderColor = UIColor.lightGray.cgColor
            bButton.setTitleColor(UIColor.lightGray, for: .normal)
            
            gameNumber1Label.text = game1[0]
            gameNumber2Label.text = game2[0]
            
            wN[1][0] = whiteNumber1Label.text ?? "0"
            wN[1][1] = whiteNumber2Label.text  ?? "0"
            
            rN[1][0] = redNumber1Label.text  ?? "0"
            rN[1][1] = redNumber2Label.text ?? "0"
            
            gN[1][0] = greenNumber1Label.text ?? "0"
            gN[1][1] = greenNumber2Label.text ?? "0"
            
            yN[1][0] = yellowNumber1Label.text ?? "0"
            yN[1][1] = yellowNumber2Label.text ?? "0"
            
            bN[1][0] = blueNumber1Label.text ?? "0"
            bN[1][1] = blueNumber2Label.text ?? "0"
            
            whiteNumber1Label.text = wN[0][0]
            whiteNumber2Label.text = wN[0][1]
            
            redNumber1Label.text = rN[0][0]
            redNumber2Label.text = rN[0][1]
            
            greenNumber1Label.text = gN[0][0]
            greenNumber2Label.text = gN[0][1]
            
            yellowNumber1Label.text = yN[0][0]
            yellowNumber2Label.text = yN[0][1]
            
            blueNumber1Label.text = bN[0][0]
            blueNumber2Label.text = bN[0][1]
            
            self.reloadRates()
        }
        self.saveData()
    }
    //Bボタン押された時
    @IBAction func tappedBbutton(_ sender: Any) {
        self.initializeRenzoku()
        if abStatus == 0{
            abStatus = 1
            aButton.layer.borderColor = UIColor.lightGray.cgColor
            aButton.setTitleColor(UIColor.lightGray, for: .normal)
            bButton.layer.borderColor = UIColor.link.cgColor
            bButton.setTitleColor(UIColor.link, for: .normal)
            
            gameNumber1Label.text = game1[1]
            gameNumber2Label.text = game2[1]
            
            wN[0][0] = whiteNumber1Label.text ?? "0"
            wN[0][1] = whiteNumber2Label.text  ?? "0"
            
            rN[0][0] = redNumber1Label.text  ?? "0"
            rN[0][1] = redNumber2Label.text ?? "0"
            
            gN[0][0] = greenNumber1Label.text ?? "0"
            gN[0][1] = greenNumber2Label.text ?? "0"
            
            yN[0][0] = yellowNumber1Label.text ?? "0"
            yN[0][1] = yellowNumber2Label.text ?? "0"
            
            bN[0][0] = blueNumber1Label.text ?? "0"
            bN[0][1] = blueNumber2Label.text ?? "0"
            
            whiteNumber1Label.text = wN[1][0]
            whiteNumber2Label.text = wN[1][1]
            
            redNumber1Label.text = rN[1][0]
            redNumber2Label.text = rN[1][1]
            
            greenNumber1Label.text = gN[1][0]
            greenNumber2Label.text = gN[1][1]
            
            yellowNumber1Label.text = yN[1][0]
            yellowNumber2Label.text = yN[1][1]
            
            blueNumber1Label.text = bN[1][0]
            blueNumber2Label.text = bN[1][1]
            
            self.reloadRates()
        }
        self.saveData()
    }
    
    // 入力画面から戻ってきた時に確率を表示する
    func reloadRates(){
        print("ｷﾀ━━━━(ﾟ∀ﾟ)━━━━!!")
        //koyakuでの小役も反映
        if udStatus == 1{
            whiteNumber1Label.text = wN[abStatus][0]
            redNumber1Label.text = rN[abStatus][0]
            greenNumber1Label.text = gN[abStatus][0]
            yellowNumber1Label.text = yN[abStatus][0]
            blueNumber1Label.text = bN[abStatus][0]
        }
        else if udStatus == 2{
            whiteNumber2Label.text = wN[abStatus][1]
            redNumber2Label.text = rN[abStatus][1]
            greenNumber2Label.text = gN[abStatus][1]
            yellowNumber2Label.text = yN[abStatus][1]
            blueNumber2Label.text = bN[abStatus][1]
        }
        
        let g1 = Double(gameNumber1Label.text ?? "") ?? 0
        let g2 = Double(gameNumber2Label.text ?? "") ?? 0
        let wN1 = Double(whiteNumber1Label.text ?? "") ?? 0
        let wN2 = Double(whiteNumber2Label.text ?? "") ?? 0
        let rN1 = Double(redNumber1Label.text ?? "") ?? 0
        let rN2 = Double(redNumber2Label.text ?? "") ?? 0
        let gN1 = Double(greenNumber1Label.text ?? "") ?? 0
        let gN2 = Double(greenNumber2Label.text ?? "") ?? 0
        let yN1 = Double(yellowNumber1Label.text ?? "") ?? 0
        let yN2 = Double(yellowNumber2Label.text ?? "") ?? 0
        let bN1 = Double(blueNumber1Label.text ?? "") ?? 0
        let bN2 = Double(blueNumber2Label.text ?? "") ?? 0
        
        
        
        //白確率
        if wN1 != 0{
            whiteRate1Label.text = "1/" + String(round((g1/wN1) * 100) / 100)
        }
        else{
            whiteRate1Label.text = "1/0.0"
        }
        if wN2 != 0{
            whiteRate2Label.text = "1/" + String(round((g2/wN2) * 100) / 100)
        }
        else{
            whiteRate2Label.text = "1/0.0"
        }
        
        //赤確率
        if rN1 != 0{
            redRate1Label.text = "1/" + String(round((g1/rN1) * 100) / 100)
        }
        else{
            redRate1Label.text = "1/0.0"
        }
        if rN2 != 0{
            redRate2Label.text = "1/" + String(round((g2/rN2) * 100) / 100)
        }
        else{
            redRate2Label.text = "1/0.0"
        }
        
        //緑確率
        if gN1 != 0{
            greenRate1Label.text = "1/" + String(round((g1/gN1) * 100) / 100)
        }
        else{
            greenRate1Label.text = "1/0.0"
        }
        if gN2 != 0{
            greenRate2Label.text = "1/" + String(round((g2/gN2) * 100) / 100)
        }
        else{
            greenRate2Label.text = "1/0.0"
        }
        
        //黄確率
        if yN1 != 0{
            yellowRate1Label.text = "1/" + String(round((g1/yN1) * 100) / 100)
        }
        else{
            yellowRate1Label.text = "1/0.0"
        }
        if yN2 != 0{
            yellowRate2Label.text = "1/" + String(round((g2/yN2) * 100) / 100)
        }
        else{
            yellowRate2Label.text = "1/0.0"
        }
        
        //青確率
        if bN1 != 0{
            blueRate1Label.text = "1/" + String(round((g1/bN1) * 100) / 100)
        }
        else{
            blueRate1Label.text = "1/0.0"
        }
        if bN2 != 0{
            blueRate2Label.text = "1/" + String(round((g2/bN2) * 100) / 100)
        }
        else{
            blueRate2Label.text = "1/0.0"
        }
        self.saveData()
    }
    
    //リセットを押されたら警告を出す
    func alert(title: String, message: String){
        var alertController: UIAlertController!
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("OK")
            self.reset()
        }))
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            (action: UIAlertAction!) -> Void in
            print("cansel")
        }))
        present(alertController, animated: true)
    }
    func reset(){
        
        // 見えてる全数値を0に
        gameNumber1Label.text = "0"
        whiteNumber1Label.text = "0"
        redNumber1Label.text = "0"
        greenNumber1Label.text = "0"
        yellowNumber1Label.text = "0"
        blueNumber1Label.text = "0"
        whiteRate1Label.text = "1/0.0"
        redRate1Label.text = "1/0.0"
        greenRate1Label.text = "1/0.0"
        yellowRate1Label.text = "1/0.0"
        blueRate1Label.text = "1/0.0"
        gameNumber2Label.text = "0"
        whiteNumber2Label.text = "0"
        redNumber2Label.text = "0"
        greenNumber2Label.text = "0"
        yellowNumber2Label.text = "0"
        blueNumber2Label.text = "0"
        whiteRate2Label.text = "1/0.0"
        redRate2Label.text = "1/0.0"
        greenRate2Label.text = "1/0.0"
        yellowRate2Label.text = "1/0.0"
        blueRate2Label.text = "1/0.0"
        
        wN[0][0] = "0"
        wN[0][1] = "0"
        
        rN[0][0] = "0"
        rN[0][1] = "0"
        
        gN[0][0] = "0"
        gN[0][1] = "0"
        
        yN[0][0] = "0"
        yN[0][1] = "0"
        
        bN[0][0] = "0"
        bN[0][1] = "0"
        
        wN[1][0] = "0"
        wN[1][1] = "0"
        
        rN[1][0] = "0"
        rN[1][1] = "0"
        
        gN[1][0] = "0"
        gN[1][1] = "0"
        
        yN[1][0] = "0"
        yN[1][1] = "0"
        
        bN[1][0] = "0"
        bN[1][1] = "0"
        
        // 入力画面の隠しデータも全部0に
        game1 = ["0", "0"]
        game2 = ["0", "0"]
        all1 = ["0", "0"]
        all2 = ["0", "0"]
        start1 = ["0", "0"]
        start2 = ["0", "0"]
        
        //下だったら上に移動
        if udStatus != 1{
            udStatus = 1
            self.dtou()
        }
        
        self.initializeRenzoku()
        
        abStatus = 0
        aButton.layer.borderColor = UIColor.link.cgColor
        aButton.setTitleColor(UIColor.link, for: .normal)
        bButton.layer.borderColor = UIColor.lightGray.cgColor
        bButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        modeStatus = "+"
        modeLabel.text = "＋"
        modeLabel.textColor = .systemTeal
        modeLabel.layer.borderColor = UIColor.systemTeal.cgColor
        
        self.saveData()
        
    }
    
    // 上から下へ
    func uTod(){
        //上段を無効に
        gameNumber1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        whiteNumber1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        redNumber1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        greenNumber1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        yellowNumber1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        blueNumber1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        
        game1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        whiteRate1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        redRate1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        greenRate1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        yellowRate1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        blueRate1Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        
        gameNumber1Label.layer.borderWidth = 0
        whiteNumber1Label.layer.borderWidth = 0
        redNumber1Label.layer.borderWidth = 0
        greenNumber1Label.layer.borderWidth = 0
        yellowNumber1Label.layer.borderWidth = 0
        blueNumber1Label.layer.borderWidth = 0
        game1Label.layer.borderWidth = 0
        whiteRate1Label.layer.borderWidth = 0
        redRate1Label.layer.borderWidth = 0
        greenRate1Label.layer.borderWidth = 0
        yellowRate1Label.layer.borderWidth = 0
        blueRate1Label.layer.borderWidth = 0
        
        // 下段を有効に
        gameNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        whiteNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        redNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        greenNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        yellowNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        blueNumber2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        
        game2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        whiteRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        redRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        greenRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        yellowRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        blueRate2Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        
        gameNumber2Label.layer.borderWidth = 1
        whiteNumber2Label.layer.borderWidth = 1
        redNumber2Label.layer.borderWidth = 1
        greenNumber2Label.layer.borderWidth = 1
        yellowNumber2Label.layer.borderWidth = 1
        blueNumber2Label.layer.borderWidth = 1
        game2Label.layer.borderWidth = 1
        whiteRate2Label.layer.borderWidth = 1
        redRate2Label.layer.borderWidth = 1
        greenRate2Label.layer.borderWidth = 1
        yellowRate2Label.layer.borderWidth = 1
        blueRate2Label.layer.borderWidth = 1
        
    }
    
    //下から上へ
    func  dtou(){
        //下段を無効に
        gameNumber2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        whiteNumber2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        redNumber2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        greenNumber2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        yellowNumber2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        blueNumber2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        
        game2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        whiteRate2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        redRate2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        greenRate2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        yellowRate2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        blueRate2Label.backgroundColor = .rgb(red: 80, green: 80, blue: 90)
        
        gameNumber2Label.layer.borderWidth = 0
        whiteNumber2Label.layer.borderWidth = 0
        redNumber2Label.layer.borderWidth = 0
        greenNumber2Label.layer.borderWidth = 0
        yellowNumber2Label.layer.borderWidth = 0
        blueNumber2Label.layer.borderWidth = 0
        game2Label.layer.borderWidth = 0
        whiteRate2Label.layer.borderWidth = 0
        redRate2Label.layer.borderWidth = 0
        greenRate2Label.layer.borderWidth = 0
        yellowRate2Label.layer.borderWidth = 0
        blueRate2Label.layer.borderWidth = 0
        
        
        //上段を有効に
        gameNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        whiteNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        redNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        greenNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        yellowNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        blueNumber1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        
        game1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        whiteRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        redRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        greenRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        yellowRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        blueRate1Label.backgroundColor = .rgb(red: 229, green: 229, blue: 234)
        
        gameNumber1Label.layer.borderWidth = 1
        whiteNumber1Label.layer.borderWidth = 1
        redNumber1Label.layer.borderWidth = 1
        greenNumber1Label.layer.borderWidth = 1
        yellowNumber1Label.layer.borderWidth = 1
        blueNumber1Label.layer.borderWidth = 1
        game1Label.layer.borderWidth = 1
        whiteRate1Label.layer.borderWidth = 1
        redRate1Label.layer.borderWidth = 1
        greenRate1Label.layer.borderWidth = 1
        yellowRate1Label.layer.borderWidth = 1
        blueRate1Label.layer.borderWidth = 1
    }
    
    func initializeRenzoku(){
        
        whiteRenzoku.text = "0"
        redRenzoku.text = "0"
        greenRenzoku.text = "0"
        yellowRenzoku.text = "0"
        blueRenzoku.text = "0"
        
        renzokuStatus = ""
    }
    
    //データを保持
    func saveData(){
        let defaults = UserDefaults.standard
        defaults.set(game1, forKey: "game1")
        defaults.set(game2, forKey: "game2")
        defaults.set(all1, forKey: "all1")
        defaults.set(all2, forKey: "all2")
        defaults.set(start1, forKey: "start1")
        defaults.set(start2, forKey: "start2")
        
        if abStatus == 0{
            wN[0][0] = whiteNumber1Label.text ?? "0"
            wN[0][1] = whiteNumber2Label.text  ?? "0"
            
            rN[0][0] = redNumber1Label.text  ?? "0"
            rN[0][1] = redNumber2Label.text ?? "0"
            
            gN[0][0] = greenNumber1Label.text ?? "0"
            gN[0][1] = greenNumber2Label.text ?? "0"
            
            yN[0][0] = yellowNumber1Label.text ?? "0"
            yN[0][1] = yellowNumber2Label.text ?? "0"
            
            bN[0][0] = blueNumber1Label.text ?? "0"
            bN[0][1] = blueNumber2Label.text ?? "0"
        }
        else if abStatus == 1{
            wN[1][0] = whiteNumber1Label.text ?? "0"
            wN[1][1] = whiteNumber2Label.text  ?? "0"
            
            rN[1][0] = redNumber1Label.text  ?? "0"
            rN[1][1] = redNumber2Label.text ?? "0"
            
            gN[1][0] = greenNumber1Label.text ?? "0"
            gN[1][1] = greenNumber2Label.text ?? "0"
            
            yN[1][0] = yellowNumber1Label.text ?? "0"
            yN[1][1] = yellowNumber2Label.text ?? "0"
            
            bN[1][0] = blueNumber1Label.text ?? "0"
            bN[1][1] = blueNumber2Label.text ?? "0"
        }
        
        defaults.set(wN, forKey: "wN")
        defaults.set(rN, forKey: "rN")
        defaults.set(gN, forKey: "gN")
        defaults.set(yN, forKey: "yN")
        defaults.set(bN, forKey: "bN")
        
        defaults.set(abStatus, forKey: "abStatus")
        defaults.set(udStatus, forKey: "udStatus")
        defaults.set(modeStatus, forKey: "modeStatus")
        
    }
    
    @objc func reloadTime(_ sender: Timer){
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        timeLabel.text = dateFormatter.string(from: dt)
    }
}

