//
//  CalculatorBrian.swift
//  Calculator
//
//  Created by s20171103186 on 2018/10/26.
//  Copyright © 2018 s20171103186. All rights reserved.
//

import Foundation


struct CalculatorBrain {
    private var accumulator: Double?
    
    private enum Operation{
        case constant(Double)         //常量
        case unaryOperation((Double)-> Double)   //一元计算
        case binaryOperation((Double,Double) -> Double)    //二元计算
        case equels
        case clear
    }
    
    private var operations: Dictionary<String,Operation> = [
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "∓" : Operation.unaryOperation({ -$0 }),
        "×" : Operation.binaryOperation({ $0 * $1}),
        "÷" : Operation.binaryOperation({ $0 / $1}),
        "+" : Operation.binaryOperation({ $0 + $1}),
        "-" : Operation.binaryOperation({ $0 - $1}),
        "=" : Operation.equels,
        "AC": Operation.clear
    ]
    mutating func performOperation(_ symbol: String )  {
        if let operation = operations[symbol]{
            switch operation{
            case.constant(let value):
                accumulator = value
            case.unaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case.binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperand(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case.equels:
                performPendingBinaryOperation()
            case.clear:
                if accumulator != nil{
                    accumulator = 0
                }
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperand?
    
    private struct PendingBinaryOperand {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand,secondOperand)
        }
    }
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    
    var result: Double? {
        get{
            return accumulator
        }
    }
}

