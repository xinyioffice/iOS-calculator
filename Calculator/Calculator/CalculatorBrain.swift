//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 刘信一 on 2017/6/29.
//  Copyright © 2017年 刘信一. All rights reserved.
//

import Foundation

/*
func changeSign(operand: Double) -> Double {
    return -operand
}

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

func divide(op1: Double, op2: Double) -> Double {
    return op1 / op2
}

func minus(op1: Double, op2: Double) -> Double {
    return op1 - op2
}
*/

struct CalculatorBrain {
    
    mutating func addUnaryOperation(named Symbol: String, _ operation: @escaping (Double) -> Double) {
        operations[Symbol] = Operation.unaryOperation(operation)
    }
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),//(changeSign)
        "×" : Operation.binaryOperation({ $0 * $1 }),//used to be (multiply), now repalced
        "÷" : Operation.binaryOperation({ $0 / $1 }),//(divide)
        "+" : Operation.binaryOperation({ $0 + $1 }),//(add)
        "−" : Operation.binaryOperation({ $0 - $1 }),//(minus)
        "=" : Operation.equals
    ]
    
    mutating func performOperation (_ symbol: String) {
        if let operation = operations[symbol] {
            switch  operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pedingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating func clear () {
        accumulator = nil
    }
    
    mutating func allClear () {
        pedingBinaryOperation = nil
        accumulator = nil
    }
    
    private mutating func performPendingBinaryOperation() {
        if pedingBinaryOperation != nil && accumulator != nil {
            accumulator = pedingBinaryOperation!.perform(with: accumulator!)
            pedingBinaryOperation = nil
        }
    }
    
    private var pedingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    
    mutating func setOperand (_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
