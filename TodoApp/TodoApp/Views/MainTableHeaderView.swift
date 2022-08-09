import Foundation
import UIKit

final class MainTableHeaderView:  UIView {
    
    // MARK: - Private property
    
    private let completionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorPalette.tertiary.color
        label.text = "Выполнено — 5"
        return label
    }()
    
    private let showButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorPalette.blue.color, for: .normal)
        button.setTitle("Показать", for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchDown)
        return button
    }()
    
    @objc func save() {
        fileCache.save(to: "testTodoInput.json")
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        configureConstraints()
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
