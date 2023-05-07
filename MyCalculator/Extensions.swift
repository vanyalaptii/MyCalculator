//
//  Extensions.swift
//  MyCalculator
//
//  Created by Ваня Лаптий on 06.05.2023.
//

import Foundation

extension String {
    var toDouble: Double? {
        Double(self)
    }
}

extension Double {
    var toInt: Int? {
        Int(self)
    }
}

extension FloatingPoint {
    var isInteger: Bool {
        rounded() == self
    }
}
