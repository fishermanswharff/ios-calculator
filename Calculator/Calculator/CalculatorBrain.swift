//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jason Wharff on 5/21/16.
//  Copyright © 2016 fishermanswharff. All rights reserved.
//

import Foundation

class CalculatorBrain {
  var isPartialResult = false
  var result: Double {
    get {
      return accumulator
    }
  }
  var description: String {
    get {
      return descriptionString
    }
  }

  private var accumulator = 0.0
  private var descriptionString = ""
  private var pending: PendingBinaryOperationInformation?

  func setOperand(operand: Double) {
    accumulator = operand
    descriptionString += "\(String(operand)) "
  }

  func performOperation(symbol: String) {
    if let operation = operations[symbol] {
      switch operation {
      case .Constant(let value):
        accumulator = value
        descriptionString += "\(symbol) "
      case .UnaryOperation(let function):
        accumulator = function(accumulator)
        descriptionString = ""
      case .BinaryOperation(let function):
        executePendingBinaryOperation()
        pending = PendingBinaryOperationInformation(binaryFunction: function, firstOperand: accumulator)
        descriptionString += "\(symbol) "
      case .Equals:
        executePendingBinaryOperation()
      case .RandomNumber(let function):
        accumulator = function()
      }
    }
  }

  func clearAll() {
    pending = nil
    accumulator = 0.0
    descriptionString = " "
  }

  private var operations: Dictionary<String,Operation> = [
    "π": Operation.Constant(M_PI),
    "e": Operation.Constant(M_E),
    "Rand": Operation.RandomNumber(CalculatorBrain.randomNumberGenerator),
    "√": Operation.UnaryOperation(sqrt),
    "cos": Operation.UnaryOperation(cos),
    "%": Operation.UnaryOperation({ $0 / 100 }),
    "±": Operation.UnaryOperation({ -$0 }),
    "×": Operation.BinaryOperation({ $0 * $1 }),
    "÷": Operation.BinaryOperation({ $0 / $1 }),
    "+": Operation.BinaryOperation({ $0 + $1 }),
    "−": Operation.BinaryOperation({ $0 - $1 }),
    "=": Operation.Equals
  ]

  private enum Operation {
    case Constant(Double)
    case UnaryOperation((Double) -> Double)
    case BinaryOperation((Double, Double) -> Double)
    case RandomNumber(() -> Double)
    case Equals
  }

  private struct PendingBinaryOperationInformation {
    var binaryFunction: (Double, Double) -> Double
    var firstOperand: Double
  }

  private static func randomNumberGenerator() -> Double {
    return drand48()
  }

  private func executePendingBinaryOperation(){
    isPartialResult = true
    if pending != nil {
      accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
      pending = nil
      isPartialResult = false
    }
  }
}
