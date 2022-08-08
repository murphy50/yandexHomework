import Foundation
import UIKit

class MainTableHeaderUIView:  UIView {
    let completionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorPalette.tertiary.color
        label.text = "Выполнено — 5"
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.frame = CGRect(x: 0, y: 0, width: 113, height: 20)
        return label
    }()
    
    let showButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(ColorPalette.blue.color, for: .normal)
        button.setTitle("Показать", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        // button.frame = CGRect(x: 0, y: 0, width: 147.5, height: 20)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = UIStackView.spacingUseSystem
        
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(completionLabel)
        addSubview(showButton)
        backgroundColor = ColorPalette.backPrimary.color
        //stackView.addArrangedSubview(completionLabel)
        //        let spacer = UIView()
        //        let spacerWidthConstraint = spacer.widthAnchor.constraint(equalToConstant: .greatestFiniteMagnitude)
        //        spacerWidthConstraint.priority = .defaultLow // ensures it will not "overgrow"
        //        spacerWidthConstraint.isActive = true
        //        stackView.addArrangedSubview(spacer)
        //        stackView.addArrangedSubview(showButton)
        configureContents()
    }
    
    func configureContents() {
        
        //        stackView.addArrangedSubview(completionLabel)
        //        stackView.addArrangedSubview(showButton)
        
        NSLayoutConstraint.activate([
            completionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            completionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            //completionLabel.topAnchor.constraint(equalTo: topAnchor),
            showButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            //showButton.leadingAnchor.constraint(equalTo: completionLabel.trailingAnchor, constant: 50),
            showButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        //        NSLayoutConstraint.activate([
        //            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        //            stackView.topAnchor.constraint(equalTo: topAnchor),
        //            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        //        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    func applyConstraints() {
    //        NSLayoutConstraint.activate([
    //            completionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 147),
    //            completionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
    //            showButton.topAnchor.constraint(equalTo: topAnchor, constant: 147),
    //            showButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
    //        ])
    //        
    //    }
}
