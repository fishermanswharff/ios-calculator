//
//  ViewController.swift
//  Calculator
//
//  Created by Jason Wharff on 5/20/16.
//  Copyright © 2016 fishermanswharff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet private weak var display: UILabel!

  private var userIsInTheMiddleOfTyping = false

  @IBAction private func touchDigit(sender: UIButton) {

    let digit = sender.currentTitle!

    if userIsInTheMiddleOfTyping {
      let textCurrentlyInDisplay = display.text!

      if digit == "." {
        if textCurrentlyInDisplay.rangeOfString(".") == nil {
          display.text = textCurrentlyInDisplay + "."
        }
      } else {
        display.text = textCurrentlyInDisplay + digit
      }
    } else {
      display.text = digit
    }
    userIsInTheMiddleOfTyping = true
  }

  private var displayValue: Double {
    get {
      return Double(display.text!)!
    }
    set {
      display.text = String(newValue)
    }
  }

  private var brain = CalculatorBrain()

  @IBAction private func performOperation(sender: UIButton) {
    if userIsInTheMiddleOfTyping {
      brain.setOperand(displayValue)
      userIsInTheMiddleOfTyping = false
    }
    if let mathematicalSymbol = sender.currentTitle {
      brain.performOperation(mathematicalSymbol)
    }

    displayValue = brain.result
  }

  @IBAction private func allClear(sender: UIButton) {
    display.text = "0"
    brain.clearAll()
  }
}
