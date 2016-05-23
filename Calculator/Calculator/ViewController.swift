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
  @IBOutlet weak var operationDescription: UILabel!
  @IBOutlet weak var piButton: UIButton!

  private var userIsInTheMiddleOfTyping = false
  private var brain = CalculatorBrain()

  @IBAction private func touchDigit(sender: UIButton) {
    let digit = sender.currentTitle!
    let textCurrentlyInDisplay = display.text!

    if userIsInTheMiddleOfTyping {
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

  @IBAction private func performOperation(sender: UIButton) {
    if userIsInTheMiddleOfTyping {
      brain.setOperand(displayValue)
      userIsInTheMiddleOfTyping = false
    }
    if let mathematicalSymbol = sender.currentTitle {
      brain.performOperation(mathematicalSymbol)
    }
    if brain.isPartialResult {
      operationDescValue = brain.description + "…"
    } else {
      operationDescValue = brain.description + "="
    }

    displayValue = brain.result
  }

  @IBAction private func allClear(sender: UIButton) {
    display.text = "0"
    operationDescription.text = " "
    brain.clearAll()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    piButton.layer.borderColor = UIColor.blackColor().CGColor
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  private var displayValue: Double {
    get {
      return Double(display.text!)!
    }
    set {
      display.text = String(newValue)
    }
  }

  private var operationDescValue: String {
    get {
      return operationDescription.text!
    }
    set {
      operationDescription.text = newValue
    }
  }
}
