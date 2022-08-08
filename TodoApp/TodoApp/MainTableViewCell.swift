//
//  MainTableViewCell.swift
//  TodoApp
//
//  Created by murphy on 8/6/22.
//

import UIKit
class MainTableViewCell: UITableViewCell{
    
    static let identifier = "MainTableViewCell"
    var isDone: Bool = false
    var itemImportance: TodoItem.Importance = .basic
    
    private lazy var circleView: UIImageView = {
        let view = UIImageView()
        if isDone == true {
            view.layer.cornerRadius = 12
            view.image = UIImage(systemName: "checkmark.circle.fill")
            //view.tintColor = .red
            view.backgroundColor = ColorPalette.green.color
            
        } else if itemImportance == .important {
            view.layer.cornerRadius = 12
            view.image = UIImage(systemName: "circle")
            view.tintColor = .red
            view.backgroundColor = ColorPalette.red.color
            view.layer.opacity = 0.2
            
        } else {
            view.layer.cornerRadius = 12
            view.image = UIImage(systemName: "circle")
            view.tintColor = .gray
            //view.backgroundColor = ColorPalette..color
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let toDoText: UITextView = {
        let text = UITextView()
        text.isScrollEnabled = false
        text.font = UIFont.systemFont(ofSize: 17)
        text.textContainer.maximumNumberOfLines = 3
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let chevron: UIImageView = {
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.backgroundColor = ColorPalette.gray.color
        chevron.translatesAutoresizingMaskIntoConstraints = false
        return chevron
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(circleView)
        addSubview(toDoText)
        addSubview(chevron)
        applyConstraints()
    }
    
    private func applyConstraints() {
        
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
    
    public func configure(with model: TodoItem) {
        toDoText.text = model.text
        itemImportance = model.importance
        isDone = model.done
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
