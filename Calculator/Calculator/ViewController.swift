//
//  ViewController.swift
//  Calculator
//
//  Created by 刘信一 on 2017/6/28.
//  Copyright © 2017年 刘信一. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.addUnaryOperation(named: "✅") { [weak weakSelf = self] in
            weakSelf?.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    @IBAction func touchDigtit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if clearButton.currentTitle == "AC" {
            clearButton.setTitle("C", for: .normal)
        }
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: String {
        get {
            return display.text!
        }
        set {
            display.text = newValue
        }
    }
    
    private var brain = CalculatorBrain()
    
    private func formattedValue(of Value: String) -> String
    {
        var Value = Value
        var i = 1
        if Value.contains(".")
        {
            while i < Value.characters.count
            {
                if Value.hasSuffix("0") {
                    Value.remove(at: Value.index(before: Value.endIndex))
                } else {
                    break
                }
                i += 1
            }
            if Value.hasSuffix(".") {
                Value.remove(at: Value.index(before: Value.endIndex))
            }
        }
        return Value
    }
    
    @IBAction func addDot(_ sender: UIButton) {
        if clearButton.currentTitle == "AC" {
            clearButton.setTitle("C", for: .normal)
        }
        
        if userIsInTheMiddleOfTyping {
            display.text = display.text! + "."
        } else {
            display.text = "0."
            userIsInTheMiddleOfTyping = true
        }
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(Double(displayValue)!)
            clearButton.setTitle("C", for: .normal)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = formattedValue(of: String(result))
        }
    }
    
    @IBAction func clearScreen(_ sender: UIButton) {
        if sender.currentTitle == "C" {
            display.text = "0"
            clearButton.setTitle("AC", for: .normal)
        } else if sender.currentTitle == "AC" {
            display.text = "0"
            brain.allClear()
        } else {
            clearButton.setTitle("AC", for: .normal)
        }
    }
    
    @IBOutlet weak var clearButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

