//
//  MainTableViewCell.swift
//  TodoApp
//
//  Created by murphy on 8/6/22.
//

import UIKit
protocol MainTableViewCellDelegate: AnyObject {
    func MainTableViewCellDidTapCell(_ cell: MainTableViewCell, model: TodoItem)
}

class MainTableViewCell: UITableViewCell{

    static let identifier = "MainTableViewCell"
    
    private let circleView: UIView = {
        let view = UIView()//(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        view.layer.cornerRadius = 12
        view.backgroundColor = ColorPalette.red.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let toDoText: UITextView = {
        let text = UITextView()
        text.backgroundColor = .blue
        text.isScrollEnabled = false
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
        backgroundColor = ColorPalette.backSecondary.color
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
            //circleView.bottomAnchor.constraint(equalTo:bottomAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            //chevron.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            chevron.heightAnchor.constraint(equalToConstant: 12),
            chevron.widthAnchor.constraint(equalToConstant: 7),
            //chevron.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
           // chevron.topAnchor.constraint(equalTo: topAnchor, constant: 16),
           // chevron.bottomAnchor.constraint(equalTo: contentView, constant: 16)
            toDoText.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 12),
            toDoText.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -16),
            toDoText.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            toDoText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    public func configure(with model: TodoItem) {
        toDoText.text = model.text
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
