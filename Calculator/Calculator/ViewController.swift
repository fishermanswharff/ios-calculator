//
//  ViewController.swift
//  Calculator
//
//  Created by Jason Wharff on 5/20/16.
//  Copyright © 2016 fishermanswharff. All rights reserved.
//

// uikit is a module
// has all the user interface things, you're almost always going to import uikit
import UIKit

// ViewController inherits from UIViewController
// All controllers in Swift apps must inherit from UIViewController
class ViewController: UIViewController {

  //
  @IBOutlet private weak var display: UILabel!

  private var userIsInTheMiddleOfTyping = false
  // func => method on a class
  // you could have global funcs as well, outside the definition of the class.
  // you can pass other arguments, argumentName: keyWord
  @IBAction private func touchDigit(sender: UIButton) {
    // to call methods on the class, use the 'self' syntax
    //  self.touchDigit(someButton, otherArgument: 5)

    let digit = sender.currentTitle!

    // print("touched \(digit)")
    // Optionals: in swift, there is a type called 'Optional'
    // this type can only have two values: notSet (nil), and set
    // if it's in a set state, it will have an associated value.
    // swift will infer the type of the digit, in this case, currentTitle is a String? (Optional) so digit is inferred to be a String?
    // You get the associated value out of an optional by using !

    if userIsInTheMiddleOfTyping {
      let textCurrentlyInDisplay = display.text!
      display.text = textCurrentlyInDisplay + digit
    } else {
      display.text = digit
    }
    userIsInTheMiddleOfTyping = true

    // you can set optionals to an associated value or nil
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
}
