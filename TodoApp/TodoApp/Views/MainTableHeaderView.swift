// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import Foundation
import UIKit
import MyColors

final class MainTableHeaderView: UIView {
    
    var action: ((Bool) -> Void)?
    
    // MARK: - Private property
    
    private var isShowAll: Bool = false
    private lazy var completionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorPalette.tertiary.color
        label.text = "Выполнено — \(0) "
        return label
    }()
    
    private lazy var showButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorPalette.blue.color, for: .normal)
        button.setTitle("Показать", for: .normal)
        button.addTarget(self, action: #selector(didButtonTap), for: .touchUpInside)
        return button
    }()
    
    @objc private func didButtonTap() {
        isShowAll.toggle()
        action?(isShowAll)
    }
    
    // MARK: - Init
    convenience init(isShowAll: Bool, completedTasksNumber: Int) {
        self.init(frame: .zero)
        configure(isShowAll: isShowAll, completedTasksNumber: completedTasksNumber)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        configureConstraints()
    }
    
    func configure (isShowAll: Bool, completedTasksNumber: Int) {
        self.isShowAll = isShowAll
        completionLabel.text = "Выполнено — \(completedTasksNumber) "
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension MainTableHeaderView {
    
    func setUpLayout() {
        backgroundColor = ColorPalette.backPrimary.color
        [completionLabel, showButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            completionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            completionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            showButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            showButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
