//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jason Wharff on 5/21/16.
//  Copyright © 2016 fishermanswharff. All rights reserved.
//

import Foundation

class CalculatorBrain {
  private var accumulator = 0.0

  func setOperand(operand: Double) {
    accumulator = operand
  }

  func performOperation(symbol: String) {
    if let operation = operations[symbol] {
      switch operation {
      case .Constant(let value):
        accumulator = value
      case .UnaryOperation(let function):
        accumulator = function(accumulator)
      case .BinaryOperation(let function):
        executePendingBinaryOperation()
        pending = PendingBinaryOperationInformation(binaryFunction: function, firstOperand: accumulator)
      case .Equals:
        executePendingBinaryOperation()
      }
    }
  }

  func clearAll() {
    pending = nil
    accumulator = 0.0
  }

  private var pending: PendingBinaryOperationInformation?

  private var operations: Dictionary<String,Operation> = [
    "π": Operation.Constant(M_PI),
    "e": Operation.Constant(M_E),
    "√": Operation.UnaryOperation(sqrt),
    "cos": Operation.UnaryOperation(cos),
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
    case Equals
  }

  private struct PendingBinaryOperationInformation {
    var binaryFunction: (Double, Double) -> Double
    var firstOperand: Double
  }

  private func executePendingBinaryOperation(){
    if pending != nil {
      accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
      pending = nil
    }
  }


  var result: Double {
    get {
      return accumulator
    }
  }
}