//
//  ViewController.swift
//  ToDo
//
//  Created by murphy on 7/29/22.
//

import UIKit

enum DetailOptionType {
    case switchCell(model: Deadline)
    case segemntedCell(model: Importance)
    case dateCell(model: Date)
}
struct Importance {
    let title: String
    let handler: (() -> Void)
    let importanceArray = [ "low", "basic", "important"]
    
}
struct Deadline {
    let title: String
    var isOn: Bool
    var date: Date
    let handler: (() -> Void)
}

struct Date {
    
}
class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        
        switch model.self {
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure()
            return cell
        case .segemntedCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedTableViewCell.identifier, for: indexPath) as? SegmentedTableViewCell else {
                return UITableViewCell()
            }
            cell.configure()
            return cell
        case .dateCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier, for: indexPath) as?
                    DateTableViewCell else {
                return UITableViewCell()
            }
            cell.configure()
            return cell
        default: return UITableViewCell()
        }
        
    }
    
    var models = [DetailOptionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.backgroundColor = .purple
        configureNavbar()
        view.addSubview(descriptionTextField)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        configureConstraints()
    }

    func configure() {
        models = [
            .switchCell(model: Deadline(title: "hello", isOn: true, date: Date(), handler: {
                
            })),
            .segemntedCell(model: Importance(title: "hell", handler: {
                
            })),
            .dateCell(model: Date())
            
        ]
    }
    private let descriptionTextField: UITextView = {
        var textField = UITextView()
       //textField.placeholder = "Что нужно сделать?"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .yellow
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        table.register(SegmentedTableViewCell.self, forCellReuseIdentifier: SegmentedTableViewCell.identifier)
        table.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private func configureNavbar() {
        navigationItem.title = "Задание"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(leftButtonAction(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: nil)
    }

    @objc func leftButtonAction(sender: UIButton) {
        print("left button")
    }
    
    func configureConstraints() {
        let descriptionTextFieldConstraints = [
            descriptionTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 150)
        ]
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300)
        ]
        NSLayoutConstraint.activate(descriptionTextFieldConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
    }
}

