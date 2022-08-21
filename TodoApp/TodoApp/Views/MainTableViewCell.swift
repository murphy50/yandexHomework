// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import UIKit
import MyColors

final class MainTableViewCell: UITableViewCell {
    
    // MARK: - Public property
    static let identifier = "MainTableViewCell"
    var isDone: Bool = false
    var itemImportance: TodoItem.Importance = .basic
    
    // MARK: - Private property
    
    private let circleView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        // view.image = UIImage(systemName: "circle".)
        view.tintColor = .red
        view.backgroundColor = ColorPalette.gray.color
        view.layer.opacity = 0.2
        return view
    }()
    
    public let toDoText: UITextView = {
        let text = UITextView()
        text.isScrollEnabled = false
        text.backgroundColor = .clear
        text.font = UIFont.systemFont(ofSize: 17)
        text.textContainer.maximumNumberOfLines = 3
        return text
    }()
    
    private let chevron: UIImageView = {
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.backgroundColor = ColorPalette.gray.color
        return chevron
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public method
    
    public func configure(with model: TodoItem) {
        if model.done {
            circleView.backgroundColor = ColorPalette.green.color
        } else if  model.importance == .important {
            circleView.backgroundColor = .red
        } else {
            circleView.backgroundColor = .gray
        }
        
        toDoText.text = model.text
        itemImportance = model.importance
        isDone = model.done
    }
}

// MARK: - Private methods

private extension MainTableViewCell {
    
    func setUpLayout() {
        [circleView, toDoText, chevron].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 24),
            circleView.heightAnchor.constraint(equalToConstant: 24),
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevron.heightAnchor.constraint(equalToConstant: 12),
            chevron.widthAnchor.constraint(equalToConstant: 7),
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            toDoText.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 12),
            toDoText.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -16),
            toDoText.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            toDoText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
