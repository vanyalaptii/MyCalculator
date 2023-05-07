//
//  CalculatorOperation.swift
//  MyCalculator
//
//  Created by Ваня Лаптий on 06.05.2023.
//

import Foundation

enum CalculatorOperation {
    case divide
    case multiply
    case subtract
    case add
    
    var title: String {
        switch self {
        case .divide:
            return "÷"
        case .multiply:
            return "×"
        case .subtract:
            return "-"
        case .add:
            return "+"
        }
    }
}
