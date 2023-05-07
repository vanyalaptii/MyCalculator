//
//  ViewController.swift
//  MyCalculator
//
//  Created by Ваня Лаптий on 01.05.2023.
//

import UIKit

enum CurrentNumber {
    case firstNumber
    case secondNumber
}

class CalculatorController: UIViewController {
    
    //    let viewModel = CalculatorControllerViewModel()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let displayLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 85)
        return label
    }()
    
    let calculatorButtonCells: [[CalculatorButton]] = [
        [.allClear, .negative, .percentage, .divide],
        [.number (7), .number (8), .number (9), .multiply],
        [.number (4), .number (5), .number (6), .subtract],
        [.number (1), .number (2), .number (3), .add],
        [.number (0), .decimal, .equals]
    ]
    
    private(set) var currentNumber: CurrentNumber = .firstNumber
    
    private(set) var firstNumber: String? = nil {
        didSet {
            self.displayLabel.text = self.firstNumber?.description ?? "0"
        }
    }
    
    private(set) var secondNumber: String? = nil {
        didSet {
            self.displayLabel.text = self.secondNumber?.description ?? "0"
        }
    }
    
    private var equalIsPressed: Bool = false
    
    private var currentOperation: CalculatorOperation? = nil
    
    private(set) var firstNumberIsDecimal: Bool = false
    private(set) var secondNumberIsDecimal: Bool = false
    
    private(set) var prevNumber: String? = nil
    private(set) var prevOperation: CalculatorOperation? = nil
    
    var eitherNumberIsDecimal: Bool {
        return firstNumberIsDecimal || secondNumberIsDecimal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupStackView()
        setupDisplayLabel()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
        
        for row in calculatorButtonCells {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            
            let rowSubStackView = UIStackView()
            rowSubStackView.axis = .horizontal
            rowSubStackView.spacing = 10
            rowSubStackView.alignment = .fill
            rowSubStackView.distribution = .fillEqually
            
            for buttonCell in row {
                let button = CalculatorButtonView(calculatorButton: buttonCell)
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                if buttonCell.title == "." {
                    rowSubStackView.addArrangedSubview(button)
                } else if buttonCell.title == "="{
                    rowSubStackView.addArrangedSubview(button)
                    rowStackView.addArrangedSubview(rowSubStackView)
                } else {
                    rowStackView.addArrangedSubview(button)
                }
            }
            stackView.addArrangedSubview(rowStackView)
        }
    }
    
    private func setupDisplayLabel() {
        view.addSubview(displayLabel)
        displayLabel.text = "0"
        
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        displayLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10).isActive = true
        displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }
}

extension CalculatorController {
    
    @objc private func buttonTapped(_ sender: CalculatorButtonView) {
        let button = sender.calculatorButton
        switch button {
        case .allClear:
            didSelectAllClear()
        case .equals:
            didSelectEqualsButton()
        case .add:
            didSelectOperation(with: .add)
        case .divide:
            didSelectOperation(with: .divide)
        case .multiply:
            didSelectOperation(with: .multiply)
        case .subtract:
            didSelectOperation(with: .subtract)
        case .number(_):
            didSelectNumberButton(with: button.title)
        case .decimal:
            didSelectDecimalButton()
        case .negative:
            didSelectNegative()
        case .percentage:
            didSelectPercentage()
        }
    }
}

extension CalculatorController {
    
    private func didSelectAllClear() {
        displayLabel.text = "0"
        firstNumber = nil
        secondNumber = nil
        currentNumber = .firstNumber
        currentOperation = nil
        firstNumberIsDecimal = false
        secondNumberIsDecimal = false
        prevNumber = nil
        prevOperation = nil
    }
    
    private func didSelectNumberButton(with buttonTitle: String) {
        
        if equalIsPressed  && currentNumber == .firstNumber {
            didSelectAllClear()
            equalIsPressed = false
        }
        
        displayLabel.text?.append(buttonTitle)
        while displayLabel.text?.first == "0"
                && displayLabel.text?.count ?? 1 > 1 {
            displayLabel.text?.removeFirst()
        }
        
        if currentNumber == .firstNumber {
            if var firstNumber = firstNumber {
                firstNumber.append(buttonTitle)
                self.firstNumber = firstNumber
                prevNumber = firstNumber
            } else {
               firstNumber = buttonTitle
                prevNumber = buttonTitle
            }
        } else {
            if var secondNumber = self.secondNumber {
                secondNumber.append(buttonTitle)
                self.secondNumber = secondNumber
                prevNumber = secondNumber
            } else {
                self.secondNumber = buttonTitle
                prevNumber = buttonTitle
            }
        }
    }
    
    private func didSelectNegative() {
        if displayLabel.text?.first != "-" {
            displayLabel.text?.insert("-", at: displayLabel.text!.startIndex)
        } else if displayLabel.text?.first == "-" {
            displayLabel.text?.removeFirst()
        }
    }
    
    private func didSelectDecimalButton() {
        displayLabel.text?.append(".")
        if displayLabel.text?.first == "0" {
            displayLabel.text?.removeFirst()
        }
        if displayLabel.text?.first == "." {
            displayLabel.text?.insert("0", at: displayLabel.text!.startIndex)
        }
    }
    
    private func didSelectPercentage() {
        if currentNumber == .firstNumber,
           var number = firstNumber?.toDouble {
            
            number /= 100
            
            if number.isInteger {
                firstNumber = number.toInt?.description
            } else {
                firstNumber = number.description
                firstNumberIsDecimal = true
            }
        } else if currentNumber == .secondNumber,
                  var number = secondNumber?.toDouble {
            
            number /= 100
            
            if number.isInteger {
                secondNumber = number.toInt?.description
            } else {
                secondNumber = number.description
                secondNumberIsDecimal = true
            }
        }
    }
    
    private func didSelectEqualsButton() {
        if let operation = currentOperation,
           let firstNumber = firstNumber?.toDouble,
           let secondNumber = secondNumber?.toDouble {
            
            let result = getOperationResult(operation, firstNumber, secondNumber)
            displayLabel.text = eitherNumberIsDecimal ? result.description : result.toInt?.description
            
            self.secondNumber = nil
            prevOperation = operation
            currentOperation = nil
            self.firstNumber = eitherNumberIsDecimal ? result.description : result.toInt?.description
            currentNumber = .firstNumber
            
        } else if let prevOperation = prevOperation,
                  let firstNumber = firstNumber?.toDouble,
                  let prevNumber = prevNumber?.toDouble {
            let result = getOperationResult(prevOperation, firstNumber, prevNumber)
            let resultString = eitherNumberIsDecimal ? result.description : result.toInt?.description
            self.firstNumber = resultString
        }
        equalIsPressed = true
    }
    
    private func didSelectOperation(with operation: CalculatorOperation) {
        if currentNumber == .firstNumber {
            currentOperation = operation
            currentNumber = .secondNumber
        } else if self.currentNumber == .secondNumber {
            
            if let prevOperation = currentOperation,
               let firstNumber = firstNumber?.toDouble,
               let secondNumber = secondNumber?.toDouble {
                
                let result = getOperationResult(prevOperation, firstNumber, secondNumber)
                displayLabel.text = eitherNumberIsDecimal ? result.description : result.toInt?.description
                
                self.secondNumber = nil
                self.firstNumber = eitherNumberIsDecimal ? result.description : result.toInt?.description
                currentNumber = .secondNumber
                currentOperation = operation
            } else {
                currentOperation = operation
            }
        }
    }
    
    private func getOperationResult(_ operation: CalculatorOperation,
                                    _ firstNumber: Double?,
                                    _ secondNumber: Double?) -> Double {
        
        guard let firstNumber = firstNumber, let secondNumber = secondNumber else { return 0 }

        switch operation {
        case .divide:
            return firstNumber / secondNumber
        case .multiply:
            return firstNumber * secondNumber
        case .subtract:
            return firstNumber - secondNumber
        case .add:
            return firstNumber + secondNumber
        }
    }
}
