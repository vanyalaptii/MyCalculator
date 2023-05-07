//
//  CalculatorButton.swift
//  MyCalculator
//
//  Created by Ваня Лаптий on 02.05.2023.
//

import UIKit

class CalculatorButtonView: UIButton {
    
    private(set) var calculatorButton: CalculatorButton
 
    init(calculatorButton: CalculatorButton) {
        self.calculatorButton = calculatorButton
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.setTitle(calculatorButton.title, for: .normal)
        self.layer.cornerRadius = 36
        self.titleLabel?.textColor = .white
        self.backgroundColor = calculatorButton.color
        self.titleLabel?.font = .systemFont(ofSize: 30)
    }
}

    

